---
name: plan
description: "Takes a design doc and produces a detailed implementation plan with complete code, exact paths, and TDD structure."
---

# Plan

## Overview

Transform a validated design document into a detailed, actionable implementation plan. Each task is focused (~10 min), includes complete code, and follows TDD structure.

## When to Use

Use this skill when:
- You have a validated design doc from `/discovery`
- User says "let's plan this" or "create implementation plan"
- Ready to move from design to implementation

## Prerequisites

Must have a design document with:
- Clear goal
- Defined vertical slice
- Success criteria
- Architecture decisions

If no design doc exists, guide user to `/discovery` first.

## The Process

### Step 1: Review Design

Read the design document. Confirm understanding:
- "I see we're building [vertical slice] to prove [concept]. The success criteria are [X, Y, Z]. Is this still accurate?"

### Step 2: Identify Tasks

Break the vertical slice into focused tasks:
- Each task ~10 minutes of work
- Each task produces something testable/verifiable
- Each task ends with a commit

Ask yourself:
- What's the logical order?
- Which tasks can run in parallel (no dependencies)?
- Which tasks need manual verification (UI, feel, integration)?

### Step 3: Write Complete Tasks

For each task, provide:
1. **Files** - Exact paths to create/modify/test
2. **Dependencies** - Which tasks must complete first (or "None")
3. **Verification** - "Automated" or "Manual" (with instructions)
4. **Complete code** - Not "add validation" but actual code
5. **Exact commands** - What to run and expected output

### Step 4: Identify Manual Verification Points

Mark tasks that need human verification:
- UI/UX changes
- Game feel or animations
- Performance perception
- Integration with external systems
- Anything subjective

Include specific verification instructions.

### Step 5: Offer Implementation Mode

After presenting plan:
```
The plan has N tasks. How would you like to proceed?

A) Focused sessions (default)
   - One task at a time
   - Verify between tasks
   - ~10 min per task
   - Best for: learning, reviewing, complex work

B) Autonomous mode
   - Run through all tasks
   - Parallel where possible
   - Verify at the end
   - Best for: routine work, time constraints

C) Hybrid
   - Autonomous for straightforward tasks
   - Pause for complex/risky ones
```

## Output

Save plan to: `docs/plans/YYYY-MM-DD-<topic>-plan.md`

Format:
```markdown
# [Feature] Implementation Plan

**Goal:** One sentence
**Architecture:** 2-3 sentences
**Vertical Slice:** What this proves
**Design Doc:** `docs/plans/YYYY-MM-DD-<topic>-design.md`

---

### Task 1: [Name]

**Files:**
- Create: `exact/path/to/file.ts`
- Modify: `exact/path/to/existing.ts`
- Test: `tests/exact/path/to/file.test.ts`

**Dependencies:** None
**Verification:** Automated

**Step 1: Write failing test**
```typescript
// tests/exact/path/to/file.test.ts
describe('FeatureName', () => {
  it('should do specific thing', () => {
    const result = functionName(input);
    expect(result).toBe(expected);
  });
});
```

**Step 2: Run test, verify it fails**
```bash
npm test -- tests/exact/path/to/file.test.ts
```
Expected: FAIL - "functionName is not defined"

**Step 3: Implement**
```typescript
// exact/path/to/file.ts
export function functionName(input: InputType): OutputType {
  // Complete implementation
  return result;
}
```

**Step 4: Run test, verify it passes**
```bash
npm test -- tests/exact/path/to/file.test.ts
```
Expected: PASS

**Step 5: Commit**
```bash
git add tests/exact/path/to/file.test.ts exact/path/to/file.ts
git commit -m "feat: add specific feature"
```

---

### Task 2: [Name]

**Files:**
- Modify: `path/to/file.ts`

**Dependencies:** Task 1
**Verification:** Manual

**Manual Verification Instructions:**
1. Run: `npm run dev`
2. Do: [specific action]
3. Verify: [expected behavior]
4. Check: [what could go wrong]

[Steps continue...]

---

### Task N: [Final task]

[...]

---

## Execution

Ready to implement? Use `/implement` to execute this plan.
```

## Key Principles

- **Complete code** - Implementer executes, doesn't design
- **Exact paths** - No ambiguity about where files go
- **TDD structure** - Test → fail → implement → pass → commit
- **~10 min tasks** - Focused, no marathon sessions
- **Mark dependencies** - Enable parallel execution where possible
- **Flag manual verification** - Stop when human testing needed
- **No gold plating** - Only what's in the design

## Task Sizing

**Too big:**
- "Implement the authentication system"
- "Build the API layer"

**Just right:**
- "Create User model with email and passwordHash fields"
- "Add login endpoint that issues JWT token"
- "Add middleware that validates token on protected routes"

If a task feels like it would take more than ~10 minutes, break it down further.

## Red Flags

**Never:**
- Skip the design doc and jump to planning
- Write vague tasks like "add validation"
- Omit file paths or expect implementer to figure it out
- Forget to mark manual verification points
- Create tasks with hidden dependencies
- Over-scope beyond the vertical slice
