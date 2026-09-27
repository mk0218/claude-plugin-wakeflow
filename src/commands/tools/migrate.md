---
description: 이 레포의 옛 wakeflow 데이터(.claude/local/)를 .wakeflow/로 옮긴다
---

# /tools:migrate — move legacy data from .claude/local/ to .wakeflow/

Apply the shared rules below first (injected once at entry, SSOT).

<!-- include: worktree -->

<!-- include: wakeflow-ref -->

Earlier versions of wakeflow kept their data under `<project-root>/.claude/local/`. This command moves it
to `<project-root>/.wakeflow/`, where every other command now reads it.

1. Re-resolve `<project-root>` per the worktree rule above. In a non-git directory, `<project-root>` is
   the current directory.
2. Look for `tasks/`, `issues/`, and `archive/` under `<project-root>/.claude/local/`. If none exists,
   report that there is nothing to migrate and stop.
   - If `<project-root>/.claude/local` is itself a symlink, show its target and ask before going on.
3. Show the list with a rough size of each (number of entries), and the destination
   `<project-root>/.wakeflow/<name>/`.
   - If a destination already exists, do not move that one. Show both sides and ask the user how to
     proceed (for example merging by hand).
4. After the user confirms, create `<project-root>/.wakeflow/` if needed and move each directory with `mv`.
5. Leave everything else in `.claude/local/` as it is — it is not wakeflow data. If `.claude/local/` is
   left empty, ask whether to remove the empty directory.
6. Linked worktrees may point at the old location through a `.claude/local` symlink. Leave those
   symlinks alone.
7. If `<project-root>` is in a git repository and `git check-ignore -q .wakeflow/` fails, tell the user
   that `.wakeflow/` is not excluded from git yet and offer `/wakeflow:tools:setup`.

Finish with a short summary of what was moved and what was left in place.
