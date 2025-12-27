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

## Subagent Dispatch

**IMPORTANT: Use a subagent to perform the planning work.**

Dispatch the Task tool with `subagent_type="general-purpose"` to handle the planning phase work. This keeps main context low while the subagent does the detailed design and planning.

The subagent should follow the process below.

## The Process

### 1. Read Prior Artifacts

Start by reading:
- `requirements.md` - What we're building and success criteria
- `codebase.md` - Technical context and patterns
- `research.md` - Best practices and the approved approach

### 2. Clarify Ambiguities (Socratic Discovery)

**CRITICAL: Even if only 1% uncertain, ask for clarification.**

After reading the artifacts, go through Socratic discovery one more time to eliminate any ambiguity:

- **Review requirements** - Any unclear acceptance criteria? Any edge cases not covered?
- **Review research approach** - Is the chosen approach fully understood? Any implementation details unclear?
- **Check assumptions** - Are there any technical assumptions that need validation?
- **Scope boundaries** - Is it crystal clear what's in scope vs out of scope?

**Use AskUserQuestion for any clarification:**
```
Question: "Before I design the architecture, I want to clarify: {specific ambiguity}?"
Options:
  1. "{Your recommended interpretation} (Recommended)" - {Why this makes sense}
  2. "{Alternative interpretation}" - {Trade-offs}
  3. "{Another alternative}" - {Trade-offs}
```

This extra round of clarification ensures the plan and design are maximally detailed and precise.

### 3. Design Architecture (design.md)

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

**CRITICAL: Steps Must Be Subagent-Ready**

Each step will be dispatched to a subagent for execution. Steps must be:
- **Self-contained**: All context needed is in the step
- **Specific**: Exact files, exact changes, exact tests
- **TDD-ready**: What test to write, what behavior it validates
- **Commit-ready**: Specific commit message provided

**Step Sizing**
- Each step = 1-3 logical commits worth of work
- If a step grows too large, break it into multiple steps
- Steps should be independently verifiable
- Mark dependencies so parallel dispatch knows what can run simultaneously

**Step Format (Required Detail Level)**
- Task-prefixed IDs: `{nnn}-1`, `{nnn}-2`, etc.
- **Dependencies**: "Depends on: {nnn}-X" or "Independent"
- **Files to create/modify**: Full paths
- **Implementation details**: Specific code structures, function signatures, data structures
- **TDD guidance**: What test to write first, what it should verify
- **Clear commit message**: Using conventional commits format

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

**Dependencies:** Independent (or "Depends on: {nnn}-X")

**Files to create/modify:**
- `path/to/file.ext`

**TDD Approach:**
1. Write test: `tests/test_file.ext::test_behavior`
2. Test should verify: {specific behavior}
3. Then implement: {specific code structure}

**Details:**
{What to implement - be specific about:
 - Function signatures
 - Data structures
 - Algorithm approach
 - Edge cases to handle}

**Commit message:** `{type}({scope}): {description}`

---

## Step {nnn}-2: {Description}

**Dependencies:** Depends on: {nnn}-1

...

---

## Summary
| Step | Description | Dependencies | Files |
|------|-------------|--------------|-------|
| {nnn}-1 | {Description} | Independent | {files} |
| {nnn}-2 | {Description} | Depends on {nnn}-1 | {files} |

## Parallelization Opportunities
- Steps {nnn}-3, {nnn}-4, {nnn}-5 can run in parallel (independent, different files)
- Step {nnn}-6 waits for {nnn}-5 completion

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
