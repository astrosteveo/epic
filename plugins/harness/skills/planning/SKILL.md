---
name: planning
description: "Use after research is approved and before writing ANY code. Creates architecture design and implementation plan through Socratic dialogue. Produces design.md and plan.md."
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

Create the high-level design through dialogue.

**CRITICAL: How to Collaborate on Design**
- **Use the AskUserQuestion tool** - Better UX for confirmations and choices
- **Present one section at a time** - Don't overwhelm with the entire design
- **Provide 1-4 design options when applicable** - First option is your recommendation
- **Ask for confirmation** - "Does this approach look right to you?"
- **Be thorough** - Ask as many clarifying questions as needed
- **Iterate before moving on** - Get agreement on each section before the next

**Example using AskUserQuestion for design confirmation:**
```
Question: "For the data flow, should we use a synchronous or asynchronous approach?"
Options:
  1. "Synchronous API calls (Recommended)" - Simpler, easier to debug, sufficient for current scale
  2. "Asynchronous with message queue" - More scalable but adds operational complexity
  3. "Hybrid approach" - Sync for user-facing, async for background tasks
```

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

<!-- Add this marker when user approves: -->
<!-- APPROVED -->

## Overview
{Brief summary of the plan}

## Pre-Implementation Checklist
- [ ] requirements.md reviewed
- [ ] design.md approved
- [ ] User approval of plan (adds <!-- APPROVED --> marker)

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

**Use AskUserQuestion to get final approval:**
```
Question: "The plan is complete. Should we proceed to execution?"
Options:
  1. "Yes, proceed with execution (Recommended)" - Plan looks good, ready to implement
  2. "Revise the plan first" - Need to make changes before starting
  3. "Show me the plan summary again" - Want to review once more
```

**When user approves, add the approval marker to plan.md:**
```markdown
<!-- APPROVED -->
```

This marker is REQUIRED - the Execute phase will be blocked without it.
The gate enforces that no code changes can be made until the plan is approved.

### 7. Offer Transition

When plan is approved:

> "Plan looks good. Ready to move to Execute? We'll follow TDD - writing tests first, then implementation."

## Key Principles

- **Section-by-section** - Don't dump a complete plan; iterate collaboratively
- **Use AskUserQuestion** - Better UX for all confirmations and choices
- **Be thorough** - Ask as many clarifying questions as needed; user expects it
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
