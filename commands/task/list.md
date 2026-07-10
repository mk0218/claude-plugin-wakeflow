---
description: 진행 중인 task 목록을 자연어로 보여준다 (alias ls)
---

# /task:list — list in-progress tasks

Apply the shared rule below first (injected once at entry, SSOT).

!`cat ${CLAUDE_PLUGIN_ROOT}/rules/worktree.md`

!`cat ${CLAUDE_PLUGIN_ROOT}/rules/wakeflow-ref.md`

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
