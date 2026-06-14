#!/usr/bin/env sh
# Fails (exit 1) if any unfilled FILL sentinel remains. Mirrors check-config.ps1.
root="${CLAUDE_PROJECT_DIR:-$(pwd)}"
token='<<<FILL'
hits=$(grep -rl "$token" "$root" --exclude-dir=.git 2>/dev/null \
  | grep -vE '(scripts/check-config\.(ps1|sh)|SETUP-MANIFEST\.md|\.claude/hooks/_lib\.(ps1|sh)|\.claude/skills/setup/SKILL\.md)$')
if [ -n "$hits" ]; then
  echo "Instance not configured. Unfilled placeholders remain in:" 1>&2
  echo "$hits" 1>&2
  exit 1
fi
echo "Config complete: no fill placeholders remain."
exit 0
