---
description: 새 task를 시작한다 (설명→slug·개요 합의 후 README 생성; alias create)
---

# /task:start <description> (alias: create) — start a new task

Apply the shared rules below first (injected once at entry, SSOT).

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

**Target task heuristic** — determine which task the user means. This is a *candidate proposal*, never a
silent decision.

**If a slug is given** — check whether a task folder matches that slug. If none, the subcommand handles
it (`end` falls through to its unregistered branch).

**If the slug is omitted** — never confirm a sole candidate as-is. Candidate priority:

1. If a task's front matter `branches` contains the current git branch (or the branch substring-matches
   a task slug), present that task as the first candidate.
2. Otherwise, list the in-progress tasks with natural-language summaries.

For `end`, the confirmation message must **always include the option *"위 어느 task도 아님 (미등록 task로
처리)"*** so the user can fall through — even when there is only a single task. If
`<project-root>/.claude/local/tasks/` is empty → the unregistered branch.

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

`create` is an alias for `start` — same behavior.

1. From `<description>`, **briefly summarize the task's requirements (goal & scope)** and propose an English slug (kebab-case, short and clear).
2. Let the user supplement/revise the outline, then **confirm the outline and slug together**.
3. Read `<project-root>/.claude/local/issues/_INDEX.md` and automatically check for open issues matching the confirmed outline. **If the index file does not exist, treat it as no open issues** (do not error). If there is a match, ask the user whether to use it as a seed; **if there is no match, silently pass** (do not report it).
4. Using `${CLAUDE_PLUGIN_ROOT}/templates/task.md` as reference, agree on the outline of each README section with the user — **propose briefly first → create the file only after the user revises/approves**. For sections marked `(선택)` (`배경`, `PR 분할`, `메모`), confirm with the user whether to include them based on task size.
5. Create `<project-root>/.claude/local/tasks/<slug>/README.md` with the agreed content (keep the template format). **Before writing, re-resolve `<project-root>` per the worktree rule above.** **A single file is the default.** If a large task is expected, some sections may be split into separate files (e.g. `TODO.md`) from the start.
   - Record the related branch under the front matter `branches`. If the current git branch already belongs to this task, fill it in automatically; otherwise leave a placeholder and the user fills it in once the branch is created.
6. If there is a seed issue, reflect its content in the relevant items under the README "배경" and record the issue slug under "관련 issue".
