---
name: implement
description: "Executes an implementation plan with fresh agent per task, two-stage review (spec + quality), and manual verification checkpoints."
---

# Implement

## Overview

Execute an implementation plan by dispatching fresh subagent per task, with two-stage review after each: spec compliance first, then code quality. Stop for manual verification when needed.

**Core principle:** Fresh subagent per task + two-stage review = consistent quality, no context bloat.

## When to Use

Use this skill when:
- You have a validated implementation plan from `/plan`
- User says "let's implement", "execute the plan", "start building"
- Ready to move from planning to coding

## Prerequisites

Must have an implementation plan with:
- Defined tasks with complete code
- Marked dependencies
- Marked manual verification points

If no plan exists, guide user to `/plan` first.

## The Process

### Step 1: Read Plan Once

Read the implementation plan file ONCE at the start. Extract:
- All tasks with full text
- Dependencies between tasks
- Which tasks need manual verification
- Total task count

Create a TodoWrite with all tasks.

**Do NOT make subagents read the plan file.** You curate and provide exactly what each subagent needs.

### Step 2: Confirm Mode

If not already chosen, ask:
```
The plan has N tasks. How would you like to proceed?

A) Focused sessions (default)
   - One task at a time, verify between
   - ~10 min per task
   - Best for: learning, reviewing, complex work

B) Autonomous mode
   - Run all tasks, parallel where possible
   - Verify at the end
   - Best for: routine work, stepping away

C) Hybrid
   - Autonomous for straightforward tasks
   - Pause for complex/risky ones
```

### Step 3: Execute Tasks

For each task (or parallel batch if no dependencies):

#### 3a. Dispatch Implementer

Use `./prompts/implementer.md` template. Provide:
- Full task text (copied from plan, not "read task 3")
- Scene-setting context (project type, relevant files, architecture)
- Success criteria
- "What NOT to do" boundaries

**Implementer can ask questions** before or during work. Answer them, then let them continue.

Implementer will:
1. Implement the task
2. Run tests
3. Self-review
4. Commit
5. Report back

#### 3b. Dispatch Spec Reviewer

Use `./prompts/spec-reviewer.md` template. Provide:
- Task requirements (from plan)
- Implementer's report

**Critical:** Spec reviewer must NOT trust the implementer's report. They must read actual code and verify independently.

Spec reviewer checks:
- Missing requirements?
- Extra/unneeded work?
- Misunderstandings?

If **FAIL**: Implementer fixes → Spec reviewer re-reviews → Loop until pass

#### 3c. Dispatch Code Quality Reviewer

**Only after spec compliance passes.**

Use `./prompts/quality-reviewer.md` template.

Quality reviewer checks:
- Is code well-built?
- Clean, tested, maintainable?
- Following project patterns?

If **FAIL**: Implementer fixes → Quality reviewer re-reviews → Loop until pass

#### 3d. Manual Verification (if marked)

If task requires manual verification:

```
═══════════════════════════════════════════════════════
VERIFICATION CHECKPOINT

Task N complete. Please verify manually:

1. Run: [command]
2. Do: [specific action]
3. Verify: [expected behavior]
4. Check: [what could go wrong]

Reply with your observations when ready to continue.
═══════════════════════════════════════════════════════
```

Wait for user feedback before proceeding.

#### 3e. Mark Complete, Next Task

Update TodoWrite. Proceed to next task (or parallel batch).

### Step 4: Parallel Execution

If tasks have no dependencies, dispatch them in parallel:

```
Tasks 1, 2, 3 have no dependencies - running in parallel.

[Task 1: Implementer → Spec Review → Quality Review]
[Task 2: Implementer → Spec Review → Quality Review]
[Task 3: Implementer → Spec Review → Quality Review]

All three complete. Task 4 depends on these - starting now.
```

**Never run implementation subagents in parallel that might conflict** (editing same files). When in doubt, run sequentially.

### Step 5: Slice Complete

When all tasks done:
1. Summary of what was built
2. Suggest manual verification if not already done
3. Ask about next iteration: "What's the next smallest valuable increment?"

## Prompt Templates

Located in this skill directory:

- `./implementer.md` - Fresh subagent per task
- `./spec-reviewer.md` - Verifies spec compliance (skeptical)
- `./quality-reviewer.md` - Verifies code quality (after spec passes)

## Key Principles

- **Fresh agent per task** - No context bloat, consistent quality
- **Don't make subagent read plan** - You extract and provide
- **Two-stage review** - Spec first (right thing?), then quality (built right?)
- **Skeptical reviewer** - "Implementer finished suspiciously quickly. Do NOT trust the report."
- **Fix loops** - If reviewer finds issues, implementer fixes, reviewer re-checks
- **Manual verification** - Stop when human testing needed
- **Parallel when safe** - Run independent tasks simultaneously

## Focused vs Autonomous Mode

### Focused (Default)

```
Orchestrator: "Task 1: Create User model"
              [spawns implementer]
              [implementer completes]
              [spec review passes]
              [quality review passes]
              "Task 1 complete. Tests passing.
               Ready for Task 2, or want to verify first?"
User: "continue"
Orchestrator: "Task 2: Add auth middleware..."
```

User stays in the loop. Natural pause points.

### Autonomous

```
User: "Run it all, I'll be back in an hour"
Orchestrator: [runs all tasks with reviews]
              [parallel where possible]
              [stops only for manual verification or blockers]
              "Completed 7/10 tasks. Blocked on Task 8,
               needs your input on [question].
               Here's what was built: [summary]"
```

## Error Handling

**If implementer fails:**
- Dispatch fix subagent with specific instructions
- Don't try to fix manually (pollutes orchestrator context)

**If stuck in review loop (3+ iterations):**
- Pause and ask user for guidance
- Something may be unclear in requirements

**If task is impossible:**
- Report back with specifics
- May need to revise plan

## Red Flags

**Never:**
- Make subagent read the plan file
- Skip reviews (spec OR quality)
- Proceed with unfixed issues
- Run parallel implementers that might conflict
- Trust implementer's "I'm done" without verification
- Skip manual verification points
- Start quality review before spec compliance passes
