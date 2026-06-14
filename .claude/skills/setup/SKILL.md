---
name: setup
description: Use ONCE right after creating a repo from this template. Fills in the project-specific parts defined in SETUP-MANIFEST.md and verifies nothing was missed. Run this before /frame.
---

# Setup — calibrate the instance

Your job is narrow and exact: fill **every** `<<<FILL: ...>>>` sentinel listed in
`SETUP-MANIFEST.md`, and nothing else. Everything else in this repo is frozen.

1. **Read `SETUP-MANIFEST.md`.** It is the authoritative list of what is project-specific.
2. **Detect the toolchain** (`package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`,
   `Makefile`, etc.) and **propose** concrete gate commands. Examples — match what's
   actually present, never assume:
   - Node/TS: format `npm run format`, lint `npm run lint`, typecheck `npm run typecheck`, test `npm test`, build `npm run build`
   - Python: format `ruff format .`, lint `ruff check .`, typecheck `mypy .`, test `pytest`, build `""`
   - Rust: format `cargo fmt`, lint `cargo clippy`, typecheck `""`, test `cargo test`, build `cargo build`
3. **Confirm with the user**, then fill the sentinels:
   - `.claude/gates.json` — the 5 commands (use `""` to skip a gate; graceful degradation).
   - `CLAUDE.md` — Project overview + Conventions (Gotchas stays empty).
   - `.github/workflows/ci.yml` — the toolchain block (or delete it if none needed).
4. **Generate `.claude/settings.local.json`** allowing the gate commands to run without
   prompting, e.g. `{ "permissions": { "allow": ["Bash(npm run *)", "Bash(npm test*)"] } }`.
5. **Verify completeness:** run `pwsh -File scripts/check-config.ps1`. It must report
   zero remaining `<<<FILL>>>`. If not, you missed one.
6. Point the user to `README.md` for the remaining manual steps (gh auth, GitHub app,
   branch protection requiring the `gates` CI check).

Do not edit any frozen file. Do not hardcode gate commands outside `.claude/gates.json`.
