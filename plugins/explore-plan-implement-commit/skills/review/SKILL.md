---
name: review
description: Quality gates. Validates code quality, test authenticity, and plan adherence. Runs after every task.
---

# Review

## Overview

Three types of validation that run after every task. Quality gates are non-negotiable.

## Review Types

### 1. Code Review

**Check for:**

- [ ] **Design alignment** - Matches `design.md` architecture
- [ ] **Pattern consistency** - Follows patterns from `codebase.md`
- [ ] **Best practices** - Applies guidance from `research.md`
- [ ] **Security** - No hardcoded secrets, proper validation, auth checks
- [ ] **Clean code** - Clear naming, no duplication, appropriate length

**Questions to ask:**
- Does this match the design?
- Would someone new understand this in 30 seconds?
- What could an attacker do with this code?

### 2. Test Review

**Validate tests are real:**

- [ ] **Real assertions** - Not just "doesn't throw"
- [ ] **Behavior verification** - Tests what code actually does
- [ ] **No over-mocking** - Core logic uses real implementations
- [ ] **Edge cases covered** - Not just happy path
- [ ] **Would catch bugs** - If code was wrong, test would fail

**Red flags:**
- Tests with no assertions
- Mocking the thing being tested
- Only testing that code runs without error
- Tautological tests (test what they set up)

### 3. Plan Validation

**Confirm implementation matches plan:**

- [ ] **Task completed as specified** - All deliverables present
- [ ] **No scope creep** - Nothing extra added
- [ ] **No scope reduction** - Nothing missing
- [ ] **Files match** - Created/modified as specified

---

## Process

After each task completes:

1. Run all three review types
2. Document any issues found
3. Return verdict

---

## Output Format

### All Pass

```
## Review: Task [N]

✓ Code Review: PASS
✓ Test Review: PASS
✓ Plan Validation: PASS

Ready for next task.
```

### Issues Found

```
## Review: Task [N]

✓ Code Review: PASS
✗ Test Review: ISSUES FOUND
✓ Plan Validation: PASS

### Test Review Issues

**Issue 1: FAKE_TEST**
Location: `tests/auth.test.ts:15-20`
Problem: Test only checks that function doesn't throw
Required fix: Add assertions verifying actual behavior

**Issue 2: MISSING_COVERAGE**
Location: `tests/auth.test.ts`
Problem: No test for invalid password case
Required fix: Add test for password validation failure

---

Return to Coder for fixes.
```

---

## Issue Categories

| Category | Description |
|----------|-------------|
| SECURITY | Hardcoded secrets, missing auth, injection vulnerabilities |
| DESIGN | Deviates from design.md, wrong architecture |
| PATTERN | Inconsistent with codebase patterns |
| FAKE_TEST | Test doesn't actually test anything |
| MISSING_COVERAGE | Requirement or edge case not tested |
| SCOPE_CREEP | Added work not in plan |
| SCOPE_REDUCTION | Planned work missing |

---

## What This Skill Does NOT Do

- Write code (Coder does that)
- Make design decisions (workflow handles that)
- Explore codebase (Discoverer did that)
- Skip reviews to save time (quality > speed)
