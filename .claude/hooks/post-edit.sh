#!/usr/bin/env sh
# PostToolUse(Edit|Write): auto-format only (fast).
. "${CLAUDE_PROJECT_DIR}/.claude/hooks/_lib.sh"
if ! invoke_gate format; then
  echo "Formatter reported problems. Review the output above before continuing." 1>&2
fi
exit 0
