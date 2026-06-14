#!/usr/bin/env sh
# PreToolUse(Edit|Write): block source edits until a spec is approved for this branch.
# Allows edits to .claude/ and docs/. Fails open outside git.
. "${CLAUDE_PROJECT_DIR}/.claude/hooks/_lib.sh"
payload=$(cat)
target=$(printf '%s' "$payload" \
  | grep -oE '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -n1 \
  | sed -E 's/.*"file_path"[[:space:]]*:[[:space:]]*"([^"]*)".*/\1/')
[ -z "$target" ] && exit 0
norm=$(printf '%s' "$target" | tr '\\' '/')
case "$norm" in
  *"/.claude/"*|.claude/*|*"/docs/"*|docs/*) exit 0 ;;
esac
branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || branch=""
# unborn branch (fresh repo, zero commits) or non-git -> fail open
case "$branch" in ""|"HEAD") exit 0 ;; esac
if [ "$branch" = "main" ] || [ "$branch" = "master" ]; then
  echo "EDIT BLOCKED: you are on '$branch'. Create a task branch tied to a GitHub issue first (run /frame)." 1>&2
  exit 2
fi
state="${CLAUDE_PROJECT_DIR}/.claude/state/current-task.json"
approved="false"; sbranch=""
if [ -f "$state" ]; then
  approved=$(grep -oE '"approved"[[:space:]]*:[[:space:]]*(true|false)' "$state" | grep -oE '(true|false)$' | head -n1)
  sbranch=$(grep -oE '"branch"[[:space:]]*:[[:space:]]*"[^"]*"' "$state" | head -n1 | sed -E 's/.*:[[:space:]]*"([^"]*)".*/\1/')
fi
if [ "$approved" = "true" ] && [ "$sbranch" = "$branch" ]; then exit 0; fi
echo "EDIT BLOCKED: no approved spec for branch '$branch'." 1>&2
echo "Run /frame to clarify the request and get sign-off. Code is built to an agreed contract, not a guess." 1>&2
exit 2
