---
description: tools:setup이 추가한 설정(git 제외·자연어 트리거)을 항목마다 확인하며 제거한다
---

# /tools:cleanup — remove what /tools:setup added

Apply the shared rules below first (injected once at entry, SSOT).

<!-- include: worktree -->

<!-- include: setup-markers -->

<!-- include: wakeflow-ref -->

Go through the items below one by one. For each item, show what carries the setup markers and would be
removed, and **ask whether to remove it**; skip the item on no. Remove nothing that lacks the markers.

1. **`~/.claude/CLAUDE.md`** — remove the block from `<!-- wakeflow:begin -->` through
   `<!-- wakeflow:end -->`, inclusive. If the block holds a `<!-- wakeflow:replaced` comment, put that
   text back in the block's place.
2. **Global git exclude file** — remove each `# added by wakeflow` line together with the `.wakeflow/`
   line right after it.
3. **This repository's `info/exclude`** (only inside a git repository) — same as 2. If
   `<project-root>/.wakeflow/` still holds files, do not remove the exclusion (the data would become
   committable); report that instead.
4. Report that `<project-root>/.wakeflow/` data was left untouched, and that removing the plugin itself is
   `/plugin uninstall`.

Finish with a short summary: what was removed, what was skipped, and why.
