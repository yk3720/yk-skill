#Requires -Version 5.1
<#
.SYNOPSIS
  Deploy yk-skill cursor-permissions.json to %USERPROFILE%\.cursor\permissions.json

.PARAMETER Mode
  Symlink = 正本へのシンボリックリンク（編集はリポジトリのみ）
  Copy    = ファイルコピー（別 PC・リンク不可環境向け）
#>
[CmdletBinding()]
param(
    [ValidateSet('Symlink', 'Copy')]
    [string] $Mode = 'Copy',

    [string] $Source = '',
    [string] $Target = (Join-Path $env:USERPROFILE '.cursor\permissions.json')
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($Source)) {
    $scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
    $Source = Join-Path $scriptDir 'permissions.json'
}

if (-not (Test-Path -LiteralPath $Source)) {
    throw "Source not found: $Source"
}

$targetDir = Split-Path -Parent $Target
if (-not (Test-Path -LiteralPath $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}

$sourceFull = (Resolve-Path -LiteralPath $Source).Path

if (Test-Path -LiteralPath $Target) {
    $item = Get-Item -LiteralPath $Target -Force
    if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
        Remove-Item -LiteralPath $Target -Force
    }
    else {
        $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
        $backup = "$Target.bak-$stamp"
        Move-Item -LiteralPath $Target -Destination $backup -Force
        Write-Host "Backed up existing file to: $backup"
    }
}

switch ($Mode) {
    'Copy' {
        Copy-Item -LiteralPath $sourceFull -Destination $Target -Force
        Write-Host "Copied to: $Target"
    }
    'Symlink' {
        New-Item -ItemType SymbolicLink -Path $Target -Target $sourceFull -Force | Out-Null
        Write-Host "Symlinked: $Target -> $sourceFull"
    }
}

Write-Host "Done. Restart Cursor not required. Verify Command Allowlist in Settings -> Agents."
