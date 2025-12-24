---
name: plan-validator
description: Validates that implementation follows the plan. Used after each task to ensure plan adherence and at the end for final verification. Tracks deviations and ensures completeness.
---

# Plan Validator

## Overview

Validate that implementation follows the plan. This skill is used in two modes: **per-task validation** after each implementation task, and **final verification** when all tasks are complete.

**Purpose:** Ensure the plan is being followed and the implementation is complete.

**Input:**
- `.workflow/NNN-feature-slug/plan.md`
- Completed implementation work
- Previous validation results (for final verification)

**Output:**
- Validation verdict: ALIGNED or DEVIATION_DETECTED
- Deviation log (if any)
- Completion status (for final verification)

**Announce at start:** "I'm using the plan-validator skill to verify plan adherence."

## When to Use

### Per-Task Validation
- After each task is completed (following test and code review)
- Before proceeding to the next task

### Final Verification
- After all tasks are complete
- Before declaring the implementation done

## Per-Task Validation

### What to Check

After each task:

1. **Task Completion**
   - [ ] All deliverables from the task are present
   - [ ] Files created/modified match the plan
   - [ ] No planned work was skipped

2. **Scope Adherence**
   - [ ] Nothing was added beyond the task scope
   - [ ] No "while I'm here" changes
   - [ ] No premature optimization

3. **Dependency Respect**
   - [ ] Task didn't depend on incomplete work
   - [ ] Prerequisites were met before starting
   - [ ] No forward references to future tasks

4. **Quality Gates Met**
   - [ ] Tests passed (verified by test-reviewer)
   - [ ] Code reviewed (verified by code-reviewer)
   - [ ] No blocking issues outstanding

### Validation Process

```
1. Read the current task from plan.md
2. Compare completed work to task requirements
3. Check for scope creep or missing items
4. Verify quality gates are met
5. Log any deviations
6. Update task status in tracking
```

### Output Format: Per-Task

#### ALIGNED

```markdown
## Plan Validation: Task [N] - ALIGNED

**Task:** [Task name from plan]
**Status:** Complete and aligned with plan

### Deliverables Verified
- [x] `path/to/file.ts` - [created/modified as planned]
- [x] `path/to/test.ts` - [tests written as planned]

### Quality Gates
- [x] Tests pass
- [x] Code review approved
- [x] Test review approved

### Notes
[Any observations, or "None"]

**Verdict:** Proceed to Task [N+1]
```

#### DEVIATION_DETECTED

```markdown
## Plan Validation: Task [N] - DEVIATION_DETECTED

**Task:** [Task name from plan]
**Status:** Deviations found

### Deviations

#### Deviation 1: [Type] - [Brief description]

**Expected (from plan):**
[What the plan specified]

**Actual:**
[What was implemented]

**Impact:** [Low/Medium/High]

**Resolution required:**
- [ ] [Specific action to resolve]

#### Deviation 2: [Type]
[Same structure]

### Verdict Options

**A) Fix deviations before proceeding**
   Return to Coder to address deviations

**B) Accept deviations and update plan**
   Document why deviation is acceptable, update plan.md

**C) Escalate to user**
   Deviation requires user decision
```

## Final Verification

### What to Check

After all tasks complete:

1. **Completeness**
   - [ ] All tasks in plan.md are marked complete
   - [ ] All deliverables exist
   - [ ] No tasks were skipped or deferred without documentation

2. **Integration**
   - [ ] Components work together
   - [ ] No orphaned code (created but not integrated)
   - [ ] All integration points connected

3. **Design Alignment**
   - [ ] Final implementation matches design.md
   - [ ] All architectural decisions honored
   - [ ] Contracts.md fulfilled (if exists)

4. **Deviation Summary**
   - [ ] All deviations documented
   - [ ] Deviations were accepted or resolved
   - [ ] No untracked scope changes

5. **Quality Summary**
   - [ ] All tests passing
   - [ ] No outstanding code review issues
   - [ ] No unresolved issues in issues.md

### Verification Process

```
1. Read complete plan.md
2. Verify each task is marked complete
3. Cross-reference deliverables with filesystem
4. Review deviation log for unresolved items
5. Compare final state to design.md
6. Generate completion report
```

### Output Format: Final Verification

#### COMPLETE

```markdown
## Final Plan Verification: COMPLETE

**Feature:** [Feature name]
**Plan:** `.workflow/NNN-feature-slug/plan.md`

### Task Summary

| Task | Status | Notes |
|------|--------|-------|
| Task 1: [Name] | Complete | - |
| Task 2: [Name] | Complete | - |
| Task 3: [Name] | Complete | Minor deviation accepted |
| Task 4: [Name] | Complete | - |

**Total:** [N] tasks complete

### Deliverables

All planned deliverables present:
- [x] `path/to/component.ts`
- [x] `path/to/service.ts`
- [x] `path/to/tests/`
- [x] [Additional deliverables]

### Design Alignment

Implementation aligns with design.md:
- [x] Architecture matches
- [x] Interfaces implemented correctly
- [x] Data models match contracts.md

### Deviations Accepted

| Deviation | Reason | Approved |
|-----------|--------|----------|
| [Deviation 1] | [Reason] | Yes |

### Quality Summary

- Tests: All passing
- Code reviews: All approved
- Open issues: None

**Verdict:** Implementation complete and verified.
```

#### INCOMPLETE

```markdown
## Final Plan Verification: INCOMPLETE

**Feature:** [Feature name]
**Plan:** `.workflow/NNN-feature-slug/plan.md`

### Incomplete Items

#### Missing Tasks

| Task | Status | Issue |
|------|--------|-------|
| Task 3: [Name] | Incomplete | [What's missing] |

#### Unresolved Deviations

| Deviation | Impact | Required Action |
|-----------|--------|-----------------|
| [Deviation] | [Impact] | [Action needed] |

#### Outstanding Issues

From `.workflow/NNN-feature-slug/issues.md`:
- [ ] [Issue 1]
- [ ] [Issue 2]

### Verdict Options

**A) Complete remaining work**
   [List specific tasks to complete]

**B) Defer incomplete items to backlog**
   Move to `.workflow/backlog.md`

**C) Accept as partial completion**
   Document what's missing, close feature
```

## Deviation Types

| Type | Description | Example |
|------|-------------|---------|
| **SCOPE_CREEP** | Added work not in plan | Extra feature, premature optimization |
| **SCOPE_REDUCTION** | Planned work not done | Skipped requirement, deferred functionality |
| **APPROACH_CHANGE** | Different implementation than planned | Different library, different pattern |
| **ORDER_CHANGE** | Tasks done in different order | Dependency violation, parallel execution |
| **QUALITY_SKIP** | Quality gate bypassed | Skipped tests, incomplete review |

## Deviation Tracking

Maintain a deviation log in issues.md:

```markdown
## Deviations Log

### Task 3: Deviation - SCOPE_CREEP

**Date:** YYYY-MM-DD
**Description:** Added caching layer not in original plan
**Reason:** Performance requirement discovered during implementation
**Impact:** Medium - added 2 hours of work
**Resolution:** Accepted - updated plan to include caching
**Approved by:** User confirmation on YYYY-MM-DD
```

## Key Principles

- **Plan is the source of truth** - Deviations need justification
- **Track everything** - No undocumented changes
- **Early detection** - Catch deviations per-task, not at the end
- **Flexibility with accountability** - Plans can change, but changes must be tracked
- **Quality gates are mandatory** - Never skip reviews to stay on plan

## Red Flags

These require immediate attention:

- Tasks marked complete but deliverables missing
- Quality gates skipped "to save time"
- Scope creep without documentation
- Dependencies violated (task done before prerequisite)
- Design decisions changed without updating design.md

## Anti-Patterns

**Don't:**
- Approve deviations silently
- Skip per-task validation "because we're behind"
- Let scope creep accumulate
- Accept "it works" as sufficient

**Do:**
- Document every deviation
- Validate after every task
- Update plan when accepting deviations
- Ensure quality gates are met
