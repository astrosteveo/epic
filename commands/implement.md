---
description: Execute implementation plan phase by phase
argument-hint: [--phase N] [--continue]
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash(npm:*, npx:*, cargo:*, go:*, python:*, pytest:*, make:*, git:status, git:diff)
  - AskUserQuestion
---

# Implement Phase

Execute the **Implement** phase of the Frequent Intentional Compaction workflow.

Follow the approved plan exactly, executing one phase at a time with verification after each.

**Running this command implicitly approves the implementation plan.**

## Arguments

| Argument | Description |
|----------|-------------|
| `--phase N` | Start at specific phase number |
| `--continue` | Resume from last recorded progress |

## Process

### 1. Locate Active Feature

Find the current workflow state:
```
.claude/workflows/*/state.md
```

Read `state.md` to get:
- Feature directory path
- Current phase status

**If Plan not complete:**
```
⚠️ Cannot implement - Plan phase incomplete

Run `/plan` first to create implementation plan.
```
Stop and inform user.

### 2. Load Plan and Progress

From the feature directory, read:

| Document | Purpose |
|----------|---------|
| `plans/implementation-plan.md` | The approved plan to follow |
| `implementation/progress.md` | Previous progress (if exists) |

Determine starting point:
- If `--phase N` provided → Start at phase N
- If `--continue` provided → Resume from progress.md
- If progress.md exists → Ask user: resume or restart?
- Otherwise → Start at phase 1

Update `state.md`: Set Implement status to "in_progress".

### 3. Execute Phase

For each phase, follow this sequence:

#### 3a. Announce Phase

```
## Phase [N]: [Name]

Starting implementation of:
- [Change 1]
- [Change 2]
- ...

Files affected:
- path/to/file.ts
- path/to/other.ts
```

#### 3b. Make Changes

Execute the specific changes from the plan:
- Create new files as specified
- Modify existing files at specified locations
- Delete files if required

**Follow the plan exactly.**

#### 3c. Handle Deviations

If reality doesn't match the plan:

```
⚠️ Deviation Detected

Plan expected: [what plan said]
Actual state: [what was found]

Options:
1. Adjust implementation to work with actual state
2. Update plan to reflect reality
3. Stop and investigate
```

Use AskUserQuestion to get direction. Do NOT proceed without guidance.

#### 3d. Run Verification

Execute ALL verification steps from the plan:

**Automated checks:**
```bash
npm test          # or cargo test, pytest, etc.
npm run lint      # or cargo clippy, ruff, etc.
npm run typecheck # or cargo check, mypy, etc.
```

**Capture results:**
- Command executed
- Pass/Fail status
- Error summary (if failed)

#### 3e. Report Phase Results

```
## Phase [N] Results

### Changes Made
- ✓ Created: path/to/new.ts
- ✓ Modified: path/to/existing.ts:45-67
- ✓ Deleted: path/to/old.ts

### Verification
| Check | Status | Notes |
|-------|--------|-------|
| Tests | ✓ PASS | 42 passed |
| Lint | ✓ PASS | No issues |
| Types | ✓ PASS | No errors |

### Manual Verification Required
- [ ] [Manual check from plan]
```

#### 3f. Update Progress

Write/update `implementation/progress.md`:

```markdown
# Implementation Progress

**Feature**: [description]
**Last Updated**: [timestamp]
**Current Phase**: [N] of [total]

## Phase Status

| Phase | Status | Notes |
|-------|--------|-------|
| Phase 1 | ✓ Complete | [notes] |
| Phase 2 | → In Progress | [notes] |
| Phase 3 | Pending | |

## Current Phase Details

### Completed
- [x] Change 1
- [x] Change 2

### Verification Results
- Tests: PASS
- Lint: PASS
- Types: PASS

### Deviations
[None / Description of any deviations]
```

### 4. Phase Transition

After each phase:

```
## Phase [N] Complete

Automated verification: ✓ All passed
Manual verification needed:
- [ ] [Check 1]
- [ ] [Check 2]

Ready to proceed to Phase [N+1]?
```

Use AskUserQuestion:
- "Yes, continue to Phase [N+1]"
- "Pause here for review"
- "Stop implementation"

### 5. Completion

When ALL phases complete:

Update `state.md`: Set Implement status to "complete".

```
✓ Implementation Complete

All [N] phases executed successfully.

Summary:
- Files created: [count]
- Files modified: [count]
- Files deleted: [count]

All automated verification passed.

Next: Run `/validate` for final checks, then `/commit`
```

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

Artifacts:
- Progress: implementation/progress.md
- Changes: [list of modified files]

Next: Run `/validate`, then `/commit`
```

## Safety Rules

1. **Plan is law** - Follow it exactly; deviations require human approval
2. **Verify every phase** - Never skip automated or manual verification
3. **Document everything** - Progress.md enables session resumption
4. **Stop on failure** - Don't proceed if verification fails
5. **Ask, don't assume** - When uncertain, use AskUserQuestion

## Deviation Protocol

If you encounter something unexpected:

1. **STOP** - Do not continue implementing
2. **DOCUMENT** - Record the deviation in progress.md
3. **COMMUNICATE** - Explain what's different and why
4. **ASK** - Get human guidance via AskUserQuestion
5. **WAIT** - Do not proceed without explicit direction
