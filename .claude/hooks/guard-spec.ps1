# Structural clarify-before-build gate.
# Blocks edits to SOURCE files unless an approved spec exists for the current branch.
# Always allows edits to planning surfaces (.claude/, docs/) so /frame and /plan can work.
# Fails open if git is unavailable, so the template never bricks a non-git project.
. (Join-Path $env:CLAUDE_PROJECT_DIR ".claude/hooks/_lib.ps1")

$payload = Read-HookInput
$target  = $null
if ($payload) { $target = $payload.tool_input.file_path }
if ([string]::IsNullOrWhiteSpace($target)) { exit 0 }   # nothing to judge

# Always-allowed planning surfaces (relative or absolute match).
$norm = $target -replace '\\', '/'
if ($norm -match '/\.claude/' -or $norm -match '/docs/' -or $norm -match '\.claude/' -or $norm -match '(^|/)docs/') { exit 0 }

# Is there an approved spec for this branch?
$statePath = Join-Path $env:CLAUDE_PROJECT_DIR ".claude/state/current-task.json"
$approved = $false
$branch = ""
try { $branch = (git rev-parse --abbrev-ref HEAD 2>$null) } catch { $branch = "" }
if ([string]::IsNullOrWhiteSpace($branch) -or $branch -eq "HEAD") { exit 0 }   # non-git or unborn branch -> fail open

# Never allow source edits directly on the default branch.
if ($branch -in @("main", "master")) {
    [Console]::Error.WriteLine("EDIT BLOCKED: you are on '$branch'. Create a task branch tied to a GitHub issue first (run /frame).")
    exit 2
}

if (Test-Path $statePath) {
    try {
        $state = Get-Content $statePath -Raw | ConvertFrom-Json
        if ($state.approved -eq $true -and $state.branch -eq $branch) { $approved = $true }
    } catch { $approved = $false }
}

if (-not $approved) {
    [Console]::Error.WriteLine("EDIT BLOCKED: no approved spec for branch '$branch'.")
    [Console]::Error.WriteLine("Run /frame to clarify the request and get sign-off. Code is built to an agreed contract, not a guess.")
    exit 2
}
exit 0
