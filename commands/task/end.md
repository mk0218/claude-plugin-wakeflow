---
description: task를 종료한다 (압축 노트 SUMMARY + 원본을 archive 폴더로 보존)
---

# /task:end [<slug>] — end a task (compressed note + preserve the original in archive)

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

First determine the target task with the target task heuristic above. That heuristic must always offer
the *"위 어느 task도 아님 (미등록 task로 처리)"* fall-through to the unregistered branch below. If no task
matches (or `tasks/` is empty), go to the unregistered branch.

Before any write below, re-resolve `<project-root>` per the worktree rule above.

## Unregistered task (`/task:end` with no matching task)

Two possibilities:

- (a) Work done without `/task start`, but the user wants it archived → ask the user for a one-line summary and any non-obvious decisions, then create `<project-root>/.claude/local/archive/<slug>/SUMMARY.md` directly and update the `_ARCHIVE.md` index. (There is no original task doc to preserve, so only `SUMMARY.md` is created — no `ARCHIVED.md`.)
- (b) A mistaken call / no record needed → do nothing and exit.

Ask the user which it is.

## Compress & clean up

After the slug is confirmed:

1. Read every file under `<project-root>/.claude/local/tasks/<slug>/` (including any subtask directories) and extract **only the non-obvious information**:
   - Why this direction was chosen (decisions not visible from code alone — the `핵심 설계 결정` section)
   - Approaches tried and abandoned + why
   - **Discard**: generic progress logs, code change content (already in git log/diff). Follow-up work is handled as issues, so do not write it in the archive.
2. Create the compressed note at `<project-root>/.claude/local/archive/<slug>/SUMMARY.md`.
3. Add one line to the `<project-root>/.claude/local/archive/_ARCHIVE.md` index (slug, end date, one-line summary). The index links to the archive folder `<slug>/` (its `SUMMARY.md` is the entry point).
4. For each issue slug listed under "관련 issue" in the README "배경", confirm the handling with the user — if resolved, delete `<project-root>/.claude/local/issues/<issue-slug>.md` and update `_INDEX.md`; if unresolved, keep it.
5. If there is unresolved follow-up work, extract it as a new issue at `<project-root>/.claude/local/issues/<new-slug>.md` and update `_INDEX.md`.
6. After all cleanup is done, **preserve the original task doc**: move `<project-root>/.claude/local/tasks/<slug>/README.md` to `<project-root>/.claude/local/archive/<slug>/ARCHIVED.md` (rename so the folder's entry point stays `SUMMARY.md`, not a `README.md` that would be opened first). If the task is a branch, move its subtask directories under `archive/<slug>/` as well, keeping their structure. Then remove the now-empty `<project-root>/.claude/local/tasks/<slug>/` directory so it no longer shows as in-progress.

**Destructive operations (file/directory deletion) proceed only after step-by-step user confirmation.**
