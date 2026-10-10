---
name: design-document-writer
description: Write or revise technical design documents, RFCs, and architecture proposals. Use when asked to plan a system or feature, document a design decision, or review and improve an existing design doc before implementation.
---

# Design document writer

Write a document that helps reviewers understand the problem, evaluate the proposed solution, and identify unresolved decisions. Do not implement the design unless the user asks.

## Workflow

1. Read `template.md` in this skill directory. Use it as the structure for the design document: copy it to the destination for a new document, or adapt an existing document to its structure without discarding established decisions. Fill out its headings with information about the actual design. The HTML comments are authoring prompts: use them to guide the content, then remove them from the finished document. Replace `{{title}}` and `{{date}}` with the document title and current date, and replace `{{project}}` with the project name when known and relevant (otherwise leave `projects` empty). Populate `customer` only when known and relevant. Preserve the frontmatter fields. For sections that genuinely do not apply, say so briefly rather than leaving headings empty.
2. Read relevant code, configuration, tests, existing design docs, and repository conventions before drafting. For **each missing detail**, look for an answer in the codebase and related documentation first. Distinguish observed facts from proposals; do not infer product requirements, owners, target dates, performance numbers, or approval from code alone.
3. If the codebase cannot answer a question needed to complete the template, ask the driver (the user) **one question at a time**. Wait for the answer before asking the next question. If the driver does not know or wants to defer a decision, record it as an open question in the document rather than inventing an answer. Do not bundle multiple questions into one message.
4. Explore credible alternatives, including keeping the current approach where relevant. Explain trade-offs and the rationale for the proposed direction. Keep design choices explicitly proposed until the driver or relevant decision maker approves them.
5. Use the destination requested by the driver. If none is given, follow the repository's naming and location conventions; if those are absent, suggest `docs/design/<topic>.md` and confirm the location with a single question before creating directories. For an existing document, use the template's structure while preserving useful context and decisions.
6. Check that every section is filled with relevant content or explicitly marked not applicable/deferred, and that no authoring comments or template variables remain. Review for accuracy and internal consistency, then summarize the proposal and remaining decisions for the driver.

Prefer concrete behavior and rationale over boilerplate. Do not implement the design unless the driver asks.
