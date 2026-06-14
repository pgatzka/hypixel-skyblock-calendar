# Fails (exit 1) if any unfilled FILL sentinel remains, i.e. /setup is incomplete.
# Files below reference the sentinel token by design (they implement/describe it),
# so they are exempt — they are never fill points.
$root = if ($env:CLAUDE_PROJECT_DIR) { $env:CLAUDE_PROJECT_DIR } else { (Get-Location).Path }
$exempt = @(
  'scripts/check-config.ps1',
  'scripts/check-config.sh',
  'SETUP-MANIFEST.md',
  '.claude/hooks/_lib.ps1',
  '.claude/hooks/_lib.sh',
  '.claude/skills/setup/SKILL.md'
)
$token = ('<<<' + 'FILL')
$files = Get-ChildItem -Path $root -Recurse -File | Where-Object { $_.FullName -notmatch '[\\/]\.git[\\/]' }
$hits = @()
foreach ($f in $files) {
    $rel = ($f.FullName.Substring($root.Length).TrimStart('\','/')) -replace '\\','/'
    if ($exempt -contains $rel) { continue }
    $m = Select-String -Path $f.FullName -Pattern $token -SimpleMatch -ErrorAction SilentlyContinue
    if ($m) { $hits += $m }
}
if ($hits.Count -gt 0) {
    Write-Error "Instance not configured. Unfilled placeholders remain:"
    $hits | ForEach-Object { Write-Host ("  {0}:{1}" -f $_.Path, $_.LineNumber) }
    exit 1
}
Write-Host "Config complete: no fill placeholders remain."
exit 0
