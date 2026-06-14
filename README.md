# Claude Code Engineering Workflow (portable template)

A drop-in `.claude/` workflow that makes Claude Code behave like a disciplined
engineer: clarify before building, work to an agreed spec tracked as a GitHub
issue, gate every commit on tests, review adversarially, and ship only when the
clean-machine CI is green. Stack-agnostic — calibrated per repo by `/setup`.

## What's in here
- `CLAUDE.md` — the constitution, read every session.
- `.claude/skills/` — the phases: `setup`, `frame`, `plan`, `review`, `ship`.
- `.claude/agents/` — `explorer` (read-only recon) and `reviewer` (adversarial review).
- `.claude/hooks/` — gates: auto-format after edits, block commits on red tests,
  block source edits until a spec is approved. **Provided in both `.sh` and `.ps1`.**
- `.claude/gates.json` — the ONLY stack-specific file (filled by `/setup`).
- `.claude/settings.json` — least-privilege permissions + hook registrations.
- `.github/` — issue + PR templates and a stack-agnostic CI workflow.
- `docs/decisions/` — architecture decision records.
- `scripts/check-config.{sh,ps1}` — fails if any FILL placeholder remains.

## Cross-platform scripts
Every script ships in two flavours and the logic is identical:
- **`.sh`** (POSIX) — the wired default. Runs natively on Linux/macOS, and on
  Windows via Git Bash (installed with Git). CI uses these.
- **`.ps1`** (PowerShell 7+/`pwsh`) — the Windows-native alternative.

Per the Claude Code hooks docs, a hook command runs via `sh` on macOS/Linux,
Git Bash on Windows, or PowerShell when Git Bash isn't installed — so `.sh` is
the broadest single default. **To use PowerShell instead**, swap each hook's
`command` in `.claude/settings.json`, e.g.:
```json
{ "type": "command", "shell": "powershell",
  "command": "pwsh -NoProfile -File \"${CLAUDE_PROJECT_DIR}/.claude/hooks/guard-spec.ps1\"" }
```

## Prerequisites (PowerShell, Windows)
```powershell
winget install --id Git.Git          # provides git + Git Bash (the .sh hooks run here)
winget install --id GitHub.cli       # issues / PRs
gh auth login
# optional — only if you switch the hooks to the PowerShell variant:
winget install --id Microsoft.PowerShell
```
On Linux/macOS: install `git` and `gh` from your package manager; `sh` is already present.

## Install into a repo
```powershell
Copy-Item -Recurse -Force <template>\.claude  .\.claude
Copy-Item -Force        <template>\CLAUDE.md  .\CLAUDE.md
Copy-Item -Recurse -Force <template>\.github  .\.github
Copy-Item -Recurse -Force <template>\docs     .\docs
Copy-Item -Recurse -Force <template>\scripts  .\scripts
```
Then, inside Claude Code, run **`/setup`** once. It detects your stack, fills
`.claude/gates.json` and the `CLAUDE.md` placeholders, and verifies completeness.
See `SETUP-MANIFEST.md` for the exact list of what is project-specific.

## Optional one-time GitHub wiring
- Install the Claude GitHub app (for `@claude` in issues/PRs): run
  `/install-github-app` in Claude Code (repo admin required). *(Confirm the exact
  command against current Claude Code docs — it has changed before.)*
- Enable branch protection on `main` requiring the `gates` CI check before merge.
  This makes "shipped" = "passed the gates".

## Daily use
`/frame` → `/plan` → build → `/review` → `/ship`. Hooks enforce the gates; you
approve the spec and the plan.

## Notes
- The spec-gate hook (`guard-spec`) is the strictest piece. It fails *open*
  outside git or on a zero-commit repo, so it never bricks a fresh project.
  To loosen or disable it, remove its entry from `.claude/settings.json`.
