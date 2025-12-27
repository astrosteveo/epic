---
name: verifying
description: "Use after code changes are complete but before marking task done. Validates implementation - runs tests, checks requirements.md and plan.md, delegates to verifier agent."
---

# Verifying Phase

Rigorous validation before completion. This is the peer review gate.

## When to Use

- After execution is complete
- After any code changes, before marking complete
- When user wants to validate current state

## Subagent Dispatch

**IMPORTANT: Use a subagent to perform the verification work.**

Dispatch the Task tool with `subagent_type="harness:verifier"` to handle validation. This keeps main context low while the subagent runs tests, validates requirements, and performs quality checks.

The subagent should follow the process below.

## The Process

### 1. Run Full Test Suite

**Not just new tests - the entire suite:**
```bash
# Run all tests, not just changed ones
npm test        # or pytest, go test, etc.
```

**Check for:**
- All tests passing
- No new warnings or deprecations
- No flaky test behavior

### 2. Validate Against Requirements

Read `requirements.md` and check each success criterion:

```markdown
## Requirements Validation

| Criterion | Status | Evidence |
|-----------|--------|----------|
| {criterion 1} | ✅/❌ | {how verified} |
| {criterion 2} | ✅/❌ | {how verified} |
```

### 3. Validate Against Plan

Read `plan.md` and verify all steps completed:

```markdown
## Plan Validation

| Step | Status | Commit |
|------|--------|--------|
| {nnn}-1 | ✅/❌ | {hash} |
| {nnn}-2 | ✅/❌ | {hash} |
```

### 4. Test Quality Check

Ensure tests are meaningful:

**Real Harnesses**
- Tests use actual integrations/implementations
- Not just superficial mocks that always pass
- Tests fail when they should fail

**Coverage**
- Key code paths are tested
- Edge cases are covered
- Error handling is tested

### 5. Delegate to Verifier Agent

Use the `verifier` agent for peer review simulation:

> @verifier Review the changes for this task. Check:
> - Code quality and patterns
> - Test coverage and quality
> - Security considerations
> - Documentation accuracy

Incorporate feedback from the verifier.

### 6. User Satisfaction Check

**Not complete until BOTH conditions are met:**
1. ✅ Tests pass
2. ✅ Implementation satisfies user

Ask the user:
> "Tests are passing. Does the implementation meet your expectations? Anything you'd like adjusted?"

### 7. Handle Issues

**Tests pass but user spots issues:**
- Loop back to Execute to address concerns
- Or loop back to Plan if changes are significant

**Tests fail:**
- Loop back to Execute to fix
- Update plan.md if approach needs revision

**Verifier finds issues:**
- Address code quality feedback
- Fix security concerns
- Update tests if coverage gaps found

### 8. Completion

When both conditions are met:

> "All validations pass and you're satisfied with the implementation. This task is complete!
>
> Summary:
> - {X} tests passing
> - All {N} requirements met
> - All {M} plan steps complete
>
> Ready to commit and wrap up?"

## Validation Checklist

```markdown
## Final Verification

### Tests
- [ ] Full test suite passes
- [ ] No new warnings
- [ ] Tests are meaningful (not superficial)

### Requirements
- [ ] All success criteria met
- [ ] Constraints respected
- [ ] Scope maintained

### Plan
- [ ] All steps completed
- [ ] Commits are atomic and logical
- [ ] No steps skipped

### Quality
- [ ] Code follows project patterns
- [ ] No security issues
- [ ] No performance regressions

### User
- [ ] User reviewed implementation
- [ ] User is satisfied
```

## Key Principles

- **Both conditions** - Tests AND user satisfaction required
- **Full suite** - Don't skip tests outside your changes
- **Real verification** - Tests must fail when they should
- **Peer review mindset** - Review like a colleague before merge
- **User is final arbiter** - Technical success isn't enough

## Returning to Verify

You may return to this phase when:
- Fixes were made after initial verification
- User wants to re-check after changes
- New tests were added

Re-run the full verification process.
