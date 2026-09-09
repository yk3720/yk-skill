#Requires -Version 5.1
<#
  Cursor preToolUse (Write|StrReplace|Delete): yk-skill/rule の誤削除・壊滅縮小・L1 500行超を拒否。
  常に JSON のみを stdout へ出し、exit 0。失敗時は {"permission":"allow"}（fail open）。
  順序: Delete → 壊滅縮小 → L1 500行。
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-YkToolRoot {
    if ($env:YK_TOOL_ROOT -and (Test-Path -LiteralPath $env:YK_TOOL_ROOT)) {
        return [System.IO.Path]::GetFullPath($env:YK_TOOL_ROOT)
    }
    return 'c:\yk-tool'
}

function Get-JsonProp {
    param($Obj, [string]$Name)
    if ($null -eq $Obj) { return $null }
    $p = $Obj.PSObject.Properties[$Name]
    if ($null -eq $p) { return $null }
    return $p.Value
}


function Write-HookJson {
    param($Obj)
    $json = if ($Obj -is [string]) { $Obj } else { $Obj | ConvertTo-Json -Compress }
    $bytes = [System.Text.UTF8Encoding]::new($false).GetBytes(($json.Trim() + [Environment]::NewLine))
    [Console]::OpenStandardOutput().Write($bytes, 0, $bytes.Length)
}

function Write-Allow {
    Write-HookJson '{"permission":"allow"}'
    exit 0
}

function Write-Deny {
    param(
        [string]$UserMessage,
        [string]$AgentMessage
    )
    $obj = [ordered]@{
        permission    = 'deny'
        user_message  = $UserMessage
        agent_message = $AgentMessage
    }
    Write-HookJson $obj
    exit 0
}

function Get-LineCountFromPath {
    param([string]$CountPath)
    $gc = Get-Content -LiteralPath $CountPath -Encoding UTF8
    if ($null -eq $gc) { return 0 }
    return @($gc).Count
}

function Get-LineCountFromText {
    param([string]$Text)
    $tmp = [System.IO.Path]::GetTempFileName()
    try {
        $body = if ($null -eq $Text) { '' } else { [string]$Text }
        [System.IO.File]::WriteAllText($tmp, $body, [System.Text.UTF8Encoding]::new($false))
        return Get-LineCountFromPath -CountPath $tmp
    } finally {
        Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue
    }
}

function Get-ToolInputObject {
    param($Payload)
    $toolInput = Get-JsonProp $Payload 'tool_input'
    if ($toolInput -is [string] -and -not [string]::IsNullOrWhiteSpace($toolInput)) {
        $toolInput = $toolInput | ConvertFrom-Json
    }
    return $toolInput
}

function Get-FilePathFromPayload {
    param($Payload, $ToolInput)
    $filePath = [string](Get-JsonProp $Payload 'file_path')
    if ([string]::IsNullOrWhiteSpace($filePath)) {
        $filePath = [string](Get-JsonProp $ToolInput 'path')
    }
    if ([string]::IsNullOrWhiteSpace($filePath)) { return $null }

    if (-not [System.IO.Path]::IsPathRooted($filePath)) {
        $roots = @(Get-JsonProp $Payload 'workspace_roots')
        if ($roots.Count -gt 0 -and $roots[0]) {
            $filePath = Join-Path ([string]$roots[0]) $filePath
        }
    }
    return [System.IO.Path]::GetFullPath($filePath)
}

function Test-IsRuleMarkdown {
    param([string]$FilePath)
    if ([string]::IsNullOrWhiteSpace($FilePath)) { return $false }
    if (-not $FilePath.EndsWith('.md', [StringComparison]::OrdinalIgnoreCase)) { return $false }
    $normalized = ($FilePath -replace '\\', '/')
    return ($normalized -match '(?i)(^|/)yk-skill/rule(/|$)')
}

function Test-IsL1RulesFile {
    param([string]$FilePath)
    $fileName = [System.IO.Path]::GetFileName($FilePath)
    if ($fileName -notlike '*_RULES.md') { return $false }
    $normalized = ($FilePath -replace '\\', '/')
    if ($normalized -match '(?i)/references/') { return $false }
    return $true
}

function Get-ProposedText {
    param(
        [string]$ToolName,
        $Payload,
        $ToolInput,
        [string]$FilePath
    )
    if ($ToolName -match '(?i)^Write$') {
        $contents = Get-JsonProp $ToolInput 'contents'
        if ($null -eq $contents) { $contents = Get-JsonProp $Payload 'contents' }
        if ($null -eq $contents) {
            return @{ kind = 'unknown'; text = $null }
        }
        return @{ kind = 'text'; text = [string]$contents }
    }

    if ($ToolName -match '(?i)^StrReplace$') {
        if (-not (Test-Path -LiteralPath $FilePath -PathType Leaf)) {
            return @{ kind = 'unknown'; text = $null }
        }
        $old = Get-JsonProp $ToolInput 'old_string'
        $new = Get-JsonProp $ToolInput 'new_string'
        if ($null -eq $old) {
            return @{ kind = 'unknown'; text = $null }
        }
        $old = [string]$old
        if ($old.Length -eq 0) {
            return @{ kind = 'unknown'; text = $null }
        }
        if ($null -eq $new) { $new = '' }
        $new = [string]$new

        $current = [System.IO.File]::ReadAllText($FilePath, [System.Text.UTF8Encoding]::new($false))
        $replaceAll = $false
        $ra = Get-JsonProp $ToolInput 'replace_all'
        if ($ra -eq $true -or [string]$ra -eq 'true') { $replaceAll = $true }

        if ($replaceAll) {
            return @{ kind = 'text'; text = $current.Replace($old, $new) }
        }

        $idx = $current.IndexOf($old)
        if ($idx -lt 0) {
            return @{ kind = 'not_found'; text = $null }
        }
        $resulting = $current.Substring(0, $idx) + $new + $current.Substring($idx + $old.Length)
        return @{ kind = 'text'; text = $resulting }
    }

    return @{ kind = 'unknown'; text = $null }
}

try {
    $raw = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($raw)) { Write-Allow }

    $payload = $raw | ConvertFrom-Json
    $toolName = [string](Get-JsonProp $payload 'tool_name')
    $toolInput = Get-ToolInputObject -Payload $payload
    $filePath = Get-FilePathFromPayload -Payload $payload -ToolInput $toolInput

    if (-not $filePath) { Write-Allow }
    if (-not (Test-IsRuleMarkdown -FilePath $filePath)) { Write-Allow }

    if ($toolName -match '(?i)^Delete$') {
        Write-Deny -UserMessage 'rule 配下の削除を拒否しました。' -AgentMessage '[rule-delete-gate] yk-skill/rule の .md は Delete しない。削るなら StrReplace で小さく、またはユーザーが当ターンで削除を明示したときだけ。'
    }

    $proposed = Get-ProposedText -ToolName $toolName -Payload $payload -ToolInput $toolInput -FilePath $filePath
    if ($proposed.kind -ne 'text') { Write-Allow }

    $resultingLines = Get-LineCountFromText -Text $proposed.text

    $auditor = Join-Path (Get-YkToolRoot) 'scripts\audit-rule-line-counts.ps1'
    if (Test-Path -LiteralPath $auditor) {
        $jsonText = & $auditor -Path $filePath -Text $proposed.text -Json 2>$null
        if ($jsonText -is [array]) { $jsonText = $jsonText -join '' }
        $jsonText = [string]$jsonText
        if (-not [string]::IsNullOrWhiteSpace($jsonText)) {
            $aud = $jsonText | ConvertFrom-Json
            if (-not (Get-JsonProp $aud 'error')) {
                $al = Get-JsonProp $aud 'lines'
                if ($null -ne $al) { $resultingLines = [int]$al }
            }
        }
    }

    $currentExists = Test-Path -LiteralPath $filePath -PathType Leaf
    $currentLines = 0
    if ($currentExists) {
        $currentLines = Get-LineCountFromPath -CountPath $filePath
    }

    if ($currentExists -and $currentLines -ge 30) {
        $ratio = [double]$resultingLines / [double]$currentLines
        if ($resultingLines -le 10 -or $ratio -le 0.30) {
            $agent = '[rule-shrink-gate] 予定 ' + $resultingLines + ' 行 ← 元 ' + $currentLines + ' 行。30%以下または10行以下への縮小は誤削除とみなす。意図した分割なら L3 references/ へ移し、L1 は索引を残す。ユーザーが当ターンで大幅削除を明示したときだけ再実行。'
            Write-Deny -UserMessage 'ルール本文の大幅削除を拒否しました。' -AgentMessage $agent
        }
    }

    if (Test-IsL1RulesFile -FilePath $filePath) {
        $isShrinking = $currentExists -and ($resultingLines -lt $currentLines)
        if ($resultingLines -gt 500 -and -not $isShrinking) {
            $agent = '[rule-line-gate] FAIL 予定 ' + $resultingLines + ' 行 / 上限 500。L1 *_RULES.md は references/ へ分割してから書け。手計算せずこの数値を正とする。'
            Write-Deny -UserMessage 'L1 が 500 行を超えるため書き込みを拒否しました。' -AgentMessage $agent
        }
    }

    Write-Allow
} catch {
    Write-HookJson '{"permission":"allow"}'
    exit 0
}