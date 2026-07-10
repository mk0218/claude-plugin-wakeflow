---
description: task를 종료한다 (압축 노트 SUMMARY + 원본을 archive 폴더로 보존)
---

# /task:end [<slug>] — end a task (compressed note + preserve the original in archive)

Apply the shared rules below first (injected once at entry, SSOT).

!`cat ${CLAUDE_PLUGIN_ROOT}/rules/worktree.md`

!`cat ${CLAUDE_PLUGIN_ROOT}/rules/target.md`

!`cat ${CLAUDE_PLUGIN_ROOT}/rules/wakeflow-ref.md`

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
