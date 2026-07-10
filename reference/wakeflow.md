# Project Workflow

Personal work is managed as Tasks (in-progress units) and Issues (split-off to-dos). The `/task` and `/issue` commands — or natural-language intent — handle starting, updating, ending, and registering. When a task ends, it is compressed and moved to the archive.

## Concepts

- **Task**: A unit of work currently in progress. When finished, it is moved to the archive and removed from the task directory.
- **Subtask**: A work-unit split of a large task, living inside that task as its own directory (`tasks/<slug>/<sub-slug>/`) with the **same structure as a task** (README + optional file splits). The structure is recursive: any task or subtask is either a **leaf** (no child directories; its README `TODO` is ordinary checkboxes) or a **branch** (has child `<sub-slug>/` directories; its README `TODO` is a reference list to those children, one line each: `- [ ] → <sub-slug>/ (한 줄 설명)`). **Invariant**: child directories exist ⟺ the README `TODO` is a reference list to them. Splitting the *work* this way is distinct from file splitting, which splits one node's *document* into sections (`TODO.md`, `NOTES.md`). Leaf ⟷ branch is judged by child-directory presence, not by position under `tasks/`. Subtasks belong to their parent and are cleaned up with it; they are not independent like issues.
- **Issue**: A split-off to-do. Discovered during a task or coming in from outside. Exists independently until resolved.
- **Archive**: Compressed notes for finished tasks. Not loaded into context by default — read only when needed.

## Relationships

- One task ≠ one PR. 1:1, 1:N, and M:1 are all possible (1:1 or 1:N is typical).

## Directory Layout

Task docs live only in the **main worktree**. Linked worktrees (from `git worktree add`) branch off a ref
that usually predates these docs, so their own `.claude/local/tasks/` is stale or absent — always resolve
the main worktree (first entry of `git worktree list`) and read/write task docs there.

Per-project (`<project-root>/.claude/local/`):

- `tasks/<slug>/` — directory for an in-progress task
  - `README.md` — task body (default). Split incrementally into separate files (`TODO.md`, `PR.md`, `NOTES.md`, etc.) as sections grow large.
  - `<sub-slug>/` — a subtask directory, present only on a **branch** node (created via `/task:tidy`). Same structure as the parent (its own `README.md`, recursively splittable). The parent README's `TODO` then holds `→ <sub-slug>/` references instead of plain checkboxes.
- `issues/<slug>.md` — open issue
- `issues/_INDEX.md` — issue index
- `archive/<slug>/` — finished task folder — compressed notes `SUMMARY.md` + original doc `ARCHIVED.md` (subtask directories move here too if the task was a branch)
- `archive/_ARCHIVE.md` — archive index
- `docs/` — read-only reference material (domain/backend/frontend notes, etc.), **not task/issue/archive
  data**. Unlike the above, may exist independently per worktree — a linked worktree can have docs the
  main worktree lacks. Always check both the current and main worktree's `docs/` when looking something
  up here; if a doc exists only in the current (linked) worktree, flag it as worktree-local rather than
  shared.

Plugin (`${CLAUDE_PLUGIN_ROOT}`):

- `reference/wakeflow.md` — this document
- `templates/task.md` — task README template
- `templates/issue.md` — issue template
- `commands/task/` — task subcommands. Each doc is its own entry point (`/task:<sub>`) and injects the
  shared rules at the top via `` !`cat ${CLAUDE_PLUGIN_ROOT}/rules/…` ``: `start`·`update`·`tidy`·`end`·`list`·`todo`·`help`.
  `commands/task.md` (bare `/task`) loads the active task's context into the session — a supplement to the
  SessionStart hook, distinct from the `/task:todo` user-facing summary.
- `rules/` — shared rules the subcommands inject (SSOT). `worktree.md` (linked-worktree re-resolve),
  `target.md` (target task heuristic), `wakeflow-ref.md` (pointer to this doc).
- `commands/issue/` — issue subcommands (`create`·`start`·`list`·`help`). Each doc is its own entry
  point (`/issue:<sub>`). There is no dispatcher (`issue.md`) and no bare `/issue`.
- `hooks/hooks.json` + `hooks-handlers/active-task.sh` — SessionStart hook; finds the task matching the current branch and injects an `[active task]` pointer into context

## Slash Commands

Task and issue actions are direct subcommand calls — no argument dispatch:

- `/task:start <description>` (alias: `create`) — start a new task
- `/task:update [<slug>]` — reflect progress in the task README (and in any subtasks)
- `/task:tidy [<slug>]` — split one large task into work-unit subtasks
- `/task:end [<slug>]` — end the task; compress and move to archive
- `/task:list` (`ls`) — natural-language list of in-progress tasks
- `/task:todo` — summarize one in-progress task's status + next step
- `/task:help` — list of task subcommands and their usage
- `/task` — load the active task's context into the session (hook supplement)
- `/issue:create [<summary>]` — register a new issue
- `/issue:start <slug>` — start a task to handle the issue (the issue itself is kept)
- `/issue:list` (`ls`) — natural-language list of issues
- `/issue:help` — list of issue subcommands and their usage

Detailed behavior of each subcommand is in `${CLAUDE_PLUGIN_ROOT}/commands/task/<sub>.md` and `${CLAUDE_PLUGIN_ROOT}/commands/issue/<sub>.md`.

## Operating Principles

- **Areas Claude may update on its own**: Roadmap checkbox progress and brief notes in the task README can be updated proactively.
- **User-authored areas**: For large decisions or direction changes, Claude does not write them alone — ask the user to write directly.
- **Updates start only from an explicit request**: README updates begin when the user utters `/task:update` or a natural-language update trigger. Claude does not start or propose updates on its own (e.g., "Want me to show a diff?") just because a decision has been agreed on.
  - Once an update has started, it is normal for Claude to draft update candidates within it and refine/confirm them with the user.
  - The authority of one update is scoped to that utterance. It does not auto-extend to subsequent decisions or agreements in the same session — another explicit signal is required to update again.
- **Always confirm automatic matches**: Behavior like auto-matching related issues when starting a task is applied *only* after user confirmation.
- **Destructive operations require step-by-step confirmation**: File/directory deletions require user confirmation at each step.
- **Index/skeleton files are idempotent**: Index and skeleton directories (`tasks/`, `issues/`, `archive/`, `_INDEX.md`, `_ARCHIVE.md`) are created on demand if absent and preserved if present. Reading a missing index means "empty"; never overwrite an existing index.
- **Cross-session handoff is the user's responsibility**: When a session gets long, the user updates the task document directly before moving on (Claude does not guarantee automatic handoff between sessions).
- **The archive is compressed**: Do not record anything that can be recovered from `git diff` or the issue list. Record only non-obvious decisions and their reasons.
- **Keep task documents human-readable**: Put content only in the section it belongs to — `templates/task.md` states each section's purpose. Two rules cut across all sections: justification Claude added for its own choice (precedent citations, "matches the existing pattern") is dropped, not moved elsewhere; noun-ending sentences and minimal parentheticals are fine — implementation details (`on_delete`, etc.) belong in code, not prose.
- **Task file splitting is gradual**: Start with a single `README.md`. When a section grows large, split it into a separate file (e.g., `TODO.md`). The user decides when to split, or Claude may suggest it.
- **The workflow is a guide, not a mandate**: Apply flexibly depending on the situation.
