# Runs after every Edit/Write. Keeps it cheap: format only.
. (Join-Path $env:CLAUDE_PROJECT_DIR ".claude/hooks/_lib.ps1")
$ok = Invoke-Gate "format"
# Format failures are advisory here, not blocking — surface to Claude via stderr.
if (-not $ok) {
    [Console]::Error.WriteLine("Formatter reported problems. Review the output above before continuing.")
}
exit 0
