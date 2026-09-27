#!/usr/bin/env bash
# SessionStart hook: 옛 위치(.claude/local/)에 wakeflow 데이터가 남아 있으면 migrate를 제안하도록 알린다.
# 옛 데이터가 없으면 아무것도 출력하지 않는다.
set -euo pipefail

# Task docs live only in the main worktree (first entry of `git worktree list`); outside git, use the cwd.
root=$(git worktree list --porcelain 2>/dev/null | awk '/^worktree /{print substr($0, 10); exit}') || true
[ -n "$root" ] || root=$PWD

legacy="$root/.claude/local"
found=()
for name in tasks issues archive; do
  [ -e "$legacy/$name" ] && found+=("$name/")
done
((${#found[@]})) || exit 0

ctx=$(printf '[wakeflow] legacy data found in %s (%s). wakeflow now reads %s/.wakeflow/. At the very start of your first reply, before addressing the user'\''s request, tell the user that legacy wakeflow data was found and ask whether to run /wakeflow:tools:migrate now. Move nothing without their confirmation.' \
  "$legacy" "${found[*]}" "$root")
jq -n --arg ctx "$ctx" \
  '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:$ctx}}'
