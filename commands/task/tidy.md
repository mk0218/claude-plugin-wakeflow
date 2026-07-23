---
description: 큰 task를 독립 진행 가능한 subtask 디렉토리들로 분할한다
---

# /task:tidy [<slug>] — split a large task into subtasks

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

Turns a **leaf** node into a **branch** by splitting its work into subtask directories. Use when a node
has grown too big to manage in the README alone, and its work naturally divides into
independently-progressing units. Applies to a task or, recursively, to a subtask that has itself grown
large. Identify the target with the target task heuristic above.

1. Read the node's README (and any split files) and **propose a subtask breakdown** — a list of work units,
   each with a short English sub-slug and a one-line scope. Splitting *work*, not the document: each unit
   should be able to progress/complete on its own. Show the plan first; create nothing yet.
2. After the user approves (before writing, re-resolve `<parent-dir>` per the worktree rule above):
   - Create a subtask directory per unit at `<parent-dir>/<sub-slug>/README.md`, using `${CLAUDE_PLUGIN_ROOT}/templates/task.md`
     — same structure as a task. Seed each subtask's 배경/할 일 from its scope.
   - Rewrite the parent README's `TODO` as a **reference list** to the new children — one line each:
     `- [ ] → <sub-slug>/ (한 줄 설명)`. Keep the rest of the parent README (배경, 핵심 설계 결정) as shared
     context; per-subtask logs now live in each subtask.
   - Maintain the invariant: child directories exist ⟺ parent `TODO` is a reference list to them.
3. Show what was created (subtask directories, rewritten parent `TODO`).

Do not over-split — only carve out units that genuinely progress independently. Purely documentary
sectioning stays as file splitting (`TODO.md` etc.), not subtasks.
