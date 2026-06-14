#!/usr/bin/env sh
# PreToolUse(Bash, git commit*): block the commit if lint/typecheck/test fail.
. "${CLAUDE_PROJECT_DIR}/.claude/hooks/_lib.sh"
failed=""
for gate in lint typecheck test; do
  if ! invoke_gate "$gate"; then failed="$failed $gate"; fi
done
if [ -n "$failed" ]; then
  echo "COMMIT BLOCKED. Failing gate(s):$failed." 1>&2
  echo "Fix the failures (or add a regression test if this exposed a bug) before committing. Do not bypass." 1>&2
  exit 2
fi
exit 0
