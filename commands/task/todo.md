---
description: 진행 중인 task 하나의 현재 상태와 다음 할 일을 요약한다
---

# /task:todo — summarize the current task

Apply the shared rules below first (injected once at entry, SSOT).

!`cat ${CLAUDE_PLUGIN_ROOT}/rules/worktree.md`

!`cat ${CLAUDE_PLUGIN_ROOT}/rules/target.md`

!`cat ${CLAUDE_PLUGIN_ROOT}/rules/wakeflow-ref.md`

Not a list — summarize **one in-progress task's current status + the immediate next step**.

1. **Pick the target task** — if the SessionStart hook (`active-task.sh`) injected an
   `[active task] … (slug) … README: <path>` pointer, use that task. Otherwise fall back to the
   target task heuristic's slug-omitted path (branch match → list in-progress tasks).
2. **Summarize** — read the target task's README and give (a) status so far and (b) the single next
   thing to do, concisely.
3. **If none** — briefly note there's no in-progress task and point to `/task:list` / `/task:start`.

For the full list, use `/task:list`.
