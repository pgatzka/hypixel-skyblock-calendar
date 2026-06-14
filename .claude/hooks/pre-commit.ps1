# Fires before `git commit`. Enforces: no commit with red gates.
# Exit 2 = block the tool call (commit) and feed stderr back to Claude.
. (Join-Path $env:CLAUDE_PROJECT_DIR ".claude/hooks/_lib.ps1")

$failed = @()
foreach ($gate in @("lint", "typecheck", "test")) {
    if (-not (Invoke-Gate $gate)) { $failed += $gate }
}

if ($failed.Count -gt 0) {
    [Console]::Error.WriteLine("COMMIT BLOCKED. Failing gate(s): $($failed -join ', ').")
    [Console]::Error.WriteLine("Fix the failures (or add a regression test if this exposed a bug) before committing. Do not bypass.")
    exit 2
}
exit 0
