---
name: document-reviewer
description: Review repository documentation for factual accuracy, currency, relevance, useful rationale, and missing updates. Use for a documentation audit or to review the documentation impact of a change, including when no docs were edited.
disable-model-invocation: true
---

# Document reviewer

Review only by default. Edit documentation only when asked to fix it.

## Scope and evidence

1. Identify the document's purpose, audience, and subject. Review the requested docs and use the repository's documentation index or contributor guidance to locate related docs. For a PR or branch, inspect the change from the review base, review changed docs, and look for unchanged docs whose claims or procedures the change affects. Keep that search tied to the change; do not audit the whole repository unless asked.
2. Use code at the relevant revision as the source of truth for **what the system does**. Trace the actual behavior through entry points, configuration, and defaults; use tests as corroboration. A branch's code does not prove what is deployed. If a doc targets a release or deployment, identify its revision or flag what you cannot verify.
3. Use applicable design docs and requirements as the source of truth for **intent**. If a statement describes behavior inaccurately, suggest correcting it. If the implementation violates a documented requirement, preserve the requirement and flag the mismatch as a potential implementation bug. Do not silently rewrite intent to match the code.
4. If the docs do not establish a rationale, use `git blame` on the relevant lines to find the change, then read its commit message and diff. Trace past mechanical edits with `git log` when needed. Commit history can support a rationale if it still applies; it does not override documented intent. If the evidence does not establish the reason, flag it as unverified rather than inferring it from the implementation.

## Review for relevance

- Write current-state docs for someone who never saw the previous version. Cut true but irrelevant change narration such as “the old endpoint was removed.” If the absence matters to the reader, state it as a present constraint and verify it.
- Keep supported rationale that explains a decision still in force, even if it does not change the reader's next action. Keep historical context when the document is meant to record it, or when the reader needs it for an upgrade, migration, or rollback.
- Do not delete a claim merely because you cannot verify it. Distinguish missing evidence from contradictory evidence.

## Deliver findings

Use all four headings below. Write one bullet per finding and write `None` under each empty heading. State the scope you checked so a clean review is distinguishable from a skipped one. Report irrelevant change narration under verified errors and omissions.

```markdown
## Verified errors and omissions
- `path:line` or section — what is wrong. Evidence: code, doc, config, test, or revision. Fix: smallest useful correction.

## Code–intent mismatches
- `path:line` — doc requires X, code does Y. Evidence: supporting doc and code references. Next step: investigate the implementation in the affected component.

## Unverified rationale
- `path:line` — claim. Searched: relevant docs, blame, commit, or PR. Result: missing or inconclusive. Next step: confirm with a source that establishes intent.

## Docs not checked
- Path, section, or target revision — what could not be checked and why.
```

In fix mode, correct verified documentation errors and omissions and remove irrelevant change narration. Report unresolved rationale and implementation–intent mismatches instead of guessing or changing code.
