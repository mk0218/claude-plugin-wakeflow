---
description: 지정한 issue를 처리하기 위한 새 task를 시작한다 (issue는 유지)
---

# /issue:start <slug> — start a task to handle an issue

Apply the shared rule below first (injected once at entry, SSOT).

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

For concepts, directory layout, relationships, and operating principles, read
`${CLAUDE_PLUGIN_ROOT}/reference/wakeflow.md` first — skip if it's already in context.

Start a *new task* to handle the given issue.

1. Read `<project-root>/.claude/local/issues/<slug>.md` to review the issue content.
2. From here, follow `${CLAUDE_PLUGIN_ROOT}/commands/task/start.md` (use the issue content as a seed; record the
   issue slug under the README "처리한 issue" section).
3. **Leave the issue in place** — resolution happens separately, typically auto-cleaned on `/task:end`.
