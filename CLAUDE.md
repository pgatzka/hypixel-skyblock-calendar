# CLAUDE.md — Project Constitution

> Read this every session. It is the source of truth for how work happens here.
> Placeholders marked FILL are completed once by the `/setup` skill (see SETUP-MANIFEST.md).

## Project overview
A calendar app for Hypixel Skyblock in-game events. There is no official events
API, so a small set of trusted admins enter events (title, description, category,
start time stored in UTC, duration, recurrence) through an authenticated admin
panel; end users browse the calendar in a browser or as an installable Android
PWA and opt into reminders before chosen events/categories start. The backend is
a Spring Boot REST API (public read endpoints + admin auth and CRUD); the
frontend is a React + Vite PWA; reminders use Web Push (VAPID), with best-effort
local scheduling from synced event data when push is unavailable.

## Conventions
**Layout — monorepo:** the Spring Boot backend is the **root Maven project**
(`pom.xml` at the repo root; sources under `src/main/java`). The React + Vite PWA
lives in `frontend/`. Each gate in `.claude/gates.json` fans out to both.

**Backend:** Java 21, Spring Boot 4.x, Maven via the wrapper (`./mvnw`). Base
package `io.github.pgatzka.calendar`. Format with **Spotless**
(`spotless:apply` / `spotless:check`); lint / static analysis with **Sonar**
(`sonar:sonar` — needs a configured SonarQube/SonarCloud host + token).

**Frontend:** TypeScript, React, Vite (`vite-plugin-pwa` / Workbox for the
service worker + Web Push). Prettier (format), ESLint (lint), `tsc --noEmit`
(typecheck), Vitest + React Testing Library (test).

**Naming:** Java — PascalCase types, camelCase members, lowercase packages under
`io.github.pgatzka.calendar`. TypeScript — PascalCase components/types, camelCase
values, kebab-case filenames for non-components.

**Time & domain:** store all instants in UTC; format to the user's local timezone
in the client only. Model recurrence with RRULE (RFC 5545) rather than a bespoke
schema — repeating events are first-class.

**Error handling:** validate at the API boundary; backend returns RFC 7807
problem-detail responses via `@ControllerAdvice` and never leaks stack traces.
Frontend surfaces API failures gracefully and degrades (calendar still renders
from cache when offline).

**Test style (Spring Boot best practice):** tests must fail if the code is wrong.
Unit + slice tests (`@WebMvcTest`, `@DataJpaTest`, `@SpringBootTest`) run under
Surefire (`./mvnw test`); integration tests (`*IT`) run under Failsafe during
`verify`, with a **real database started by `io.fabric8:docker-maven-plugin`**
around the integration-test phase. Frontend uses Vitest + React Testing Library.
Cover recurrence expansion and timezone conversion explicitly.

**Commits:** Conventional Commits (`feat:`, `fix:`, `chore:`, …); PRs close their
issue with `Closes #N`.

## Gate commands
The stack-specific commands live in `.claude/gates.json` (the only stack-specific
file). Hooks and CI read it. Do not hardcode build/test/lint commands anywhere else.

## Operating principles (non-negotiable)

**You are building a product for a customer.** Build to an agreed spec, not to
your first guess. "Done" means the agreed acceptance criteria are met — not "it
runs."

**Clarify before build.** For any non-trivial task, run `/frame` first. Do not
edit source until there is an approved spec and a task branch. Building the wrong
thing correctly is the most expensive failure there is. (A hook enforces this.)

**Work in small, reversible steps.** One issue = one focused change. Anything
outside the agreed scope becomes a new issue, never a silent addition. No
gold-plating.

**Verify empirically, never assert.** "This should work" is worthless. Run it.
Trust artifacts you could re-run (test output, the diff, green CI), not your own
narration of what you did.

**Never make the same mistake twice.** When a bug is found, push the fix up this
ladder: (1) write it down in this file's Gotchas; (2) add a regression test that
fails without the fix; (3) where possible, add a lint/hook so the whole class
can't recur. A fix isn't done until at least tier 2.

**Know when to stop and ask.** If you're stuck or looping on the same failure,
stop. Surface what you tried, the blocker, and the decision you need — don't
thrash. Use rewind to abandon a bad path rather than patching over it.

**Least privilege.** Don't run destructive or irreversible commands. Never put
secrets in code. Treat adding a dependency as a decision: verify the package
exists and is maintained before introducing it.

## The loop (per task)
1. **/frame** — clarify → spec + acceptance criteria → GitHub issue + task branch.
2. **/plan** — recon (explorer) → design → steps → test strategy → approval.
3. **Build** — small steps; post-edit hook formats automatically.
4. **Verify** — tests that fail if the code is wrong; pre-commit hook runs lint/typecheck/test.
5. **/review** — reviewer subagent; resolve all blockers.
6. **/ship** — Definition of Done → conventional commit → PR with `Closes #N`.
7. **Remember** — record decisions in `docs/decisions/`; add any new Gotcha below.

## Definition of Done (universal shape; specifics come from the issue + gates.json)
Acceptance criteria met · tests written and green · reviewer SHIP · regression
test for any bug fixed · docs updated if behavior changed · clean-machine CI green.

## Gotchas (grow this over time)
_(none yet — add as you discover them; each should ideally become a test or lint rule.)_
