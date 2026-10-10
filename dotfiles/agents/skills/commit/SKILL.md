---
name: commit
description: Create a git commit. Use this skill when commiting in a git repo. Only load this skill if the repo has no commit conventions. Otherwise use the repo's conventions.
---

# Commit Guidelines

Good commit messages are a permanent record of why and how code changes over time. They serve code reviewers, debugging sessions (`git blame`, `git log`), and automated changelog generation via `git-cliff`.

These guidelines are adapted from [Google's CL Description Guide](https://google.github.io/eng-practices/review/developer/cl-descriptions.html)

---

## Fixup commits

**Fixup commits:** when committing a fix, use `git commit --fixup=<hash>` targeting the commit the fix belongs to, not a fresh commit.

---

## Commit Message Structure

A commit message consists of:

1. **Subject line** (first line): A concise summary in the imperative mood, optionally prefixed for release notes.
2. **Blank line**.
3. **Body**: Detailed explanation of *why* the change is made and *what* it does.
4. **Footers / Disclosures**: Issue references and agent attributions.

```text
<subject>

<detailed body explaining why and what>

Assisted-by: TOOL:MODEL
```

---

## Subject Line

### Format & Imperative Mood

The first line must be a concise summary written in the **imperative mood** (e.g., "Add feature", "Fix bug", not "Added feature" or "Fixes bug").

### Release Note Prefixes

Use `git-cliff` (`cliff.toml`) to generate end-used facing changelogs

**Prefix the subject ONLY when a user would notice the change.**
Ask: *Would this line belong in release notes someone reads?* If yes, prefix it. If no, leave it unprefixed.

These are the only types parsed by `cliff.toml` — do not invent others:

| Type       | Use for                                                     |
| ---------- | ----------------------------------------------------------- |
| `feat:`    | New capability players or external API consumers can use    |
| `fix:`     | Broken behaviour players or external API consumers hit      |
| `balance:` | Game-balance tuning (damage, costs, rates, health)          |
| `chore:`   | User-noticeable housekeeping worth listing in release notes |

Write the messages so they are understandable to non-technical people.

#### Fix message

In fix messages say **what was fixed**, what behavior no longer happens instead of saying what the fix was.

#### Prefixed Examples (User-Visible)

```text
feat: Add exit button to the client
fix: Registration rejects a blank colour instead of 422-ing
balance: Reduce ranged attack falloff
chore: Update default keybindings to match WASD layout
```

#### Unprefixed Examples (Internal / Dev-Only)

Internal changes (tests, refactors, docs, CI, admin endpoints, build tooling) should **not** have a type prefix:

```text
Migrate site from pnpm to npm
Add patch user admin endpoint
Remove obsolete hints in queen loop
Fix flakiness in bot movement integration test
Update Kubernetes deploy manifests for redis
```

> **Rule of thumb:** `sim/`, `brengin-client/`, and player-facing `site/` pages are typically user-visible. `api/` admin endpoints, `deployment/`, `docs/`, tests, refactors, and tooling are internal.
>
> Recent history may be mostly unprefixed because recent work was internal — do not read `git log` as an excuse to omit prefixes on user-facing features, or to prefix internal changes.

---

## Commit Body

The body provides the context and reasoning that cannot fit into a single subject line.

### What to Include

1. **Why is this change being made?**
   - What problem does it solve?
   - What was the previous behavior or state?
   - Provide enough background so future maintainers reading `git log` or `git blame` understand the context without having to dig through old tickets or chat logs.

2. **What does the change do?**
   - Summarize the approach taken.
   - Highlight non-obvious design decisions, trade-offs, or constraints.
   - Do not merely restate the diff (e.g. "Changed foo from true to false"); explain *why* foo needed to be changed.

3. **For Bug Fixes:**
   - **Symptom:** What went wrong from the user or system perspective?
   - **Root Cause:** Why was the system behaving this way?
   - **Resolution:** How does this change resolve the bug and prevent regression?

4. **Caveats / Follow-ups:**
   - Note any known limitations, performance implications, or future work planned.

---

## Agent Commit Disclosure

When committing changes, automated agents **must** disclose their involvement at the end of the commit message using the Crush attribution format:

```text
Assisted-by: TOOL:MODEL
```

For example:

```text
Assisted-by: pi:anthropic/claude-3-7-sonnet
```

---

## Examples

### Good: User-Facing Bug Fix

```text
fix: Registration rejects a blank colour instead of 422-ing

Users submitting an empty color field during registration received a 422
Unprocessable Entity error from the API due to unhandled None values in the
input schema validator.

Handle empty string inputs explicitly by falling back to the default player
color swatch before invoking the database registration workflow.

Assisted-by: pi:anthropic/claude-3-7-sonnet
```

### Good: User-Facing Feature

```text
feat: Add exit button to the desktop client pause menu

Players currently have to use Alt+F4 or window controls to close the desktop
client during a game session.

Add an "Exit to Desktop" button to the pause menu UI that triggers a clean
teardown of the Bevy app, disconnecting any active real-time WebSocket session
first.

Assisted-by: pi:anthropic/claude-3-7-sonnet
```

### Good: Balance Change

```text
balance: Reduce ranged attack falloff

Ranged bots were underperforming in wide-open room engagements because damage
dropped to 10% past 3 tiles.

Flatten the falloff curve so attacks retain 50% effectiveness at maximum range,
encouraging kiting strategies against melee swarm builds.

Assisted-by: pi:anthropic/claude-3-7-sonnet
```

### Good: Internal Refactoring (Unprefixed)

```text
Extract commit guidelines from AGENTS.md into docs/commits.md

AGENTS.md contained inline commit subject rules and disclosure requirements,
making the agent guide lengthy and duplicating conventions.

Move all commit guidelines, subject prefix conventions, body formatting
practices, and agent disclosures into a dedicated docs/commits.md document,
referencing it from AGENTS.md and docs/agents/docs-AGENTS.md.

Assisted-by: pi:anthropic/claude-3-7-sonnet
```

### Bad Examples to Avoid

| Bad Commit Message | Problem |
|--------------------|---------|
| `fix: bug` | Vague subject; no body explaining symptom, cause, or fix. |
| `refactor: clean up sim` | Invented prefix (`refactor:` is not in `cliff.toml`); no explanation of what was cleaned or why. |
| `feat: misc updates` | Bundles unrelated changes under a vague description. |
| `Update AGENTS.md` | Restates the file changed without explaining what changed or why. |
| `WIP` | Commits should represent cohesive, functioning units of work. |
