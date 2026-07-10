---
description: 지정한 issue를 처리하기 위한 새 task를 시작한다 (issue는 유지)
---

# /issue:start <slug> — start a task to handle an issue

Apply the shared rule below first (injected once at entry, SSOT).

!`cat ${CLAUDE_PLUGIN_ROOT}/rules/worktree.md`

!`cat ${CLAUDE_PLUGIN_ROOT}/rules/wakeflow-ref.md`

Start a *new task* to handle the given issue.

1. Read `<project-root>/.claude/local/issues/<slug>.md` to review the issue content.
2. From here, follow `${CLAUDE_PLUGIN_ROOT}/commands/task/start.md` (use the issue content as a seed; record the
   issue slug under the README "처리한 issue" section).
3. **Leave the issue in place** — resolution happens separately, typically auto-cleaned on `/task:end`.
