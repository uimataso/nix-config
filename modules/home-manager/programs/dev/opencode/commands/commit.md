---
agent: build
description: Generate and optionally apply a conventional commit
---

Goal:
Generate a commit message from the staged diff, then wait for user confirmation before committing.

Steps:
1. Read staged diff only.
2. If no staged changes exist → output nothing and exit.
3. Generate commit message following rules below.
4. Show the message.
5. Ask: "Commit with this message? (y/n)"
6. Only if user replies "y" or "yes":
   - run: git commit -m "<summary>" -m "<body>"
7. Otherwise: do nothing.

Rules:
- Use Conventional Commits v1.0.0 only:
  <type>(optional scope): <summary>

Types:
feat, fix, docs, style, refactor, perf, test, build, chore, ci, revert
(use `chore` as fallback)

Format:
- Summary:
  - imperative, lowercase, max 50 chars, no period
- Body:
  - optional bullets (max 8)
  - each starts with "- "
  - sentence case
  - max 72 chars per line
- Blank line between summary and body

Scope:
- optional, lowercase, hyphenated (e.g. auth, ui/login)
- only if clearly inferred from changes

Rules:
- Only describe actual staged changes (no guessing)
- Group related changes

Special cases:
- Deps: build(deps): update <pkg> A→B
- Version: chore: bump version to vX.Y.Z
- Config: chore(config): update <thing>

Breaking changes:
- Append at end:

  BREAKING CHANGE: <description>
