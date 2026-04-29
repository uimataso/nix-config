---
agent: build
description: Commit staged changes with a conventional commit message
---

Generate a Git commit message from the **staged diff only**.

Rules:
- If no staged changes exist, output nothing.
- Use Conventional Commits v1.0.0 only:
  <type>(optional scope): <summary>

Types:
feat, fix, docs, style, refactor, perf, test, build, chore, ci, revert
(use `chore` as fallback)

Format:
- Summary: imperative, lowercase, max 50 chars, no period
- Body: optional bullets (max 8), each:
  - start with "- "
  - sentence case
  - max 72 chars per line
- Blank line between summary and body

Scope:
- optional, lowercase, hyphenated (e.g. auth, ui/login)
- only if clearly inferred from changes

Rules:
- Only describe actual staged changes (no guessing)
- Group related changes
- For deps: build(deps): update <pkg> A→B
- For version bump: chore: bump version to vX.Y.Z
- For config: chore(config): update <thing>

Breaking changes:
- If any, add at end after blank line:
  BREAKING CHANGE: <description>

Output ONLY the commit message text.
No extra commentary.
