---
description: 진행 중인 task의 맥락을 현재 세션에 명시적으로 주입한다
---

# /task — load the current task's context

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
