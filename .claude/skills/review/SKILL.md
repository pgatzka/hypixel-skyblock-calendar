---
name: review
description: Use after implementing a change and before shipping. Runs an adversarial review of the diff via the reviewer subagent, then ensures every finding is resolved or consciously accepted.
---

# Review — adversarial check before ship

1. Make sure the work is committed or staged so there's a real diff to review.
2. Delegate to the `reviewer` subagent. It reviews the diff against the
   acceptance criteria plus edge cases, regressions, security, tests, and
   convention drift, and returns findings by severity ending in SHIP / DO NOT SHIP.
3. **Resolve every BLOCKER.** For anything that exposed a bug, the fix is not done
   until there's a regression test that fails without it (see CLAUDE.md ladder).
4. Re-review if blockers were fixed. Do not proceed to /ship on DO NOT SHIP.

Trust the artifacts, not your own narration: if you claim it's fixed, the diff
and a passing test must show it.
