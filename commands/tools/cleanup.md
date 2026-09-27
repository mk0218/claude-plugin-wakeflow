---
description: tools:setup이 추가한 설정(git 제외·자연어 트리거)을 항목마다 확인하며 제거한다
---
<!-- generated from src/commands/tools/cleanup.md by scripts/build; edit the source, not this file -->

# /tools:cleanup — remove what /tools:setup added

Apply the shared rules below first (injected once at entry, SSOT).

**Worktree rule** — task/issue/archive docs (`.wakeflow/`'s `tasks/`·`issues/`·`archive/`) exist
**only in the main worktree**. A linked worktree (created via `git worktree add`) is usually branched
off a ref that predates these docs, so its own copy is stale or absent. Therefore, when the current
working directory is a linked worktree, re-resolve `<project-root>` to the **main worktree** (the first
entry of `git worktree list`) and read/write under that `.wakeflow/` — never the linked worktree's
own path.

- Read-side (`list`·`update`·`todo`): re-resolve **before** locating the task. Otherwise you read the
  linked worktree's empty `tasks/` and wrongly report "no in-progress task".
- Write-side (`start`·`tidy`·`end`): re-resolve **immediately before** creating/moving files.

This rule applies even when a subcommand is invoked directly (`/task:update`, etc.) — every subcommand
is its own entry point.

**Setup markers** — `/wakeflow:tools:setup` marks everything it adds, and `/wakeflow:tools:cleanup`
removes only what carries these marks. Never delete anything under `<project-root>/.wakeflow/` — it is the
user's work data.

- **Git exclusion** — the two lines `# added by wakeflow` and `.wakeflow/`, in one of:
  - the global exclude file: the file named by `git config --global core.excludesFile`, or
    `${XDG_CONFIG_HOME:-~/.config}/git/ignore` when that is unset;
  - a repository's `$(git rev-parse --git-common-dir)/info/exclude`, shared by all its worktrees.
- **Natural-language triggers** — a block in `~/.claude/CLAUDE.md` between `<!-- wakeflow:begin -->` and
  `<!-- wakeflow:end -->`. When the block replaced a section the user wrote, the removed text is kept as
  the first thing inside the block, so that clean-up can put it back:

  ```markdown
  <!-- wakeflow:begin -->
  <!-- wakeflow:replaced
  (the removed text, verbatim)
  -->
  …block content…
  <!-- wakeflow:end -->
  ```

For concepts, directory layout, relationships, and operating principles, read
`${CLAUDE_PLUGIN_ROOT}/reference/wakeflow.md` first — skip if it's already in context.

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
