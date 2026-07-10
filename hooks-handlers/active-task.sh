#!/usr/bin/env bash
# SessionStart hook: 현재 git 브랜치에 연결된 task를 찾아 컨텍스트로 주입한다.
# task README front matter의 `branches` 리스트와 현재 브랜치를 매칭한다.
# 매칭되는 task가 없으면 아무것도 출력하지 않는다.
set -euo pipefail

branch=$(git branch --show-current 2>/dev/null) || exit 0
[ -n "$branch" ] || exit 0

tasks_dir=".claude/local/tasks"
[ -d "$tasks_dir" ] || exit 0

for readme in "$tasks_dir"/*/README.md; do
  [ -f "$readme" ] || continue

  # front matter(첫 --- ~ --- 블록)의 branches 리스트에 현재 브랜치가 있는지 검사
  if awk -v b="$branch" '
      NR==1 && $0=="---" {fm=1; next}
      fm && $0=="---" {exit !found}
      fm && /^branches:/ {inlist=1; next}
      inlist && /^[^[:space:]-]/ {inlist=0}
      inlist && /^[[:space:]]*-/ {
        line=$0
        sub(/^[[:space:]]*-[[:space:]]*/, "", line)
        sub(/[[:space:]]*$/, "", line)
        if (line==b) found=1
      }
      END {exit !found}
    ' "$readme"; then

    slug=$(basename "$(dirname "$readme")")
    title=$(awk '/^# /{sub(/^# /,""); print; exit}' "$readme")
    ctx=$(printf '[active task] %s\n  → %s (%s)\n  README: %s' "$branch" "$title" "$slug" "$readme")
    jq -n --arg ctx "$ctx" \
      '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:$ctx}}'
    exit 0
  fi
done
exit 0
