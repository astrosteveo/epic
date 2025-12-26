---
name: implement
description: "Use for TDD implementation of planned tasks. Follows RED → GREEN → REFACTOR cycle with incremental commits."
---

# Implement

Executes the implementation plan using Test-Driven Development, with verification and commits after each task.

## Prerequisites

- Plan exists (`.harness/NNN-{slug}/plan.md`)
- Plan has been confirmed by user
- Feature branch is checked out

## The TDD Cycle

For each task, follow RED → GREEN → REFACTOR:

### RED: Write Failing Test
1. Read the task description
2. Write a test that defines expected behavior
3. Run the test - it should FAIL
4. If it passes, the test isn't testing new behavior

```bash
# Example: run tests and confirm failure
npm test -- --grep "should authenticate user"
# Expected: FAIL
```

### GREEN: Make It Pass
1. Write the MINIMUM code to make the test pass
2. Don't optimize, don't add extras
3. Focus only on passing the test

```bash
# Run tests and confirm passing
npm test -- --grep "should authenticate user"
# Expected: PASS
```

### REFACTOR: Improve
1. Clean up the code while keeping tests green
2. Remove duplication
3. Improve naming
4. Simplify logic
5. Run tests after each change

```bash
# Ensure tests still pass after refactoring
npm test
# Expected: All PASS
```

## Light Verification

After completing RED → GREEN → REFACTOR, invoke `/review --light`:
- Task implementation matches plan description
- Tests are meaningful (not just passing trivially)
- Code follows CLAUDE.md conventions
- No obvious issues

If issues found → fix before committing.

## Commit

After verification passes:
```bash
git add .
git commit -m "feat(NNN): {task description}"
```

Update `plan.md` to mark task complete:
```markdown
- [x] {Task description}
```

Update `state.json`:
```json
{
  "phase": "implement",
  "currentTask": 2,
  "updated": "2025-01-15T15:00:00Z"
}
```

## When TDD Doesn't Apply

Skip TDD for:
- **Configuration files**: `.env`, `config.json`, etc.
- **Documentation**: README, comments, markdown files
- **Pure styling**: CSS without logic
- **Generated files**: Lock files, build outputs
- **Migrations**: Database migrations (test separately)

For these, verify manually and commit directly.

## Task Execution Flow

```
For each task in plan:
├── Read task description
├── Is TDD applicable?
│   ├── Yes: RED → GREEN → REFACTOR
│   └── No: Implement directly
├── Light verification (/review --light)
├── Fix any issues
├── Commit
├── Update plan.md (check off task)
├── Update state.json
└── Move to next task
```

## Handling Failures

### Test Won't Pass
1. Re-read the task and design
2. Check if understanding is correct
3. If stuck, ask user for clarification
4. Don't skip - resolve before moving on

### Unexpected Side Effects
1. Run full test suite, not just new tests
2. If other tests break, determine if intentional
3. If unintentional, fix before committing

### Plan Needs Adjustment
1. Stop implementation
2. Discuss needed changes with user
3. Update plan.md
4. Commit plan update
5. Continue implementation

## Implementation Prompts

When working on a task, frame it clearly:

"Now implementing Task 3: Create authentication middleware

**From plan**:
- Add middleware that validates JWT tokens
- Return 401 if token is invalid or missing
- Pass decoded user to request context

**Approach**:
1. Write test for valid token → user in context
2. Write test for missing token → 401
3. Write test for invalid token → 401
4. Implement middleware
5. Refactor if needed"

## State Tracking

Maintain accurate state throughout:

```json
{
  "feature": "user-auth",
  "number": 1,
  "phase": "implement",
  "currentTask": 3,
  "totalTasks": 7,
  "created": "2025-01-15T10:00:00Z",
  "updated": "2025-01-15T15:30:00Z",
  "tasksCompleted": [1, 2],
  "currentTaskStarted": "2025-01-15T15:00:00Z"
}
```

## Quality Reminders

- Follow CLAUDE.md conventions at all times
- Write tests that test BEHAVIOR, not implementation
- Prefer small, focused functions
- Handle errors appropriately (per design)
- Don't introduce new patterns without discussion
- Keep commits atomic and well-described
