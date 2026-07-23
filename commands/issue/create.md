---
description: 새 issue를 등록한다 (요약 또는 세션 맥락에서 할 일 추출)
---

# /issue:create [<summary>] — register a new issue

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

**Readability rule** — task/issue/archive documents are read by a human in a markdown viewer, not
just stored. Optimize the *rendered* view for scanning, even when it makes the raw markdown denser.

- **Prefer nested lists over one-line-per-item.** When an item has sub-details (a decision and its
  reason, options and their trade-offs, a step and its sub-tasks), nest them under the item instead
  of cramming everything onto one line. The rendered indentation is what makes structure legible.
- **Use tables where they help.** When several items share the same fields (options × criteria,
  candidates × trade-offs, status per PR/subtask), a table reads far better in a viewer than parallel
  prose lines — use one even though the raw markdown looks noisier.
- This is a formatting preference, not license to add content. Do not invent detail to fill a
  nested list or a table cell; keep to what the section actually holds ([[content-not-invented]]).

For concepts, directory layout, relationships, and operating principles, read
`${CLAUDE_PLUGIN_ROOT}/reference/wakeflow.md` first — skip if it's already in context.

1. If the `<summary>` argument is given, use it as the starting point; otherwise **extract the to-do the
   user wants to split off from the current session's conversation**.
2. From the extracted/summarized content, organize title, background, to-dos, and references, show them
   to the user, and propose an English slug (kebab-case, short and clear).
3. After the user confirms:
   - Using `${CLAUDE_PLUGIN_ROOT}/templates/issue.md` as reference, create `<project-root>/.claude/local/issues/<slug>.md`
   - Add one line to `<project-root>/.claude/local/issues/_INDEX.md` (slug, registration date, one-line summary)
4. If this was split off from an in-progress task (`.claude/local/tasks/`) or a task already ended and
   moved to archive (`.claude/local/archive/`), record the exact source as `task:<slug>` and briefly
   confirm with the user that the issue exists independently of the task.
