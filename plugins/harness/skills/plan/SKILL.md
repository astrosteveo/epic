---
name: plan
description: "Use to break a design into actionable implementation tasks. Produces plan.md with checkboxes for tracking."
---

# Plan

Transforms a design into a detailed, ordered list of atomic implementation tasks that can be executed one at a time.

## Prerequisites

- Design exists (`.harness/NNN-{slug}/design.md`)
- Design has been confirmed by user

## Principles

### Atomic Tasks
Each task should be:
- **Completable in isolation**: Can be implemented and tested independently
- **Verifiable**: Clear success criteria
- **Sized appropriately**: Not too large (hard to verify) or too small (excessive overhead)

### Logical Ordering
Tasks should be ordered so that:
- Dependencies are implemented before dependents
- Tests can be written and run at each step
- Incremental commits make sense

### TDD Orientation
For each task, consider:
- What test(s) will verify this works?
- Can we write the test first?
- What's the minimum code to pass?

## Process

### 1. Read Design
Review the design document to understand:
- Components to be built
- Integration points
- Testing strategy

### 2. Identify Tasks
Break the design into tasks. Common patterns:

**For new features:**
1. Create data structures/types
2. Write core logic (with tests)
3. Add integration points
4. Add error handling
5. Add any UI/CLI components

**For bug fixes:**
1. Write failing test that reproduces bug
2. Fix the bug
3. Verify fix doesn't break other tests

**For refactors:**
1. Ensure test coverage exists
2. Make incremental changes
3. Verify tests pass after each change

### 3. Add Detail to Each Task

For each task, specify:
- What exactly needs to be done
- Which files will be touched
- What test(s) will verify it
- What the commit message should be

### 4. Present Plan

Show the complete task list and ask for confirmation:

"Here's the implementation plan:

1. [Task 1 description]
2. [Task 2 description]
...

Each task will be implemented with tests, verified, and committed before moving to the next. Does this plan work?"

### 5. Load into TodoWrite

After confirmation, load tasks into the TodoWrite tool for tracking during implementation.

## Output

Create `.harness/NNN-{slug}/plan.md`:

```markdown
# Implementation Plan: {Feature Name}

## Overview
{Brief summary of implementation approach}

## Tasks

### Task 1: {Title}
- [ ] {Description}
- **Files**: `path/to/file.ts`
- **Tests**: {What tests will verify this}
- **Commit**: `feat(NNN): {message}`

### Task 2: {Title}
- [ ] {Description}
- **Files**: `path/to/file.ts`, `path/to/other.ts`
- **Tests**: {What tests will verify this}
- **Commit**: `feat(NNN): {message}`

### Task 3: {Title}
- [ ] {Description}
- **Files**: `path/to/file.ts`
- **Tests**: {What tests will verify this}
- **Commit**: `feat(NNN): {message}`

## Notes
{Any implementation notes or gotchas}

## Definition of Done
- [ ] All tasks completed
- [ ] All tests passing
- [ ] Code reviewed against design
- [ ] No unintended side effects
```

## Task Sizing Guidelines

**Too large** (split it):
- "Implement the entire authentication system"
- "Build the dashboard"
- Tasks that touch > 5 files

**Just right**:
- "Create User type and validation functions"
- "Add login endpoint with JWT generation"
- "Write tests for password hashing"

**Too small** (combine it):
- "Add import statement"
- "Rename variable"
- "Add single line of code"

## Marking Progress

As tasks are completed during implementation:
1. Check off the task in `plan.md`: `- [x]`
2. Update `state.json` with current task number
3. Commit includes both code and updated plan

## Git

After plan is confirmed:
```bash
git add .harness/NNN-{slug}/plan.md
git commit -m "docs(NNN): plan implementation for {feature}"
```

## Adjustments

If during implementation, the plan needs to change:
1. Discuss with user
2. Update `plan.md`
3. Commit the plan update
4. Continue implementation

Plans are living documents, not rigid contracts.
