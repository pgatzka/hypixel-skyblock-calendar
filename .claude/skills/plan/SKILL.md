---
name: plan
description: Use after /frame and before writing code, for any change beyond trivial. Produces a reviewed implementation plan — design, step breakdown, and test strategy. Best run in plan mode so nothing is edited until you approve.
---

# Plan — design before building

1. **Recon.** For anything touching unfamiliar code, delegate to the `explorer`
   subagent to map relevant files, conventions, reusable abstractions, and blast
   radius. Keep that detail out of the main context.
2. **Design.** Choose an approach. Note 1–2 alternatives and why you rejected
   them. Match the grain of the existing codebase; reuse before you reinvent.
3. **Step breakdown.** Small, individually verifiable steps, each leaving the
   tree green. No giant single change.
4. **Test strategy.** State, per acceptance criterion, the test that will prove
   it. A test must be able to FAIL if the code is wrong.
5. **Present the plan and get approval before editing.** If you discover the spec
   was wrong mid-plan, stop and go back to /frame — don't build the wrong thing.
