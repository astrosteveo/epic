---
name: subagent-driven-development
description: Use when executing implementation plans with independent tasks. Dispatches fresh subagent per task with two-stage review (spec compliance then code quality). Triggers when ready to implement a plan with multiple tasks.
---

# Subagent-Driven Development

Execute plans by dispatching fresh subagent per task, with two-stage review after each.

**Core principle:** Fresh subagent per task + two-stage review (spec then quality) = high quality, fast iteration.

**Announce at start:** "I'm using Subagent-Driven Development to execute this plan."

## The Process

```
1. Read plan, extract all tasks with full text
2. Create TodoWrite with all tasks
3. Read prompt templates from this skill folder

For Each Task:
│
├─ Dispatch Implementer (./implementer-prompt.md)
│   ├─ If questions → answer, they continue
│   └─ When done → proceed to spec review
│
├─ Dispatch Spec Reviewer (./spec-reviewer-prompt.md)
│   ├─ If issues → implementer fixes → re-review
│   └─ When ✅ → proceed to quality review
│
├─ Dispatch Code Quality Reviewer (./code-quality-reviewer-prompt.md)
│   ├─ If Critical/Important → implementer fixes → re-review
│   └─ When approved → mark task complete
│
└─ Update TodoWrite, continue to next task

After All Tasks:
├─ Run final test suite
└─ Use finishing-branch skill
```

## Prompt Templates

Read these files and use them to construct Task calls:

- `./implementer-prompt.md` - Template for implementer subagent
- `./spec-reviewer-prompt.md` - Template for spec compliance reviewer
- `./code-quality-reviewer-prompt.md` - Template for code quality reviewer

When dispatching, use `Task` tool with `subagent_type: general-purpose` and fill in the template placeholders.

## Example Flow

```
You: I'm using Subagent-Driven Development to execute this plan.

[Read plan file: docs/plans/feature-plan.md]
[Extract all 3 tasks with full text]
[Create TodoWrite with all tasks]
[Read ./implementer-prompt.md template]

Task 1: User validation

[Dispatch Task with implementer template filled in]

Implementer: "Should validation return 400 or 422?"

You: "Use 422 for validation errors."

Implementer:
  - Implemented validateUser
  - 6 tests, all passing
  - Self-review: Fixed missing email check
  - Committed

[Read ./spec-reviewer-prompt.md template]
[Dispatch Task with spec reviewer template]

Spec Reviewer: ✅ Spec compliant

[Read ./code-quality-reviewer-prompt.md template]
[Dispatch Task with quality reviewer template]

Code Quality Reviewer:
  Issues (Important): Magic regex should be constant

[Dispatch implementer to fix]

Implementer: Extracted EMAIL_REGEX constant, committed

[Re-dispatch quality reviewer]

Code Quality Reviewer: ✅ Approved

[Mark Task 1 complete]

Task 2: ...
[Continue pattern]
```

## Key Behaviors

**Read templates, don't hardcode prompts:**
- Templates live in this skill folder
- Read them at execution time
- Fill in placeholders with task-specific content

**Answer subagent questions:**
- Implementers may ask before starting
- Provide clear, complete answers
- Don't rush them

**Handle review loops:**
- If reviewer finds issues → dispatch implementer to fix
- After fix → re-dispatch same reviewer
- Repeat until approved
- Never skip re-review

**Track progress:**
- Update TodoWrite as tasks complete
- One task in_progress at a time

## Red Flags - NEVER

- Skip reviews (both required)
- Proceed with unfixed issues
- Dispatch parallel implementers
- Hardcode prompts instead of reading templates
- Make subagent read plan file (provide full text)
- Accept "close enough" on spec compliance
- Start quality review before spec passes
- Move to next task with open issues
