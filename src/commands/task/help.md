---
description: task 서브커맨드 목록과 각각의 용법을 보여준다
---

# /task:help — task subcommand guide

Print the list below to the user verbatim (list only, no extra commentary).

```
task 서브커맨드:

• /task:start <설명>   새 task 시작 (alias: create) — 설명에서 slug·개요 합의 후 README 생성
• /task:update [slug]  진행 상황(TODO·결정·로그)을 task README에 반영
• /task:tidy [slug]    큰 task를 독립 진행 가능한 subtask 디렉토리들로 분할
• /task:end [slug]     task 종료 — 압축 노트(SUMMARY) + 원본을 archive로 보존
• /task:list (ls)      진행 중인 task 목록
• /task:todo           현재 진행 중인 task 하나의 상태 + 다음 할 일 요약
• /task:help           이 목록
```
