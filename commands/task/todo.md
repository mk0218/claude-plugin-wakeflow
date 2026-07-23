---
description: 진행 중인 task 하나의 현재 상태와 다음 할 일을 요약한다
---

# /task:todo — summarize the current task

Apply the shared rules below first (injected once at entry, SSOT).

**Worktree rule** — task/issue/archive docs (`.claude/local/`'s `tasks/`·`issues/`·`archive/`) exist
**only in the main worktree**. A linked worktree (created via `git worktree add`) is usually branched
off a ref that predates these docs, so its own copy is stale or absent. Therefore, when the current
working directory is a linked worktree, re-resolve `<project-root>` to the **main worktree** (the first
entry of `git worktree list`) and read/write under that `.claude/local/` — never the linked worktree's
own path.

- Read-side (`list`·`update`·`todo`): re-resolve **before** locating the task. Otherwise you read the
  linked worktree's empty `tasks/` and wrongly report "no in-progress task".
- Write-side (`start`·`tidy`·`end`): re-resolve **immediately before** creating/moving files.

This rule applies even when a subcommand is invoked directly (`/task:update`, etc.) — every subcommand
is its own entry point.

**Target task heuristic** — determine which task the user means. This is a *candidate proposal*, never a
silent decision.

**If a slug is given** — check whether a task folder matches that slug. If none, the subcommand handles
it (`end` falls through to its unregistered branch).

**If the slug is omitted** — never confirm a sole candidate as-is. Candidate priority:

1. If a task's front matter `branches` contains the current git branch (or the branch substring-matches
   a task slug), present that task as the first candidate.
2. Otherwise, list the in-progress tasks with natural-language summaries.

For `end`, the confirmation message must **always include the option *"위 어느 task도 아님 (미등록 task로
처리)"*** so the user can fall through — even when there is only a single task. If
`<project-root>/.claude/local/tasks/` is empty → the unregistered branch.

For concepts, directory layout, relationships, and operating principles, read
`${CLAUDE_PLUGIN_ROOT}/reference/wakeflow.md` first — skip if it's already in context.

Not a list — summarize **one in-progress task's current status + the immediate next step**.

1. **Pick the target task** — if the SessionStart hook (`active-task.sh`) injected an
   `[active task] … (slug) … README: <path>` pointer, use that task. Otherwise fall back to the
   target task heuristic's slug-omitted path (branch match → list in-progress tasks).
2. **Summarize** — read the target task's README and give (a) status so far and (b) the single next
   thing to do, concisely.
3. **If none** — briefly note there's no in-progress task and point to `/task:list` / `/task:start`.

For the full list, use `/task:list`.
