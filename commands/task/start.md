---
description: 새 task를 시작한다 (설명→slug·개요 합의 후 README 생성; alias create)
---

# /task:start <description> (alias: create) — start a new task

Apply the shared rules below first (injected once at entry, SSOT).

!`cat ${CLAUDE_PLUGIN_ROOT}/rules/worktree.md`

!`cat ${CLAUDE_PLUGIN_ROOT}/rules/target.md`

!`cat ${CLAUDE_PLUGIN_ROOT}/rules/wakeflow-ref.md`

`create` is an alias for `start` — same behavior.

1. From `<description>`, **briefly summarize the task's requirements (goal & scope)** and propose an English slug (kebab-case, short and clear).
2. Let the user supplement/revise the outline, then **confirm the outline and slug together**.
3. Read `<project-root>/.claude/local/issues/_INDEX.md` and automatically check for open issues matching the confirmed outline. **If the index file does not exist, treat it as no open issues** (do not error). If there is a match, ask the user whether to use it as a seed; **if there is no match, silently pass** (do not report it).
4. Using `${CLAUDE_PLUGIN_ROOT}/templates/task.md` as reference, agree on the outline of each README section with the user — **propose briefly first → create the file only after the user revises/approves**. For sections marked `(선택)` (`배경`, `PR 분할`, `메모`), confirm with the user whether to include them based on task size.
5. Create `<project-root>/.claude/local/tasks/<slug>/README.md` with the agreed content (keep the template format). **Before writing, re-resolve `<project-root>` per the worktree rule above.** **A single file is the default.** If a large task is expected, some sections may be split into separate files (e.g. `TODO.md`) from the start.
   - Record the related branch under the front matter `branches`. If the current git branch already belongs to this task, fill it in automatically; otherwise leave a placeholder and the user fills it in once the branch is created.
6. If there is a seed issue, reflect its content in the relevant items under the README "배경" and record the issue slug under "관련 issue".
