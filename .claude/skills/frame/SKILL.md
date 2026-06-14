---
name: frame
description: Use at the START of any non-trivial task, before writing or planning code. Turns a vague request into an agreed spec with acceptance criteria, captured as a GitHub issue. This is the clarify-before-build gate — do not skip it to start coding.
---

# Frame — clarify before build

You are building a product for a customer. Your job here is to make sure you
understand what they actually need BEFORE any code exists. Building the wrong
thing correctly is the most expensive failure there is.

Assume the request is under-specified. Do NOT fill gaps with assumptions —
surface them.

1. **Understand the real goal.** What problem is behind the request? (Users often
   describe a solution when they have a problem. Dig to the problem.)
2. **Surface assumptions and unknowns.** State the assumptions you'd otherwise
   make. Where there's real latitude to build the wrong thing, ASK — batched,
   specific, with options where possible. (Use the question tool, not prose.)
   If the request is genuinely unambiguous and low-stakes, say so and proceed.
3. **Define scope.** What's explicitly IN and explicitly OUT. Out-of-scope ideas
   become separate issues, never silent additions.
4. **Write acceptance criteria** — the concrete, checkable conditions that mean
   "done and correct" for THIS task. These become the definition of done.
5. **Get explicit sign-off** from the user on the spec.
6. **Materialize the contract:**
   - Create the issue: `gh issue create --title "<title>" --body "<spec>"`
   - Create a task branch named for the issue: `git switch -c <number>-<slug>`
   - Record approval so editing is unlocked: write `.claude/state/current-task.json`
     with `{ "issue": <number>, "branch": "<number>-<slug>", "approved": true }`.

Only after sign-off and the branch+marker exist should source editing begin.
