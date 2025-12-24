---
name: plan
description: Use after design to create a concrete implementation plan. Breaks the design into bite-sized, executable tasks with structured templates for the Coder subagent. Outputs plan.md.
---

# Plan

## Overview

Transform design into action. This skill takes the architecture from `design-writer` and creates a step-by-step implementation plan with structured task templates that the Coder subagent can execute without additional exploration.

**Input:**
- `.workflow/NNN-feature-slug/codebase.md`
- `.workflow/NNN-feature-slug/research.md`
- `.workflow/NNN-feature-slug/design.md`
- `.workflow/NNN-feature-slug/contracts.md` (if exists)

**Output:** `.workflow/NNN-feature-slug/plan.md`

**Announce at start:** "I'm using the plan skill to create the implementation plan with structured task templates."

## When to Use

- After `design-writer` skill completes
- User says "plan", "break it down", "what are the steps"
- Invoked directly via `/plan`
- Before `implement` skill (plan guides implementation)

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

## The 3-Subagent Model

This plan will be executed by:
- **Orchestrator** - Manages workflow, provides task templates, performs all reviews
- **Coder** - Executes tasks following TDD, writes code
- **Discoverer** - Already completed (codebase.md, research.md)

**The plan eliminates Coder exploration** - Every task includes:
- Exact files to create/modify
- Relevant context from codebase.md
- Best practices from research.md
- Complete code templates

## The Process

### Phase 1: Load Context

**Goal:** Ground the plan in all discovery artifacts.

1. Read `.workflow/NNN-feature-slug/codebase.md`
2. Read `.workflow/NNN-feature-slug/research.md`
3. Read `.workflow/NNN-feature-slug/design.md`
4. Read `.workflow/NNN-feature-slug/contracts.md` (if exists)
5. Identify all components that need implementation
6. Determine natural ordering (dependencies)

```
Based on the design and discovery artifacts:

**Components to build:** [List them]
**Natural order:** [What depends on what]
**Estimated tasks:** [Rough count]

Are there any constraints on implementation order?

**A) No constraints, proceed as planned** (Recommended)
   Build in the natural dependency order

**B) Yes, specific order required**
   I'll tell you what needs to happen first

**C) Time-sensitive priorities**
   Some features are more urgent than others

**D) Other**
   Different constraint to consider
```

[Wait for response before proceeding]

### Phase 2: Task Breakdown

**Goal:** Create bite-sized, executable tasks with full context.

**Each task should be:**
- 2-5 minutes of focused work
- One clear action
- Independently testable where possible
- Complete (includes test + verification)
- **Self-contained** - No additional codebase exploration needed

**Task structure (for Coder subagent):**

```markdown
### Task N.M: [Task Name]

#### Context
- **Pattern to follow:** `existing/file.ts:15-30` (from codebase.md)
- **Best practice:** [Relevant finding from research.md]
- **Design reference:** [Relevant section from design.md]

#### Files
- Create: `path/to/new/file.ext`
- Modify: `path/to/existing/file.ext` (lines 10-25)
- Test: `path/to/test/file.ext`

#### Steps

1. **Write failing test**
   ```language
   // Test code here - complete, not placeholder
   ```

2. **Run test, verify failure**
   ```bash
   command to run test
   ```
   Expected: FAIL - [reason]

3. **Implement**
   ```language
   // Implementation code here - complete, not placeholder
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

#### Verification
- [ ] Test passes
- [ ] Follows pattern from codebase.md
- [ ] Applies best practice from research.md
- [ ] Matches design.md specification
```

**Group related tasks into logical sections.**

### Phase 3: Execution Mode Planning

**Goal:** Define how the Orchestrator will manage execution.

**Include in plan:**
1. **Execution mode options** - Autonomous vs Batched
2. **Review checkpoints** - Where Orchestrator reviews
3. **Quality gates** - What must pass before proceeding

### Phase 4: Validation

**Goal:** Confirm the plan makes sense.

Present the plan overview:
```
"Here's the implementation plan:

**Section 1: [Name]** (N tasks)
- [Task summaries]

**Section 2: [Name]** (N tasks)
- [Task summaries]

**Total:** N tasks across M sections

**Each task includes:**
- Full context from discovery artifacts
- Complete code (no placeholders)
- Verification checklist

Does this breakdown look right? Any tasks missing or unnecessary?"
```

[Wait for confirmation before writing]

### Phase 5: Plan Document

**Goal:** Capture the plan in plan.md.

**Write `.workflow/NNN-feature-slug/plan.md`:**

```markdown
# Implementation Plan: [Feature Name]

**Date:** YYYY-MM-DD
**Status:** Ready for implementation
**Codebase Analysis:** [Link to codebase.md]
**Research:** [Link to research.md]
**Design:** [Link to design.md]
**Contracts:** [Link to contracts.md if exists]

## Overview

**Goal:** [One sentence: what we're building]
**Approach:** [One sentence: how we're building it]
**Tasks:** [Count] tasks across [count] sections

## Execution Model

### Subagents

| Subagent | Role |
|----------|------|
| **Orchestrator** | Coordinates tasks, performs test/code/plan reviews |
| **Coder** | Executes tasks following TDD |

### Execution Modes

**Autonomous:** Coder executes all tasks sequentially with Orchestrator reviews after each.

**Batched:** Coder executes 2-3 tasks, then pauses for user review before continuing.

### Quality Gates

After each task, Orchestrator verifies:
1. **Test review:** Tests are real validations (not stubs/mocks)
2. **Code review:** Quality, best practices, design alignment
3. **Plan validation:** Task follows the plan exactly

---

## Section 1: [Section Name]

### Task 1.1: [Task Name]

#### Context
- **Pattern to follow:** `existing/file.ts:15-30`
- **Best practice:** [From research.md with source]
- **Design reference:** design.md Section X

#### Files
- Create: `path/to/new/file.ext`
- Modify: `path/to/existing/file.ext`
- Test: `path/to/test/file.ext`

#### Steps

1. **Write failing test**
   ```language
   // Complete test code
   ```

2. **Run test, verify failure**
   ```bash
   command to run test
   ```
   Expected: FAIL - [reason]

3. **Implement**
   ```language
   // Complete implementation code
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

#### Verification Checklist
- [ ] Test passes with real assertions
- [ ] Follows pattern from `existing/file.ts:15-30`
- [ ] Applies [best practice from research.md]
- [ ] Matches design.md specification

---

### Task 1.2: [Task Name]
[Same structure]

---

## Section 2: [Section Name]

### Task 2.1: [Task Name]
[Same structure]

---

## Final Verification Checklist

After all tasks complete:

- [ ] All tests pass: `[test command]`
- [ ] Linting passes: `[lint command]`
- [ ] Build succeeds: `[build command]`
- [ ] Feature works end-to-end: [how to verify]

## Issue Tracking

Issues discovered during implementation will be logged to:
`.workflow/NNN-feature-slug/issues.md`

## Rollback

If something goes wrong:
- [How to safely undo changes]
- [What to check before reverting]
```

## Handoff

After writing plan.md:

```
I've created the implementation plan and saved it to `.workflow/NNN-feature-slug/plan.md`.

**Summary:** [N] tasks across [M] sections
**First section:** [Name] - [what it accomplishes]

**Each task includes:**
- Full context from codebase.md and research.md
- Complete code (no exploration needed)
- Verification checklist

How would you like to proceed with implementation?

**A) Run `/implement` (autonomous)** (Recommended)
   I'll execute all tasks with Orchestrator reviews after each. Minimal interruption.

**B) Run `/implement` (batched)**
   I'll do 2-3 tasks, then pause for your review before continuing.

**C) Review the plan first**
   Let's look at the plan before starting implementation.

**D) Other**
   Different approach in mind
```

**IMPORTANT:** When user selects option A or B, invoke the `implement` skill using the Skill tool with the appropriate mode. Do NOT trigger built-in plan mode.

## Key Principles

- **ONE question at a time** - Never batch questions
- **Multiple choice first** - Easier than open-ended
- **Always include "Other"** - User can provide free text
- **Lead with recommendation** - Mark it clearly with "(Recommended)"
- **Bite-sized tasks** - 2-5 minutes each, one action
- **Self-contained** - No additional exploration needed
- **Test-driven** - Write test, verify fail, implement, verify pass
- **Complete code** - Never "add validation here", show the actual code
- **Full context** - Reference codebase.md, research.md, design.md
- **Exact paths** - Always full file paths with line numbers
- **Commit often** - Each task ends with a commit
- **YAGNI** - Only plan what's in the design

## Red Flags

**Never:**
- Ask multiple questions at once
- Present options without a recommendation
- Skip the "Other" option
- Create vague tasks ("implement the feature")
- Skip test steps
- Use placeholder code ("add validation logic")
- Combine multiple unrelated changes in one task
- Plan beyond the current design scope
- Require the Coder to explore/search

**Always:**
- One question at a time
- Use multiple choice format
- Include your recommendation
- Include "Other" for free text
- Wait for response before next question
- Reference all discovery artifacts
- Include complete, copy-pasteable code
- Specify exact file paths and line numbers
- Include verification checklists
- End tasks with commits
- Write plan.md to `.workflow/NNN-slug/`
