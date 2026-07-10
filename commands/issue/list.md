---
description: 등록된 issue 목록을 자연어로 보여준다 (alias ls)
---

# /issue:list — list issues

Apply the shared rule below first (injected once at entry, SSOT).

!`cat ${CLAUDE_PLUGIN_ROOT}/rules/worktree.md`

!`cat ${CLAUDE_PLUGIN_ROOT}/rules/wakeflow-ref.md`

Read `<project-root>/.claude/local/issues/_INDEX.md` and summarize in natural language. **If the file
does not exist, report no issues** (not an error). For each issue:

- One-line summary
- Show the slug in backticks as a secondary marker

If there are no issues, just say so briefly.
