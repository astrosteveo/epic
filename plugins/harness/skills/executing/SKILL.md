---
name: executing
description: |
  Use this skill to implement changes following the approved plan with TDD by default.
  Updates: plan.md with progress
---

# Executing Phase

Implement the changes following the approved plan. TDD by default.

## When to Use

- After plan is approved
- For simple, well-defined tasks that skip planning
- Returning to continue implementation after interruption

## The Process

### 1. Read the Plan

Start by reading:
- `plan.md` - The steps to follow
- `design.md` - Architecture context
- `requirements.md` - Success criteria to keep in mind

Check for any "Completed through step X" markers if resuming.

### 2. Follow TDD by Default

For each step:

**Write the Test First**
1. Write a failing test that defines the expected behavior
2. Run the test - watch it fail
3. Confirm it fails for the right reason

**Implement Minimal Code**
4. Write just enough code to make the test pass
5. Run the test - watch it pass
6. Refactor if needed while keeping tests green

**Commit Atomically**
7. Commit with the message from plan.md
8. Update plan.md to mark step complete

### 3. When TDD Isn't Possible

Document exceptions and add tests after:

**Valid Exceptions**
- Legacy code without test infrastructure
- Exploratory/spike work
- UI changes that need visual verification
- Third-party integration with no test doubles

**When Skipping TDD**
- Document why in the commit or plan.md
- Add tests after implementation when possible
- Note any untested areas for verification phase

### 4. Track Progress

Update `plan.md` as you complete steps:
```markdown
## Step {nnn}-1: {Description}
**Status:** ✅ Complete (commit: abc1234)
```

If you need to pause:
```markdown
## Progress Note
Completed through step {nnn}-3. Next: step {nnn}-4.
```

### 5. Handle Issues

**Plan Issue (step doesn't work as written)**
- Stop execution
- Return to Plan phase
- Update `plan.md` with what failed and revised approach
- Resume execution after plan update

**New Discovery (unexpected technical issue)**
- Stop and assess scope
- May need to loop back to Research or even Define
- Document what changed in relevant artifacts
- Don't compound problems by pushing forward

**Regressions Introduced**
- Stop immediately
- Use `git diff` and `git log` to understand what changed
- Revert problematic commits if needed
- Update plan with what failed

### 6. Incremental Commits

**Commit Discipline**
- Each step = 1-3 logical commits
- Commits should be revertible units
- Use conventional commit messages from plan.md
- Don't bundle unrelated changes

**Commit Message Format**
```
{type}({scope}): {description}

{optional body with context}
```

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`

### 7. Offer Transition

When all steps are complete:

> "All plan steps are complete. Ready to move to Verify where we'll run the full test suite and validate against requirements?"

## Key Principles

- **TDD first** - Tests define behavior before implementation
- **Follow the plan** - Don't improvise beyond what's approved
- **Fail fast** - Stop at issues, don't compound them
- **Commit atomically** - Each commit is a logical, revertible unit
- **Track progress** - Keep plan.md updated for resumability
- **Stay focused** - Execute the plan, don't expand scope

## Returning to Execute

You may return to this phase when:
- Verify phase finds issues that need fixing
- Plan was updated after discovering issues
- Resuming after interruption

Check plan.md for progress markers before continuing.
