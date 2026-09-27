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
