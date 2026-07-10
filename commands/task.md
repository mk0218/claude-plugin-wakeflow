---
description: 진행 중인 task의 맥락을 현재 세션에 명시적으로 주입한다
---

# /task — load the current task's context

Apply the shared rules below first (injected once at entry, SSOT).

!`cat ${CLAUDE_PLUGIN_ROOT}/rules/worktree.md`

!`cat ${CLAUDE_PLUGIN_ROOT}/rules/target.md`

!`cat ${CLAUDE_PLUGIN_ROOT}/rules/wakeflow-ref.md`

Primary purpose: **load the task into Claude's working context**, not to produce a user-facing report.
The SessionStart hook (`active-task.sh`) already injects a one-line pointer, but a long session drifts
or the pointer alone is thin — this command re-grounds the session by actually reading the task.
For a user-facing "status + next step" summary, use `/task:todo` instead.

1. **Pick the target task** — if the hook injected an `[active task] … (slug) … README: <path>`
   pointer, use it. Otherwise fall back to the target task heuristic's slug-omitted path
   (branch match → list in-progress tasks). If a slug argument is given, use that task.
2. **Read the README fully** — read the target task's whole README (background, decisions, open
   questions, TODO, log), not just the summary lines. This is the point: absorb it as context for the
   work that follows.
3. **Acknowledge briefly** — confirm which task is now loaded in one or two lines (slug + where it
   stands), then continue with whatever the user does next. Do NOT expand into a full status report
   unless asked — that is `/task:todo`'s job.
4. **If none** — briefly note there's no in-progress task and point to `/task:list` / `/task:start`.

$ARGUMENTS
