---
description: issue 서브커맨드 목록과 각각의 용법을 보여준다
---

# /issue:help — issue subcommand guide

Print the list below to the user verbatim (list only, no extra commentary).

```
issue 서브커맨드:

• /issue:create [요약]   새 issue 등록 (인자 없으면 세션 맥락에서 자동 추출)
• /issue:start <slug>    지정 issue 처리용 새 task 시작 (issue는 유지)
• /issue:list (ls)       등록된 issue 목록
• /issue:help            이 목록

issue 종료: 보통 그 issue를 처리한 task를 /task:end 할 때 자동 삭제된다
(task README "처리한 issue" 섹션 기준). 명시적으로 issue만 닫으려면 사용자가
직접 issues/<slug>.md 삭제 + _INDEX.md 갱신을 요청한다.
```
