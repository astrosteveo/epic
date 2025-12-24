---
name: code
description: Implementation with TDD. Write tests first, implement to pass, commit atomically. Includes debugging mode for test failures.
---

# Code

## Overview

Execute implementation tasks using TDD. Write tests first, implement to pass them, commit after each task.

## TDD Pattern

### The Cycle

1. **Write test first** - Before any implementation
2. **Run test** - Expect failure (red)
3. **Write minimal code** - Just enough to pass
4. **Run test** - Expect pass (green)
5. **Refactor** - Clean up, keep tests passing
6. **Commit** - One task, one commit

### Test Quality

**Real tests:**
- Assert specific outcomes
- Verify actual behavior
- Cover edge cases
- Would catch bugs if code was wrong

**Not real tests:**
- Only check "doesn't throw"
- Mock the thing being tested
- No meaningful assertions
- Tautological (test what they set up)

### Example

```typescript
// GOOD: Real test
it('should hash password and verify correctly', async () => {
  const password = 'test123';
  const hash = await hashPassword(password);

  expect(hash).not.toBe(password);
  expect(await verifyPassword(password, hash)).toBe(true);
  expect(await verifyPassword('wrong', hash)).toBe(false);
});

// BAD: Fake test
it('should hash password', () => {
  expect(() => hashPassword('test')).not.toThrow();
});
```

---

## Task Execution

### Input

Structured task template from the workflow:

```
Task [N]: [Name]

Files to create/modify:
- [file list]

Requirements:
- [requirement list]

Context from design:
- [relevant design excerpts]

Expected output:
- [what should exist when done]
```

### Process

1. Read task template completely
2. Write tests for requirements
3. Run tests (expect failure)
4. Implement to pass tests
5. Run tests (expect pass)
6. Commit with message: `code: [what was done]`
7. Update `plan.md` with commit hash

### Output

After each task:
```markdown
Task [N]: Complete
- Files: [created/modified list]
- Tests: PASS
- Commit: [hash]
```

---

## Debugging Mode

When tests fail unexpectedly:

### Process

1. **Gather evidence**
   - Full error message
   - Stack trace
   - Relevant logs

2. **Form hypothesis**
   - What could cause this specific failure?
   - Check assumptions

3. **Test hypothesis**
   - Add targeted logging
   - Isolate components
   - Verify inputs/outputs

4. **Fix root cause**
   - Not symptoms
   - Understand why before fixing

5. **Verify fix**
   - Original test passes
   - No regressions

6. **Prevent regression**
   - Add test case for the bug
   - Document if non-obvious

---

## Commit Convention

```
code: [what was done]
```

Examples:
```
code: implement login route and validation
code: add session middleware
code: write auth integration tests
code: fix token expiry calculation
```

---

## What This Skill Does NOT Do

- Explore codebase (Discoverer did that)
- Make design decisions (workflow handles that)
- Review own work (Reviewer does that)
- Skip tests (TDD is mandatory)
- Improvise beyond task spec (follow the plan)
