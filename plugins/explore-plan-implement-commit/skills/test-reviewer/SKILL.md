---
name: test-reviewer
description: Reviews tests for authenticity and coverage. Validates tests are real validations, not stubs or mocks. Ensures TDD principles are followed. Used by the Orchestrator after the Coder completes tasks.
---

# Test Reviewer

## Overview

Review tests to ensure they are authentic validations, not superficial stubs or mocks. This skill validates that TDD principles are followed and tests provide real confidence in the implementation.

**Purpose:** Ensure tests actually test something meaningful and provide real validation.

**Input:**
- Test files from the Coder
- Implementation files (to verify tests cover the code)
- Requirements from the task template

**Output:**
- Review verdict: APPROVED or CHANGES_REQUESTED
- Specific feedback on test quality issues

**Announce at start:** "I'm using the test-reviewer skill to validate test authenticity and coverage."

## When to Use

- After the Coder completes a task (before code review)
- When validating TDD compliance
- When test quality is in question

## Core Principle: Real Tests vs Fake Tests

**The fundamental question:** Does this test give us confidence the code works?

### Real Tests (GOOD)

Real tests:
- Assert specific, meaningful outcomes
- Test actual behavior, not just that code runs
- Cover success cases AND failure cases
- Use realistic inputs
- Verify state changes or outputs

```typescript
// REAL: Tests actual behavior
it('should hash password and verify correctly', async () => {
  const password = 'securePassword123';
  const hash = await hashPassword(password);

  // Multiple meaningful assertions
  expect(hash).not.toBe(password);           // Hash is different
  expect(hash.length).toBeGreaterThan(50);   // Hash has expected length
  expect(await verifyPassword(password, hash)).toBe(true);   // Verification works
  expect(await verifyPassword('wrong', hash)).toBe(false);   // Wrong password fails
});
```

### Fake Tests (BAD)

Fake tests:
- Only check that code doesn't throw
- Use mocks for everything including the thing being tested
- Have no meaningful assertions
- Skip edge cases and error paths
- Are tautological (test what they set up)

```typescript
// FAKE: Only checks it doesn't throw
it('should hash password', () => {
  expect(() => hashPassword('test')).not.toThrow();
});

// FAKE: Mocks the thing being tested
it('should hash password', () => {
  const mockHash = jest.fn().mockReturnValue('hashed');
  expect(mockHash('password')).toBe('hashed'); // Tests the mock, not the code
});

// FAKE: Tautological
it('should return user', () => {
  const user = { id: 1, name: 'Test' };
  const result = user;  // No actual code called
  expect(result).toBe(user);
});
```

## Review Criteria

### 1. Test Authenticity

Verify tests are real validations:

- [ ] Tests assert specific outcomes, not just "doesn't throw"
- [ ] Tests verify actual behavior, not mock behavior
- [ ] Tests use realistic inputs
- [ ] Assertions are meaningful (not tautological)
- [ ] Tests would fail if the code was broken

**Key question:** If the implementation was completely wrong, would this test catch it?

### 2. Coverage Completeness

Verify tests cover what matters:

- [ ] Happy path is tested
- [ ] Error cases are tested
- [ ] Edge cases are tested
- [ ] Boundary conditions are tested
- [ ] All requirements from task template are covered

**Key question:** What scenarios are NOT tested that should be?

### 3. Test Structure

Verify tests are well-organized:

- [ ] Clear describe/it structure
- [ ] Test names describe the expected behavior
- [ ] Arrange-Act-Assert pattern followed
- [ ] Tests are independent (no shared mutable state)
- [ ] Setup/teardown is appropriate

### 4. Mock Usage

Verify mocks are used appropriately:

**Acceptable mocking:**
- External services (APIs, databases in unit tests)
- Time/date functions
- Random number generators
- File system (in unit tests)

**Unacceptable mocking:**
- The code being tested
- Core logic that should be validated
- Everything (over-mocking)

- [ ] Mocks are only for external dependencies
- [ ] Core logic is tested with real implementations
- [ ] Mocks verify interactions, not just return values
- [ ] Integration tests use real implementations

### 5. TDD Compliance

Verify TDD principles were followed:

- [ ] Tests exist for all implemented functionality
- [ ] Tests are not retrofitted (test what code does vs. test requirements)
- [ ] Tests drive the implementation, not describe it

**Signs of tests-after (bad):**
- Tests mirror implementation structure exactly
- Tests only cover happy path
- Tests are fragile (break with refactoring)

**Signs of TDD (good):**
- Tests describe behavior from user/caller perspective
- Tests cover requirements, including edge cases
- Tests are resilient to refactoring

## Review Process

### Phase 1: Test Inventory

List all tests and what they claim to test:
1. Count test files
2. Count test cases (it/test blocks)
3. Map tests to requirements from task template

### Phase 2: Authenticity Check

For each test:
1. Read the test name - what does it claim to verify?
2. Read the assertions - do they actually verify that?
3. Check for fake patterns (no-throw, tautological, over-mocked)

### Phase 3: Coverage Analysis

Compare tests to requirements:
1. List all requirements from task template
2. Mark which tests cover which requirements
3. Identify gaps

### Phase 4: Edge Case Review

Check for edge case coverage:
1. Empty/null inputs
2. Invalid inputs
3. Boundary values
4. Error conditions
5. Concurrent scenarios (if applicable)

### Phase 5: Verdict

Deliver the review result.

## Output Format

### APPROVED

```markdown
## Test Review: APPROVED

**Task:** [Task name]
**Test files reviewed:** [List]
**Test count:** [N] tests

### Coverage Summary
| Requirement | Test(s) |
|-------------|---------|
| [Requirement 1] | `should do X`, `should handle Y error` |
| [Requirement 2] | `should validate Z` |

### Highlights
- [Good testing pattern worth noting]
- [Thorough edge case coverage in specific area]

### Minor Suggestions (optional, non-blocking)
- [Could add test for edge case X, but not blocking]

**Verdict:** Tests provide real validation. Ready for code review.
```

### CHANGES_REQUESTED

```markdown
## Test Review: CHANGES_REQUESTED

**Task:** [Task name]
**Test files reviewed:** [List]
**Test count:** [N] tests

### Issues (must fix)

#### Issue 1: [Category] - [Brief description]

**Location:** `path/to/test.ts:15-25`

**Problem:**
[Description of why this test is insufficient]

**Current test:**
```typescript
[The problematic test]
```

**Required change:**
[What the test should do instead]

**Example fix:**
```typescript
[Corrected test]
```

#### Issue 2: [Category] - [Brief description]
[Same structure]

### Missing Coverage
- [ ] [Requirement or scenario not tested]
- [ ] [Another gap]

### Summary
[N] test issues must be addressed. [M] coverage gaps must be filled.

**Verdict:** Return to Coder for test improvements.
```

## Issue Categories

| Category | Examples |
|----------|----------|
| **FAKE_TEST** | Only checks no-throw, tests mock not code, tautological |
| **MISSING_COVERAGE** | Requirement not tested, edge case not covered |
| **OVER_MOCKED** | Mocks core logic that should be tested |
| **POOR_ASSERTIONS** | Weak assertions that don't verify behavior |
| **STRUCTURE** | Unclear names, missing describe blocks, shared state |

## Common Fake Test Patterns

### 1. The No-Throw Test

```typescript
// BAD
it('should process data', () => {
  expect(() => processData(input)).not.toThrow();
});
```

**Problem:** Only verifies code runs, not what it does.

**Fix:** Assert on the output.

### 2. The Mock Everything Test

```typescript
// BAD
it('should save user', async () => {
  const mockSave = jest.fn().mockResolvedValue({ id: 1 });
  const result = await mockSave(user);
  expect(mockSave).toHaveBeenCalledWith(user);
});
```

**Problem:** Tests the mock, not the actual save logic.

**Fix:** Test with real implementation or integration test.

### 3. The Tautological Test

```typescript
// BAD
it('should return the input', () => {
  const input = { foo: 'bar' };
  const output = input;  // No function called!
  expect(output).toBe(input);
});
```

**Problem:** Proves nothing about the code.

**Fix:** Actually call the code being tested.

### 4. The Implementation Mirror

```typescript
// BAD - mirrors implementation instead of testing behavior
it('should call helper then format then save', () => {
  // This test will break if we refactor, even if behavior is correct
});
```

**Problem:** Tests how, not what. Fragile to refactoring.

**Fix:** Test outcomes and behavior, not internal steps.

### 5. The Assertion-Free Test

```typescript
// BAD
it('should update user', async () => {
  await updateUser(1, { name: 'New' });
  // No assertions!
});
```

**Problem:** No verification at all.

**Fix:** Assert on the result or side effects.

## Key Principles

- **Skepticism first** - Assume tests are fake until proven real
- **Behavior over implementation** - Tests should verify what, not how
- **Coverage matters** - Every requirement needs a test
- **Edge cases catch bugs** - Happy path tests aren't enough
- **Mocks are a last resort** - Prefer real implementations

## Red Flags - Automatic CHANGES_REQUESTED

These always require changes:

- Tests with no assertions
- Tests that only check "doesn't throw"
- Tests that mock the code being tested
- Requirements from task template with no tests
- Error paths with no coverage
- Over-reliance on snapshot tests for logic
