---
name: plan
description: Use after design to create a concrete implementation plan. Breaks the design into bite-sized, executable tasks. Outputs plan.md.
---

# Plan

## Overview

Transform design into action. This skill takes the architecture from `design` and creates a step-by-step implementation plan that anyone can follow.

**Input:** `.workflow/NNN-feature-slug/design.md`
**Output:** `.workflow/NNN-feature-slug/plan.md`

**Announce at start:** "I'm using the plan skill to create the implementation plan."

## When to Use

- After `design` skill completes
- User says "plan", "break it down", "what are the steps"
- Invoked directly via `/plan`
- Before `implement` skill (plan guides implementation)

## Core Rule: One Question at a Time

**If clarification needed, ask ONE question, wait for answer.**

## The Process

### Phase 1: Load Context

**Goal:** Ground the plan in design decisions.

1. Read `.workflow/NNN-feature-slug/design.md`
2. Read `.workflow/NNN-feature-slug/research.md` for context
3. Identify all components that need implementation
4. Determine natural ordering (dependencies)

```
"Based on the design, here's what we need to build:

**Components:** [List them]
**Natural order:** [What depends on what]
**Estimated tasks:** [Rough count]

Any constraints on implementation order I should know about?"
```

[Wait for response before proceeding]

### Phase 2: Task Breakdown

**Goal:** Create bite-sized, executable tasks.

**Each task should be:**
- 2-5 minutes of focused work
- One clear action
- Independently testable where possible
- Complete (includes test + verification)

**Task granularity:**
```
Task: Add user validation
  Step 1: Write failing test for valid input
  Step 2: Run test, confirm it fails
  Step 3: Implement validation function
  Step 4: Run test, confirm it passes
  Step 5: Write failing test for invalid input
  Step 6: Run test, confirm it fails
  Step 7: Add rejection logic
  Step 8: Run test, confirm it passes
  Step 9: Commit
```

**Group related tasks into logical sections.**

### Phase 3: Validation

**Goal:** Confirm the plan makes sense.

Present the plan overview:
```
"Here's the implementation plan:

**Section 1: [Name]** (N tasks)
- [Task summaries]

**Section 2: [Name]** (N tasks)
- [Task summaries]

**Total:** N tasks across M sections

Does this breakdown look right? Any tasks missing or unnecessary?"
```

[Wait for confirmation before writing]

### Phase 4: Plan Document

**Goal:** Capture the plan in plan.md.

**Write `.workflow/NNN-feature-slug/plan.md`:**

```markdown
# Implementation Plan: [Feature Name]

**Date:** YYYY-MM-DD
**Status:** Ready for implementation
**Design:** [Link to design.md]
**Research:** [Link to research.md]

## Overview

**Goal:** [One sentence: what we're building]
**Approach:** [One sentence: how we're building it]
**Tasks:** [Count] tasks across [count] sections

---

## Section 1: [Section Name]

### Task 1.1: [Task Name]

**Files:**
- Create: `path/to/new/file.ext`
- Modify: `path/to/existing/file.ext`
- Test: `path/to/test/file.ext`

**Steps:**

1. **Write failing test**
   ```language
   // Test code here
   ```

2. **Run test, verify failure**
   ```bash
   command to run test
   ```
   Expected: FAIL - [reason]

3. **Implement**
   ```language
   // Implementation code here
   ```

4. **Run test, verify success**
   ```bash
   command to run test
   ```
   Expected: PASS

5. **Commit**
   ```bash
   git add [files]
   git commit -m "feat: [description]"
   ```

---

### Task 1.2: [Task Name]
[Same structure]

---

## Section 2: [Section Name]

### Task 2.1: [Task Name]
[Same structure]

---

## Verification Checklist

After all tasks complete:

- [ ] All tests pass: `[test command]`
- [ ] Linting passes: `[lint command]`
- [ ] Build succeeds: `[build command]`
- [ ] Feature works end-to-end: [how to verify]

## Rollback

If something goes wrong:
- [How to safely undo changes]
- [What to check before reverting]
```

## Handoff

After writing plan.md:

> "I've created the implementation plan and saved it to `.workflow/NNN-feature-slug/plan.md`.
>
> **Summary:** [N] tasks across [M] sections
> **First section:** [Name] - [what it accomplishes]
>
> Ready to start implementing? I'll use the implement skill to execute this plan task by task."

**Transition to:** `implement` skill (if user confirms)

## Key Principles

- **Bite-sized tasks** - 2-5 minutes each, one action
- **Test-driven** - Write test, verify fail, implement, verify pass
- **Complete code** - Never "add validation here", show the actual code
- **Exact paths** - Always full file paths
- **Commit often** - Each task ends with a commit
- **YAGNI** - Only plan what's in the design

## Red Flags

**Never:**
- Create vague tasks ("implement the feature")
- Skip test steps
- Use placeholder code ("add validation logic")
- Combine multiple unrelated changes in one task
- Plan beyond the current design scope

**Always:**
- Reference design.md and research.md
- Include complete, copy-pasteable code
- Specify exact file paths
- Include verification steps
- End tasks with commits
- Write plan.md to `.workflow/NNN-slug/`
