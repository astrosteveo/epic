---
name: planning
description: |
  Use this skill for collaborative design through Socratic dialogue.
  Produces: .harness/{nnn}-{slug}/design.md and plan.md
---

# Planning Phase

Collaborative design through Socratic dialogue. Iterate until full agreement on approach.

## When to Use

- After research is complete and an approach is approved
- For any non-trivial implementation (3+ steps or multiple files)
- Returning to revise the plan after execution reveals issues

## The Process

### 1. Read Prior Artifacts

Start by reading:
- `requirements.md` - What we're building and success criteria
- `codebase.md` - Technical context and patterns
- `research.md` - Best practices and the approved approach

### 2. Design Architecture (design.md)

Create the high-level design through dialogue:

**Section by Section**
- Present each section and ask: "Does this sound right to you?"
- Iterate based on feedback before moving to next section

**Content to Cover**
- Component relationships and data flow
- Key interfaces and boundaries
- Mermaid diagrams to illustrate flow
- Answers: "What are we building and how do the pieces fit together?"

Create `.harness/{nnn}-{slug}/design.md`:
```markdown
# Design: {Task Name}

## Architecture Overview
{High-level description with mermaid diagram}

## Components
{Key components and their responsibilities}

## Data Flow
{How data moves through the system}

## Interfaces
{Key interfaces and boundaries}

## Key Decisions
{Design decisions and their rationale}
```

### 3. Detail Implementation Steps (plan.md)

Create the granular implementation plan:

**Step Sizing**
- Each step = 1-3 logical commits worth of work
- If a step grows too large, break it into multiple steps
- Steps should be independently verifiable

**Step Format**
- Task-prefixed IDs: `{nnn}-1`, `{nnn}-2`, etc.
- Specific files to create/modify
- Clear commit message for each step

Create `.harness/{nnn}-{slug}/plan.md`:
```markdown
# Implementation Plan: {Task Name}

## Overview
{Brief summary of the plan}

## Pre-Implementation Checklist
- [ ] requirements.md reviewed
- [ ] design.md approved
- [ ] User approval of plan

---

## Step {nnn}-1: {Description}

**Files to create/modify:**
- `path/to/file.ext`

**Details:**
{What to implement}

**Commit message:** `{type}: {description}`

---

## Step {nnn}-2: {Description}
...

---

## Summary
| Step | Description | Files |
|------|-------------|-------|

## Deferred Items
{Items moved to backlog.md}
```

### 4. Handle Deferrals

During planning, identify items to defer:
- Out of scope for current task
- Would add significant complexity
- Nice-to-have but not essential
- Depend on future work

Add deferred items to `.harness/backlog.md`:
```markdown
## Deferred from {nnn}-{slug}

- [ ] {Item description} - {Reason for deferral}
```

### 5. Handle Discovered Issues

**Unrelated bugs found:**
- Call it out: "Found an unrelated bug in X"
- Log to `.harness/backlog.md` with details
- Continue with current task

**Refactoring opportunities:**
- Note as improvement opportunity
- Log to `.harness/backlog.md`
- Keep moving

### 6. Get Approval

Before proceeding to Execute:
- Review the complete plan with user
- Confirm all sections of design.md
- Confirm all steps in plan.md
- Address any concerns

### 7. Offer Transition

When plan is approved:

> "Plan looks good. Ready to move to Execute? We'll follow TDD - writing tests first, then implementation."

## Key Principles

- **Section-by-section** - Don't dump a complete plan; iterate collaboratively
- **Scope control** - Break large steps into smaller ones
- **Defer wisely** - Keep the task focused; backlog captures the rest
- **Commit atomically** - Each step should be a logical unit
- **Stay aligned** - Plan must trace back to requirements

## Returning to Plan

You may return to this phase when:
- Execution hits issues that require plan changes
- User requests scope additions
- Technical blockers discovered

Update `design.md` and `plan.md` to reflect changes. Mark where you left off if execution was in progress.
