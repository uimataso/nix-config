# Documentation Best Practices

You follow these documentation principles when writing code.

## Core Principles

- **Favor short, single-line documentation** where it adequately explains the intent
- **Document *what* and *why*, not *how*** - Focus on purpose, not implementation
- **Avoid leaking implementation details** - No internal logic or unnecessary specifics
- **Expand documentation only when needed** - For clarity or to prevent misunderstanding

## Good Documentation

```javascript
// Returns the user's display name, falling back to email if not set
function getDisplayName(user) { ... }
```

## Bad Documentation

```javascript
// Checks if user.name exists, then returns it, otherwise returns user.email
// This is used by the header component and the profile page
function getDisplayName(user) { ... }
```

## When to Expand

- Public APIs or library interfaces
- Complex business logic with non-obvious consequences
- Security-sensitive code
- Code that has caused confusion before

## When Brief is Better

- Self-explanatory code
- Standard patterns and conventions
- Obvious utility functions

## Anti-Patterns

- Commenting out code (delete it instead)
- Restating the code in comments
- Documentation that contradicts the code
- Over-documenting trivial operations
- Leaving outdated comments after refactoring
