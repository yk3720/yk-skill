#Requires -Version 5.1
<#
  Cursor postToolUse (Write|StrReplace): yk-skill/rule の .md 行数・文字数を additional_context に注入。
  常に JSON のみを stdout へ出し、exit 0（編集はブロックしない）。
  L1 の FAIL も注入する。壊滅縮小・Delete は preToolUse（before-rule-edit.ps1）側。
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

function Write-EmptyJson {
    Write-HookJson '{}'
    exit 0
}

try {
    $raw = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($raw)) { Write-EmptyJson }

    $payload = $raw | ConvertFrom-Json

    $filePath = [string](Get-JsonProp $payload 'file_path')
    if ([string]::IsNullOrWhiteSpace($filePath)) {
        $toolInput = Get-JsonProp $payload 'tool_input'
        if ($toolInput -is [string] -and -not [string]::IsNullOrWhiteSpace($toolInput)) {
            $toolInput = $toolInput | ConvertFrom-Json
        }
        $filePath = [string](Get-JsonProp $toolInput 'path')
    }

    if ([string]::IsNullOrWhiteSpace($filePath)) { Write-EmptyJson }

    if (-not [System.IO.Path]::IsPathRooted($filePath)) {
        $roots = @(Get-JsonProp $payload 'workspace_roots')
        if ($roots.Count -gt 0 -and $roots[0]) {
            $filePath = Join-Path ([string]$roots[0]) $filePath
        }
    }
    $filePath = [System.IO.Path]::GetFullPath($filePath)

    if (-not $filePath.EndsWith('.md', [StringComparison]::OrdinalIgnoreCase)) { Write-EmptyJson }

    $normalized = ($filePath -replace '\\', '/')
    if ($normalized -notmatch '(?i)(^|/)yk-skill/rule(/|$)') { Write-EmptyJson }

    $auditor = Join-Path (Get-YkToolRoot) 'scripts\audit-rule-line-counts.ps1'
    if (-not (Test-Path -LiteralPath $auditor)) { Write-EmptyJson }

    $jsonText = & $auditor -Path $filePath -Json 2>$null
    if ($jsonText -is [array]) { $jsonText = $jsonText -join '' }
    $jsonText = [string]$jsonText
    if ([string]::IsNullOrWhiteSpace($jsonText)) { Write-EmptyJson }

    $result = $jsonText | ConvertFrom-Json
    if (Get-JsonProp $result 'error') { Write-EmptyJson }

    $status = [string](Get-JsonProp $result 'status')
    $kind = [string](Get-JsonProp $result 'kind')
    $lines = Get-JsonProp $result 'lines'
    $chars = Get-JsonProp $result 'chars'
    $rel = [string](Get-JsonProp $result 'rel')

    $isL1 = ($kind -eq 'L1')
    $isWarnOrFail = ($status -eq 'WARN' -or $status -eq 'FAIL')
    if (-not $isL1 -and -not $isWarnOrFail) { Write-EmptyJson }

    $contextLines = @(
        "[rule-line-count] $status  ${lines}行 / ${chars}文字  $rel"
        'L1 理想 ~250行 · 500超は references/ へ。手計算せずこの数値を正とする。'
    )
    if ($isL1 -and $status -eq 'FAIL') {
        $contextLines += 'L1 が 500 行超のまま。新規肥大は preToolUse が拒否する。分割は references/ へ。'
    }
    if ($kind -eq 'L3-ref' -and $isWarnOrFail) {
        $contextLines += 'L3 references の 250超は分割必須ではない。L1 *_RULES.md のみ 250 が理想。'
    }

    $context = $contextLines -join "`n"
    Write-HookJson ([ordered]@{ additional_context = $context })
    exit 0
} catch {
    Write-HookJson '{}'
    exit 0
}
