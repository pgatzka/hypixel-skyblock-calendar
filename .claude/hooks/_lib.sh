#!/usr/bin/env sh
# Shared helpers for workflow hooks (POSIX sh). No jq/python dependency.
# JSON extraction is key-anchored so it works regardless of pretty/compact formatting.

_gates_file() { echo "${CLAUDE_PROJECT_DIR}/.claude/gates.json"; }

get_gate() {
  name="$1"; f="$(_gates_file)"
  [ -f "$f" ] || return 0
  val=$(grep -oE "\"$name\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" "$f" | head -n1 \
        | sed -E "s/.*:[[:space:]]*\"([^\"]*)\".*/\1/")
  case "$val" in
    *'<<<FILL'*) return 0 ;;   # unconfigured -> skip
    "") return 0 ;;
    *) printf '%s' "$val" ;;
  esac
}

invoke_gate() {
  name="$1"; cmd=$(get_gate "$name")
  [ -z "$cmd" ] && return 0
  echo "[gate:$name] $cmd"
  sh -c "$cmd"
}
