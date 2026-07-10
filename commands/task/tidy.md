---
description: 큰 task를 독립 진행 가능한 subtask 디렉토리들로 분할한다
---

# /task:tidy [<slug>] — split a large task into subtasks

Apply the shared rules below first (injected once at entry, SSOT).

!`cat ${CLAUDE_PLUGIN_ROOT}/rules/worktree.md`

!`cat ${CLAUDE_PLUGIN_ROOT}/rules/target.md`

!`cat ${CLAUDE_PLUGIN_ROOT}/rules/wakeflow-ref.md`

Turns a **leaf** node into a **branch** by splitting its work into subtask directories. Use when a node
has grown too big to manage in the README alone, and its work naturally divides into
independently-progressing units. Applies to a task or, recursively, to a subtask that has itself grown
large. Identify the target with the target task heuristic above.

1. Read the node's README (and any split files) and **propose a subtask breakdown** — a list of work units,
   each with a short English sub-slug and a one-line scope. Splitting *work*, not the document: each unit
   should be able to progress/complete on its own. Show the plan first; create nothing yet.
2. After the user approves (before writing, re-resolve `<parent-dir>` per the worktree rule above):
   - Create a subtask directory per unit at `<parent-dir>/<sub-slug>/README.md`, using `${CLAUDE_PLUGIN_ROOT}/templates/task.md`
     — same structure as a task. Seed each subtask's 배경/할 일 from its scope.
   - Rewrite the parent README's `TODO` as a **reference list** to the new children — one line each:
     `- [ ] → <sub-slug>/ (한 줄 설명)`. Keep the rest of the parent README (배경, 핵심 설계 결정) as shared
     context; per-subtask logs now live in each subtask.
   - Maintain the invariant: child directories exist ⟺ parent `TODO` is a reference list to them.
3. Show what was created (subtask directories, rewritten parent `TODO`).

Do not over-split — only carve out units that genuinely progress independently. Purely documentary
sectioning stays as file splitting (`TODO.md` etc.), not subtasks.
