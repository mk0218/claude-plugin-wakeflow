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
