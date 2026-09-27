---
description: wakeflow 사용 환경(git 제외·자연어 트리거)을 항목마다 확인하며 설정한다
---
<!-- generated from src/commands/tools/setup.md by scripts/build; edit the source, not this file -->

# /tools:setup — apply wakeflow's environment setup

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

Go through the items below one by one. For each item, show the current state and the exact change, and
**ask whether to do it**; skip the item on no. To undo this setup, the user runs `/wakeflow:tools:cleanup`.

1. **Git exclusion of `.wakeflow/`**
   - Check whether it is already excluded, and if so show where and skip:
     - Inside a git repository: `git check-ignore -v .wakeflow/` (run from `<project-root>`).
     - Outside a git repository: whether the global exclude file already has a `.wakeflow/` line.
   - Ask where to add the exclusion:
     - **Global** (default) — applies to every repository, so offer it even when `<project-root>` is not
       a git repository.
     - **This repository only** — offer it only inside a git repository.
   - Append the marker lines to the chosen file (create it if absent).
2. **Natural-language triggers in `~/.claude/CLAUDE.md`**
   - **If the block is already there**, compare its content with the block below, ignoring a
     `<!-- wakeflow:replaced` comment inside it. If they match, report that and skip. If they differ (an
     older version of the block), show the difference and ask whether to update; on yes, replace only
     the content between the markers and keep the `<!-- wakeflow:replaced` comment as it is.
   - **If the file has a hand-written section outside the block** that routes task/issue intents to
     wakeflow (for example a section mentioning `/wakeflow:`), show the whole section, heading
     included, and ask which to do:
     - **Add** — keep the section and add the block (only when there is no block yet).
     - **Replace** — show the exact range to be removed (the whole section, heading included) and
       confirm it. Then remove it and put the block at its position, with the removed text preserved
       in a `<!-- wakeflow:replaced` comment as the setup markers describe. If the removed text itself
       contains `-->`, it cannot be kept in a comment: say so and ask the user to save it elsewhere
       before replacing.
     - **Skip** — change nothing.

     Do not edit or remove the user's own lines in any other way.
   - When adding a new block, ask where to put it. The file may prescribe its own section order (for
     example a section that must stay last), so propose a position that respects it rather than always
     appending.
   - The block content, inserted verbatim:

     ```markdown
     <!-- wakeflow:begin -->
     ## wakeflow

     task/issue 관리는 wakeflow 플러그인이 맡는다. 작업 시작·진행 기록·마무리, 할 일 분리·조회 같은 의도가
     보이면 해당 `/wakeflow:*` 커맨드를 제안하고, 사용자가 확인한 뒤에만 실행한다. 예:

     - "이거 작업 시작하자" → `/wakeflow:task:start`
     - "뭐 해야 되지" → `/wakeflow:task:list`
     - "지금까지 한 거 task에 정리해 두자" → `/wakeflow:task:update`
     - "이건 나중에 하자" → `/wakeflow:issue:create`
     <!-- wakeflow:end -->
     ```

3. If legacy data exists under `<project-root>/.claude/local/` (`tasks/`·`issues/`·`archive/`), mention
   `/wakeflow:tools:migrate`.

Finish with a short summary: what was changed, what was skipped, and why.
