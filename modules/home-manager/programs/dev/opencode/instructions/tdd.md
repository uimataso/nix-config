# Test-Driven Development

You practice **Test-Driven Development (TDD)**: write tests before implementation. Tests are proof — "seems right" is not done.

## The TDD Cycle

```
RED → GREEN → REFACTOR → (repeat)
```

1. **Red** - Write a failing test that defines the desired behavior
2. **Green** - Write the minimal code to make the test pass
3. **Refactor** - Clean up the code while keeping tests green
4. **Repeat** - Move to the next small piece of functionality

## Rules

- **Always write tests first** - No implementation without a test
- **One test at a time** - Each test should verify one behavior
- **Minimal implementation** - Write just enough code to pass
- **Run tests after each change** - Verify before moving on

## The Prove-It Pattern (Bug Fixes)

When a bug is reported, **do not start by fixing it.** Write a test that reproduces it first.

```
Bug report → Write test that fails → Confirm bug exists → Fix → Test passes
```

## Test Best Practices

### Naming
- Test names should describe the behavior being tested
- Use clear, descriptive names: `test_user_cannot_login_with_wrong_password`
- Good test names read like a specification

### Structure (AAA Pattern)
- **Arrange** - Set up the test data and preconditions
- **Act** - Execute the code under test
- **Assert** - Verify the expected outcome

### Test State, Not Interactions
Assert on the *outcome* of an operation, not which methods were called internally. Tests that verify method call sequences break when you refactor.

### DAMP Over DRY
In tests, **DAMP (Descriptive And Meaningful Phrases)** is better than DRY. Each test should tell a complete story without requiring readers to trace through shared helpers.

### Prefer Real Implementations Over Mocks

```
Preference order (most to least preferred):
1. Real implementation → Highest confidence
2. Fake                → In-memory version
3. Stub                → Returns canned data
4. Mock                → Verifies calls (use sparingly)
```

Use mocks only when real implementation is too slow or has uncontrollable side effects.

### Isolation
- Each test must be independent
- No shared mutable state between tests
- Use fixtures, fakes, or stubs for dependencies

### Coverage
- Test edge cases, not just happy paths
- Test error conditions and invalid inputs
- Test boundary conditions

### What to Test
- **Units**: Pure functions, classes, modules (majority of tests)
- **Integration**: Interactions between components
- **E2E**: Critical user flows (limit these)

## When to Apply TDD

- **New features** - Always start with a test
- **Bug fixes** - Write a test that reproduces the bug first
- **Refactoring** - Ensure tests exist before refactoring

## Exceptions

- Exploratory prototyping (but add tests before committing)
- Configuration files, static assets
- Code that's being deleted

## Red Flags

- Writing code without corresponding tests
- Tests that pass on first run (may not test what you think)
- Bug fixes without reproduction tests
- Tests that test framework behavior instead of application behavior
- Skipping tests to make the suite pass
- Running same test twice without code change (adds no confidence)

## Common Rationalizations

| Rationalization | Reality |
|----------------|---------|
| "I'll write tests after the code works" | You won't. And tests written after test implementation, not behavior |
| "This is too simple to test" | Simple code gets complicated. Tests document expected behavior |
| "Tests slow me down" | Tests slow you now. They speed you up every time you change code later |
| "I tested it manually" | Manual testing doesn't persist |
| "It's just a prototype" | Prototypes become production code |

## The Beyoncé Rule

If you liked it, you should have put a test on it. Infrastructure changes, refactoring, and migrations are not responsible for catching your bugs — your tests are.
