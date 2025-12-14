---
name: epic-implement
description: Execute implementation plan phase by phase with verification after each. Use after /epic:plan to write code following the approved plan. Triggers on /epic:implement or when user wants to start coding, execute the plan, implement changes, or continue implementation from a previous session.
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash(npm:*, npx:*, cargo:*, go:*, python:*, pytest:*, make:*, git:status, git:diff)
  - AskUserQuestion
---

# Epic Implement

Implementation phase of the Explore-Plan-Implement workflow. Execute the approved plan exactly, one phase at a time with verification.

**Running this command implicitly approves the implementation plan.**

## Arguments

| Argument | Description |
|----------|-------------|
| `--phase N` | Start at specific phase number |
| `--continue` | Resume from last recorded progress |

## Workflow

```
1. Locate active workflow: .claude/workflows/*/state.md
2. Load plan.md and determine starting point
3. For each phase:
   a. Announce phase and changes
   b. Make changes per plan
   c. Handle any deviations (STOP and ask)
   d. Run verification checks
   e. Report results
   f. Update state.md progress
4. Ask before proceeding to next phase
5. Mark complete when all phases done
```

## Prerequisites

- Plan phase must be complete
- plan.md must exist in workflow directory

If prerequisites not met:
```
⚠️ Cannot implement - Plan phase incomplete
Run `/epic:plan` first.
```

## Starting Point Logic

| Condition | Action |
|-----------|--------|
| `--phase N` provided | Start at phase N |
| `--continue` provided | Resume from state.md progress |
| state.md has progress | Ask: resume or restart? |
| Otherwise | Start at phase 1 |

## Phase Execution Sequence

### 1. Announce Phase
```
## Phase [N]: [Name]

Starting implementation of:
- [Change 1]
- [Change 2]

Files affected:
- path/to/file.ts
```

### 2. Make Changes
Execute exactly as specified in plan:
- Create new files
- Modify existing files at specified locations
- Delete files if required

**Follow the plan exactly.**

### 3. Handle Deviations
If reality ≠ plan:
```
⚠️ Deviation Detected

Plan expected: [what plan said]
Actual state: [what was found]

Options:
1. Adjust implementation to work with actual state
2. Update plan to reflect reality
3. Stop and investigate
```

Use AskUserQuestion. Do NOT proceed without guidance.

### 4. Run Verification
Execute ALL verification steps from plan:
```bash
npm test          # Tests
npm run lint      # Linting
npm run typecheck # Type checking
```

### 5. Report Results
```
## Phase [N] Results

### Changes Made
- ✓ Created: path/to/new.ts
- ✓ Modified: path/to/existing.ts:45-67

### Verification
| Check | Status | Notes |
|-------|--------|-------|
| Tests | ✓ PASS | 42 passed |
| Lint | ✓ PASS | No issues |
| Types | ✓ PASS | No errors |

### Manual Verification Required
- [ ] [Manual check from plan]
```

### 6. Update Progress
Update `state.md` Current Progress section with phase status, verification results, and any deviations.

## Phase Transition

After each phase, ask user:
- "Yes, continue to Phase [N+1]"
- "Pause here for review"
- "Stop implementation"

## Output Format

### Phase Success
```
✓ Phase [N] Complete

Changes: [count] files modified
Verification: All checks passed
Progress: [N]/[total] phases complete

Next: [Continue to Phase N+1 / Manual verification required]
```

### Phase Blocked
```
⚠️ Phase [N] Blocked

Issue: [specific problem]
- Verification failed: [which check]
- Deviation: [what's different]

Resolution required before continuing.
```

### Implementation Complete
```
✓ Implementation Phase Complete

Feature: [description]
Phases: [N]/[N] complete
Verification: All automated checks passed

Next: Run /epic:validate, then /epic:commit
```

## Safety Rules

1. **Plan is law** - Follow exactly; deviations require human approval
2. **Verify every phase** - Never skip verification
3. **Document everything** - state.md enables session resumption
4. **Stop on failure** - Don't proceed if verification fails
5. **Ask, don't assume** - Use AskUserQuestion when uncertain

## Deviation Protocol

When something unexpected occurs:

1. **STOP** - Do not continue implementing
2. **DOCUMENT** - Record deviation in state.md
3. **COMMUNICATE** - Explain what's different and why
4. **ASK** - Get human guidance via AskUserQuestion
5. **WAIT** - Do not proceed without explicit direction

## References

- `references/progress-template.md` - State.md progress section format
