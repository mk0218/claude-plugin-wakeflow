---
description: 새 issue를 등록한다 (요약 또는 세션 맥락에서 할 일 추출)
---

# /issue:create [<summary>] — register a new issue

Apply the shared rule below first (injected once at entry, SSOT).

!`cat ${CLAUDE_PLUGIN_ROOT}/rules/worktree.md`

!`cat ${CLAUDE_PLUGIN_ROOT}/rules/wakeflow-ref.md`

1. If the `<summary>` argument is given, use it as the starting point; otherwise **extract the to-do the
   user wants to split off from the current session's conversation**.
2. From the extracted/summarized content, organize title, background, to-dos, and references, show them
   to the user, and propose an English slug (kebab-case, short and clear).
3. After the user confirms:
   - Using `${CLAUDE_PLUGIN_ROOT}/templates/issue.md` as reference, create `<project-root>/.claude/local/issues/<slug>.md`
   - Add one line to `<project-root>/.claude/local/issues/_INDEX.md` (slug, registration date, one-line summary)
4. If this was split off from an in-progress task (`.claude/local/tasks/`) or a task already ended and
   moved to archive (`.claude/local/archive/`), record the exact source as `task:<slug>` and briefly
   confirm with the user that the issue exists independently of the task.
