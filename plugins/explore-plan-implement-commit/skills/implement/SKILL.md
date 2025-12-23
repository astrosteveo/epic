---
name: implement
description: Use after plan to execute the implementation. Works through the plan task by task with review checkpoints. This is where code gets written.
---

# Implement

## Overview

Execute the plan. This skill takes the implementation plan from `plan` and works through it task by task, with checkpoints for review and course correction.

**Input:** `.workflow/NNN-feature-slug/plan.md`
**Output:** Working code, committed incrementally

**Announce at start:** "I'm using the implement skill to execute the implementation plan."

## When to Use

- After `plan` skill completes
- User says "implement", "build it", "let's code", "execute the plan"
- Invoked directly via `/implement`
- Before `commit` skill (for final commit if not done incrementally)

## The Process

### Phase 1: Load and Review Plan

**Goal:** Understand what we're building and raise any concerns.

1. Read `.workflow/NNN-feature-slug/plan.md`
2. Review critically - identify any issues
3. If concerns exist, raise them before starting

```
"I've reviewed the implementation plan:

**Tasks:** [Count] across [sections]
**Starting with:** [First section name]

[If concerns:]
Before we start, I noticed [concern]. Should we [suggestion]?

[If no concerns:]
The plan looks solid. Ready to start with Task 1.1: [name]?"
```

[Wait for go-ahead before coding]

### Phase 2: Execute Tasks

**Goal:** Work through tasks one by one.

**For each task:**

1. **Announce the task**
   ```
   "Starting Task [N.M]: [Name]"
   ```

2. **Follow steps exactly**
   - Write the test (if TDD)
   - Run it, verify failure
   - Implement the code
   - Run test, verify success
   - Commit

3. **Report completion**
   ```
   "Task [N.M] complete:
   - [What was done]
   - Tests: [PASS/FAIL]
   - Committed: [commit message]"
   ```

4. **Move to next task**

**Batch size:** Complete 2-3 tasks, then pause for checkpoint.

### Phase 3: Checkpoints

**Goal:** Regular opportunities for review and course correction.

After every 2-3 tasks:

```
"Checkpoint - Section [N] progress:

**Completed:**
- Task [N.1]: [summary]
- Task [N.2]: [summary]
- Task [N.3]: [summary]

**Tests:** All passing
**Next up:** Task [N.4]: [name]

How's it looking? Ready to continue, or want to review anything?"
```

[Wait for feedback before continuing]

**Handle feedback:**
- Adjust approach if needed
- Fix issues before proceeding
- Don't barrel through problems

### Phase 4: Section Completion

**Goal:** Mark progress and validate before next section.

At end of each section:

```
"Section [N]: [Name] - Complete

**Tasks completed:** [count]
**Files created/modified:** [list key files]
**Test status:** [all passing / X failing]

Ready to move to Section [N+1]: [Name]?"
```

### Phase 5: Implementation Complete

**Goal:** Verify everything works together.

After all sections:

```
"Implementation complete!

**Summary:**
- [N] tasks completed across [M] sections
- [X] files created
- [Y] files modified
- All tests passing

**Running final verification:**
- [ ] Full test suite: [command]
- [ ] Lint check: [command]
- [ ] Build: [command]

[Run verifications and report results]

Ready to finalize with a commit summary? I'll use the commit skill to wrap up."
```

**Transition to:** `commit` skill (if user confirms)

## When to Stop and Ask

**STOP immediately when:**
- Test fails unexpectedly
- Plan step is unclear
- Missing dependency discovered
- Approach isn't working
- You're uncertain about something

```
"I've hit a blocker:

**Task:** [Current task]
**Issue:** [What went wrong]
**Options:**
A) [Option 1]
B) [Option 2]

Which way should we go?"
```

**Ask ONE question. Wait for answer.**

## Key Principles

- **Follow the plan** - Don't improvise unless blocked
- **Test-driven** - Write test, fail, implement, pass
- **Commit often** - Each task gets a commit
- **Checkpoint regularly** - Every 2-3 tasks
- **Stop when blocked** - Don't guess, ask
- **One question at a time** - Never batch questions

## Red Flags

**Never:**
- Skip tests
- Combine multiple tasks into one commit
- Ignore failing tests
- Deviate from plan without discussing
- Ask multiple questions at once
- Push through blockers without asking

**Always:**
- Announce each task before starting
- Run verifications as specified
- Commit after each task
- Checkpoint every 2-3 tasks
- Stop and ask when uncertain
- Report progress clearly
