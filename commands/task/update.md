---
description: task의 진행 상황(TODO·결정·로그 등)을 README에 반영한다
---

# /task:update [<slug>] — reflect progress into the task README

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

Reflect current progress into the task README.

1. Infer the target task — use the target task heuristic above.
2. **Analyze the current session's conversation and extract candidates for updating each section of the README (or its split files)**:
   - **If the task is a branch (has `<sub-slug>/` child directories)**: reflect progress into the relevant subtask(s) — recursing into each subtask's own README/TODO (a subtask may itself be a branch) — and update the parent README's `TODO` reference-list checkboxes accordingly. Otherwise (leaf) update the README as below.
   - Front matter `branches` — if a new branch has appeared for this task (1:N), add it.
   - TODO checkbox progress (completed steps, new steps to add)
   - Core design decisions (add new items, or move undecided → decided with the reason recorded)
   - PR split (changed split strategy in a large task)
   - 메모 — only the tidied essentials worth referencing later (reference links, reusable conclusions). Do not put session narrative here.
   - 로그 (at the bottom) — accumulate session narrative / attempts / debugging traces here, with dates.
3. Show the changes to the user as a diff and update only after confirmation. If one section has clearly grown bloated, suggest splitting it into a separate file once.

Claude does not add large decisions or direction changes on its own — guide the user to write those directly.
