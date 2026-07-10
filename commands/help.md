---
description: wakeflow 개요와 task·issue 서브커맨드 목록을 보여준다
---

# /wakeflow:help — wakeflow command guide

Print the block below to the user verbatim (list only, no extra commentary).

```
wakeflow — 개인 작업을 진행 중 task와 나중에 처리할 issue로 관리하는 작업 흐름.

[task] 진행 중인 작업 단위

• /wakeflow:task <설명 없음>       활성 task 맥락을 세션에 주입 (요약 아님)
• /wakeflow:task:start <설명>      새 task 시작 (alias: create) — slug·개요 합의 후 README 생성
• /wakeflow:task:update [slug]     진행 상황(TODO·결정·로그)을 task README에 반영
• /wakeflow:task:tidy [slug]       큰 task를 독립 진행 가능한 subtask 디렉토리들로 분할
• /wakeflow:task:end [slug]        task 종료 — 압축 노트(SUMMARY) + 원본을 archive로 보존
• /wakeflow:task:list (ls)         진행 중인 task 목록
• /wakeflow:task:todo              현재 진행 중인 task 하나의 상태 + 다음 할 일 요약
• /wakeflow:task:help             task 서브커맨드 상세 목록

[issue] 갈래로 뺀 할 일

• /wakeflow:issue:create [요약]    새 issue 등록 (인자 없으면 세션 맥락에서 자동 추출)
• /wakeflow:issue:start <slug>     지정 issue 처리용 새 task 시작 (issue는 유지)
• /wakeflow:issue:list (ls)        등록된 issue 목록
• /wakeflow:issue:help            issue 서브커맨드 상세 목록
```
