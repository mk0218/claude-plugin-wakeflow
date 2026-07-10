<!-- Shared rule (SSOT): target task heuristic. Injected by update·tidy·end·todo via
     !`cat ${CLAUDE_PLUGIN_ROOT}/rules/target.md` at entry. -->

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
