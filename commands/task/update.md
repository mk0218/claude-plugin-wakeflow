---
description: task의 진행 상황(TODO·결정·로그 등)을 README에 반영한다
---

# /task:update [<slug>] — reflect progress into the task README

Apply the shared rules below first (injected once at entry, SSOT).

!`cat ${CLAUDE_PLUGIN_ROOT}/rules/worktree.md`

!`cat ${CLAUDE_PLUGIN_ROOT}/rules/target.md`

!`cat ${CLAUDE_PLUGIN_ROOT}/rules/wakeflow-ref.md`

Reflect current progress into the task README.

1. Infer the target task — use the target task heuristic above.
2. **Analyze the current session's conversation and extract candidates for updating each section of the README (or its split files)**:
   - **If the task is a branch (has `<sub-slug>/` child directories)**: reflect progress into the relevant subtask(s) — recursing into each subtask's own README/TODO (a subtask may itself be a branch) — and update the parent README's `TODO` reference-list checkboxes accordingly. Otherwise (leaf) update the README as below.
   - Front matter `branches` — if a new branch has appeared for this task (1:N), add it.
   - TODO checkbox progress (completed steps, new steps to add)
   - Core design decisions (add new items, or move undecided → decided with the reason recorded)
   - PR split (changed split strategy in a large task)
   - 메모 — only the tidied essentials worth referencing later (reference links, reusable conclusions). Do not put session narrative here.
   - 로그 (at the bottom) — accumulate session narrative / attempts / debugging traces here, with dates.
3. Show the changes to the user as a diff and update only after confirmation. If one section has clearly grown bloated, suggest splitting it into a separate file once.

Claude does not add large decisions or direction changes on its own — guide the user to write those directly.
