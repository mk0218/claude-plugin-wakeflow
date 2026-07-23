---
description: 진행 중인 task 목록을 자연어로 보여준다 (alias ls)
---

# /task:list — list in-progress tasks

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

`list` / `ls`.

List the subdirectories under `<project-root>/.claude/local/tasks/`. For each task:

- One-line natural-language summary (based on the README title / one-line summary)
- One-line natural-language progress (based on TODO checkbox progress)
- Show the slug in backticks as a secondary marker

Output is shown to the user in Korean. Example:

```
진행 중인 task (2):

• OAuth refresh token 만료 처리 (`oauth_refresh_token_expiry`)
  토큰 갱신 로직 구현 완료, 테스트 작성 중

• Google Calendar 연차 sync (`google_calendar_leave_sync`)
  설계 단계, 권한 모델 결정 대기
```

If there are no in-progress tasks, just say so briefly.
