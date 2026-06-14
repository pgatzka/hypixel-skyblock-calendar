---
name: ship
description: Use to finish a task — runs the Definition of Done, writes a clean conventional commit, and opens a PR that closes the issue. Only ship when every gate is green.
---

# Ship — close the loop honestly

Run the **Definition of Done** as a checklist. Each item must be backed by an
artifact you could re-run, not by your say-so:

- [ ] Every acceptance criterion in the issue is met.
- [ ] Tests written for this change; the gate suite is green (pre-commit hook passed).
- [ ] Reviewer returned SHIP; all blockers resolved.
- [ ] Any bug this fixed has a regression test.
- [ ] Docs/README updated if behavior or usage changed.
- [ ] No secrets, debug code, or out-of-scope changes in the diff.

Then:
1. Commit with a conventional message: `type(scope): summary` (feat/fix/chore/docs/refactor/test).
2. Push the branch.
3. Open the PR with `gh pr create`, and put `Closes #<issue>` in the body so the
   merge auto-closes the issue. Include a short "what & why" and how it was verified.
4. The PR's CI (clean-machine run) is the final gate. "Works in my session" is not "works."

If anything is red, you are not done. Do not narrate success without the green checks.
