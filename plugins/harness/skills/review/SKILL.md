---
name: review
description: "Use to verify implementation against design/plan. Light mode after each task, thorough mode before shipping."
---

# Review

Verification skill that ensures implementation matches design and meets quality standards. Trust but verify.

## Modes

### Light Review (`/review --light`)
Quick verification after each task:
- Task implementation matches plan description
- Tests are present and meaningful
- Code follows CLAUDE.md conventions
- No obvious issues or regressions

### Thorough Review (`/review` or `/review --thorough`)
Comprehensive review before shipping:
- Full design compliance
- All tasks completed
- All tests passing
- Integration verification
- No unintended side effects
- Code quality assessment

## Light Review Checklist

Run after each task during implementation:

```markdown
## Light Review: Task {N}

### Plan Alignment
- [ ] Implementation matches task description
- [ ] Scope matches what was planned (no more, no less)

### Tests
- [ ] Tests exist for new functionality
- [ ] Tests are meaningful (not trivially passing)
- [ ] Tests are passing

### Conventions
- [ ] Follows CLAUDE.md style guidelines
- [ ] Follows existing patterns in codebase
- [ ] No linting errors

### Quick Sanity
- [ ] No obvious bugs
- [ ] No security concerns
- [ ] No hardcoded values that should be configurable
```

**Pass criteria**: All boxes checked → proceed to commit
**Fail criteria**: Any box unchecked → fix before committing

## Thorough Review Checklist

Run before final commit and PR:

```markdown
## Thorough Review: {Feature Name}

### Design Compliance
- [ ] Architecture matches design.md
- [ ] All components from design are implemented
- [ ] Data structures match design
- [ ] Integration points connected correctly
- [ ] Error handling implemented per design

### Plan Completion
- [ ] All tasks in plan.md are checked off
- [ ] No tasks were skipped
- [ ] No out-of-scope additions

### Test Coverage
- [ ] All tests passing
- [ ] Tests cover happy path
- [ ] Tests cover error cases
- [ ] Tests cover edge cases from spec
- [ ] No tests were disabled or skipped

### Code Quality
- [ ] Follows CLAUDE.md conventions
- [ ] No code duplication
- [ ] Functions/methods appropriately sized
- [ ] Clear naming throughout
- [ ] Comments where logic isn't self-evident

### Integration
- [ ] Works with existing code
- [ ] No breaking changes to existing functionality
- [ ] All dependencies properly handled

### Security
- [ ] No secrets in code
- [ ] Input validation where needed
- [ ] No SQL injection vulnerabilities
- [ ] No XSS vulnerabilities
- [ ] Auth/authz properly implemented (if applicable)

### Performance
- [ ] No obvious performance issues
- [ ] No N+1 queries
- [ ] No unnecessary loops or operations

### Success Criteria
- [ ] All criteria from spec.md are met
```

## Running Verification

### Tests
```bash
# Run full test suite
npm test        # or pytest, go test, etc.

# Run with coverage if available
npm test -- --coverage
```

### Linting
```bash
# Run linter
npm run lint    # or appropriate linter command
```

### Type Checking
```bash
# Run type checker
npm run typecheck   # or tsc, mypy, etc.
```

### Build
```bash
# Verify build succeeds
npm run build
```

## Issue Reporting

When issues are found, document in `.harness/NNN-{slug}/issues.md`:

```markdown
# Issues Found During Review

## Issue 1: {Title}
- **Severity**: Critical | High | Medium | Low
- **Location**: `path/to/file.ts:42`
- **Description**: {What's wrong}
- **Resolution**: {How to fix}
- **Status**: Open | Fixed

## Issue 2: {Title}
...
```

## Blocking vs Non-Blocking

### Blocking Issues (must fix before proceeding)
- Tests failing
- Security vulnerabilities
- Doesn't match design
- Missing required functionality
- Breaking changes

### Non-Blocking Issues (can note and proceed)
- Minor style inconsistencies
- Opportunities for optimization
- Nice-to-have improvements
- Documentation gaps

## Review Output

After review, report status clearly:

**Light Review Pass:**
"Light review passed for Task 3. Tests passing, conventions followed, implementation matches plan. Ready to commit."

**Light Review Fail:**
"Light review found issues:
- Test for edge case missing
- Variable naming doesn't follow convention

Please address before committing."

**Thorough Review Pass:**
"Thorough review complete. All checks passed:
- Design compliance: ✓
- Plan completion: ✓
- Tests: ✓ (15 passing)
- Code quality: ✓
- Security: ✓

Ready for commit and PR."

**Thorough Review Fail:**
"Thorough review found issues:

Critical:
- Missing error handling for network failures (design.md section 4)

High:
- Task 5 not checked off but appears complete

Please address critical issues before proceeding."

## Verification Philosophy

- **Don't take anyone's word for anything** - verify claims against artifacts
- **Compare against source of truth** - design.md and plan.md are the contracts
- **Be specific** - cite file:line when reporting issues
- **Be objective** - follow the checklist, not feelings
- **Be thorough but pragmatic** - focus on what matters
