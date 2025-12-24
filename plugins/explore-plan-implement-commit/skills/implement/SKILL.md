---
name: implement
description: Use after plan to execute the implementation. The Coder subagent works through tasks while the Orchestrator performs reviews after each. Supports autonomous and batched execution modes.
---

# Implement

## Overview

Execute the plan. This skill operates as the **Coder** subagent, working through the implementation plan task by task. After each task, the **Orchestrator** performs reviews (test, code, plan validation) before proceeding.

**Input:** `.workflow/NNN-feature-slug/plan.md`
**Output:** Working code, committed incrementally

**Announce at start:** "I'm using the implement skill. I'll act as the Coder, executing tasks from the plan, with Orchestrator reviews after each."

## The 3-Subagent Model

| Subagent | Role in Implementation |
|----------|------------------------|
| **Orchestrator** | Reviews tests, code, and plan adherence after each task |
| **Coder** | Executes tasks from plan.md following TDD |
| **Discoverer** | Already completed (artifacts available) |

## When to Use

- After `plan` skill completes
- User says "implement", "build it", "let's code", "execute the plan"
- Invoked directly via `/implement`
- Before `commit` skill (for final commit if not done incrementally)

## Global Rule: Asking Questions

**ONE question at a time. Always.**

Use the AskUserQuestion tool pattern for all questions:

1. **Use multiple choice when possible** (2-4 options)
2. **Lead with your recommendation** - mark it clearly with "(Recommended)"
3. **Always include "Other"** - user can provide free text
4. **Single-select for mutually exclusive choices**

**Format:**

```
[Brief context for the question]

**A) [Option Name]** (Recommended)
   [1-2 sentence description of what this means]

**B) [Option Name]**
   [1-2 sentence description]

**C) [Option Name]**
   [1-2 sentence description]

**D) Other**
   [Tell me what you're thinking]
```

**Wait for response before asking next question.**

## The Process

### Phase 1: Load and Review Plan

**Goal:** Understand what we're building and select execution mode.

1. Read `.workflow/NNN-feature-slug/plan.md`
2. Review critically - identify any issues
3. Present execution mode options

```
I've reviewed the implementation plan:

**Tasks:** [Count] across [sections]
**Starting with:** [First section name]

[If concerns:]
Before we start, I noticed [concern]. How should we handle this?

**A) [Suggested fix]** (Recommended)
   [Why this is the best approach]

**B) Ignore and proceed**
   Continue with the plan as-is

**C) Adjust the plan**
   Let's modify before starting

**D) Other**
   Different approach in mind

[If no concerns:]
The plan looks solid. How would you like to proceed?

**A) Autonomous mode** (Recommended)
   I'll execute all tasks with Orchestrator reviews after each. Minimal interruption.

**B) Batched mode**
   I'll do 2-3 tasks, then pause for your review before continuing.

**C) Review the plan again**
   Let's look at the plan before starting.

**D) Other**
   Different approach in mind
```

[Wait for mode selection before coding]

### Phase 2: Execute Tasks (Coder Role)

**Goal:** Work through tasks following the plan exactly.

**For each task:**

1. **Announce the task**
   ```
   "**Coder:** Starting Task [N.M]: [Name]"
   ```

2. **Execute steps exactly as written in plan.md**
   - Write the test (copy from plan)
   - Run it, verify failure
   - Implement the code (copy from plan)
   - Run test, verify success
   - Commit

3. **Report completion**
   ```
   "**Coder:** Task [N.M] complete:
   - Created: [files]
   - Modified: [files]
   - Tests: PASS
   - Committed: [commit hash]"
   ```

4. **Trigger Orchestrator review**

### Phase 3: Orchestrator Reviews

**Goal:** Verify quality after each task.

**After each task, perform three reviews:**

#### Test Review
```
"**Orchestrator - Test Review:**

Checking Task [N.M] tests...

- [ ] Tests have real assertions (not just `expect(true).toBe(true)`)
- [ ] Tests verify actual behavior, not implementation details
- [ ] Edge cases are covered as specified in plan
- [ ] No mocked logic that should be real

**Result:** [PASS / ISSUES FOUND]

[If issues:]
Issues found:
- [Issue 1]: [How to fix]

Coder: Please fix before proceeding.
```

#### Code Review
```
"**Orchestrator - Code Review:**

Checking Task [N.M] code...

- [ ] Follows pattern from codebase.md (`file:line`)
- [ ] Applies best practice from research.md
- [ ] Matches design.md specification
- [ ] No obvious bugs or security issues
- [ ] Code is clean and readable

**Result:** [PASS / ISSUES FOUND]

[If issues:]
Issues found:
- [Issue 1]: [How to fix]

Coder: Please fix before proceeding.
```

#### Plan Validation
```
"**Orchestrator - Plan Validation:**

Checking Task [N.M] against plan...

- [ ] Task completed as specified
- [ ] No scope creep (nothing extra added)
- [ ] No scope reduction (nothing missing)
- [ ] Files match plan specification

**Result:** [PASS / DEVIATION FOUND]

[If deviation:]
Deviation: [Description]
- Expected: [What plan said]
- Actual: [What was done]

[Ask user]: Should we fix this, accept the deviation, or defer?
```

### Phase 4: Issue Tracking

**Goal:** Log any issues discovered.

If issues are found during reviews, log them:

**Create/Update `.workflow/NNN-feature-slug/issues.md`:**

```markdown
# Issues: [Feature Name]

**Last Updated:** YYYY-MM-DD

## Open Issues

### Issue 1: [Title]
**Task:** [N.M]
**Type:** [Test/Code/Plan Deviation]
**Description:** [What's wrong]
**Resolution:** [Pending/Fixed in Task X.Y/Deferred]

## Resolved Issues

### Issue 2: [Title]
**Task:** [N.M]
**Resolution:** [How it was fixed]
**Resolved:** YYYY-MM-DD
```

### Phase 5: Checkpoints (Batched Mode)

**Goal:** Regular opportunities for user review.

**In batched mode, after every 2-3 tasks:**

```
"**Checkpoint - Section [N] progress:**

**Completed:**
- Task [N.1]: [summary] - Reviews: PASS
- Task [N.2]: [summary] - Reviews: PASS
- Task [N.3]: [summary] - Reviews: PASS

**All Orchestrator reviews:** Passed
**Next up:** Task [N.4]: [name]

How's it looking? Ready to continue, or want to review anything?"
```

[Wait for feedback before continuing]

### Phase 6: Section Completion

**Goal:** Mark progress before next section.

At end of each section:

```
"**Section [N]: [Name] - Complete**

**Tasks completed:** [count]
**Files created:** [list]
**Files modified:** [list]
**All tests:** Passing
**All reviews:** Passed

Ready to move to Section [N+1]: [Name]?"
```

### Phase 7: Implementation Complete

**Goal:** Verify everything works together.

After all sections:

```
**Implementation Complete!**

**Summary:**
- [N] tasks completed across [M] sections
- [X] files created
- [Y] files modified
- All tests passing
- All Orchestrator reviews passed

**Final verification results:**
- All tests pass: [result]
- Linting passes: [result]
- Build succeeds: [result]
- Feature works end-to-end: [result]

**Issues logged:** [count] (see issues.md)

What's next?

**A) Finalize with commit skill** (Recommended)
   Wrap up, update artifacts, and prepare for PR

**B) Run additional tests**
   More verification before finalizing

**C) Review the implementation**
   Look at what was built before committing

**D) Other**
   Something else in mind
```

**Transition to:** `commit` skill (if user confirms)

## When to Stop and Ask

**STOP immediately when:**
- Test fails unexpectedly (not as planned)
- Orchestrator review finds issues
- Plan step is unclear or seems wrong
- Missing dependency discovered
- You're uncertain about something

```
**Blocker encountered:**

**Task:** [Current task]
**Issue:** [What went wrong]

How should we proceed?

**A) [Suggested fix]** (Recommended)
   [Why this approach is best]

**B) [Alternative approach]**
   [Trade-offs of this approach]

**C) Skip this task for now**
   Continue with next task, return to this later

**D) Other**
   Different approach in mind
```

**Ask ONE question. Wait for answer.**

## Key Principles

- **ONE question at a time** - Never batch questions
- **Multiple choice first** - Easier than open-ended
- **Always include "Other"** - User can provide free text
- **Lead with recommendation** - Mark it clearly with "(Recommended)"
- **Follow the plan exactly** - Don't improvise unless blocked
- **TDD strictly** - Write test, fail, implement, pass
- **Commit after each task** - Small, atomic commits
- **Orchestrator reviews after each task** - Never skip
- **Log issues** - Track everything in issues.md
- **Stop when blocked** - Don't guess, ask

## Red Flags

**Never:**
- Ask multiple questions at once
- Present options without a recommendation
- Skip the "Other" option
- Skip Orchestrator reviews
- Ignore failing tests
- Deviate from plan without discussing
- Push through blockers without asking
- Write code not in the plan

**Always:**
- One question at a time
- Use multiple choice format
- Include your recommendation
- Include "Other" for free text
- Wait for response before next question
- Announce each task before starting
- Run all Orchestrator reviews after each task
- Log issues to issues.md
- Commit after each task
- Checkpoint in batched mode
- Report progress clearly
- Stop and ask when uncertain
