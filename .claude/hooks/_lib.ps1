# Shared helpers for workflow hooks. Cross-platform (PowerShell 7+, i.e. `pwsh`).
function Get-Gate([string]$name) {
    $path = Join-Path $env:CLAUDE_PROJECT_DIR ".claude/gates.json"
    if (-not (Test-Path $path)) { return "" }
    try { $g = Get-Content $path -Raw | ConvertFrom-Json } catch { return "" }
    $val = $g.$name
    if ($null -eq $val) { return "" }
    $val = [string]$val
    if ($val -match '<<<FILL') { return "" }   # unconfigured -> skip locally; CI check-config catches it
    return $val
}

function Read-HookInput {
    $raw = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($raw)) { return $null }
    try { return $raw | ConvertFrom-Json } catch { return $null }
}

function Invoke-Gate([string]$name) {
    $cmd = Get-Gate $name
    if ([string]::IsNullOrWhiteSpace($cmd)) { return $true }   # graceful degradation
    Write-Host "[gate:$name] $cmd"
    Invoke-Expression $cmd
    return ($LASTEXITCODE -eq 0)
}
