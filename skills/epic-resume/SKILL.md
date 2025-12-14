---
name: epic-resume
description: Resume work from a previous session via handoff document or workflow state. Efficiently restores context for session continuity. Triggered when user needs to continue interrupted work, switch between features, or restore context from a different session. Uses minimal context loading (target under 20%) while providing full situational awareness.
allowed-tools:
  - Read
  - Glob
  - AskUserQuestion
---

# Epic Resume

## Overview

Efficiently restore context from a previous EPIC workflow session by loading handoff documents or active workflow state. This skill enables seamless session transitions with minimal context consumption.

## When to Use

- User explicitly runs `/epic:resume [path]`
- User mentions resuming, continuing, or picking up previous work
- User references a handoff document or workflow by slug
- Session begins and user wants to restore previous context
- Switching between multiple feature workflows

## Workflow Decision Tree

```
Start
  │
  ├─ Path argument provided?
  │  ├─ Yes → Validate path → Load item (Step 3)
  │  └─ No ↓
  │
  ├─ Discover options (Step 2)
  │  ├─ Find handoffs: .claude/handoffs/**/*.md
  │  └─ Find workflows: .claude/workflows/*/state.md
  │
  ├─ Options found?
  │  ├─ Yes → Present picker → Get user selection
  │  └─ No → Report "Nothing to Resume"
  │
  ├─ Load selected item (Step 3)
  │  ├─ Handoff → Parse frontmatter + sections
  │  └─ Workflow → Parse state.md
  │
  ├─ Determine phase → Selectively load artifacts (Step 4)
  │
  └─ Present context summary (Step 6)
```

## Step 1: Parse Argument

Check for optional path argument:
- **With path**: Validate it exists, proceed to Step 3
- **Without path**: Proceed to Step 2 for picker

## Step 2: Discover Available Options

Use Glob to find resumable items:

### Handoff Documents
```bash
# Pattern: .claude/handoffs/**/*.md
```

Extract from frontmatter:
- `date` - When created (ISO format)
- `feature` - Feature slug
- `topic` - Description
- `tags` - Includes phase

Sort by date (most recent first).

### Active Workflows
```bash
# Pattern: .claude/workflows/*/state.md
```

Extract from frontmatter:
- `feature` - Feature slug
- `current_phase` - Phase name
- `last_updated` - Last modified date

From body:
- Phase Status table - which phases are complete
- Current Progress section - active tasks

Sort by last_updated (most recent first).

### Present Picker

Use AskUserQuestion with clear formatting:

```
Which session would you like to resume?

**Recent Handoffs:**
1. [2025-01-15 14:30] 003-add-auth - Phase 2 complete
2. [2025-01-14 09:15] 002-caching - Implementation blocked

**Active Workflows:**
3. [Implement] 003-add-auth - Phase 2 of 4
4. [Plan] 004-logging - Ready for implement

Options: [1] / [2] / [3] / [4]
```

**Limit**: Show 4 most recent options total. If more exist, note: "Run with explicit path for older sessions."

## Step 3: Load Selected Item

### If Handoff Document

Read the handoff file and extract:

**From Frontmatter:**
- `date`, `feature`, `topic`, `branch`, `git_commit`
- `tags` - determines phase
- `status` - completion state

**From Sections:**
- `## Task(s)` - table with task status, current phase
- `## Critical References` - most important docs to follow
- `## Recent Changes` - file:line references
- `## Learnings` - patterns/discoveries
- `## Artifacts` - table of artifact paths and status
- `## Action Items & Next Steps` - what to do next

### If Workflow State

Read `state.md` and extract:

**From Frontmatter:**
- `feature`, `current_phase`, `last_updated`

**From Sections:**
- `## Phase Status` - table showing completed phases
- `## Background Agents` - task IDs and status (if in Explore)
- `## Current Progress` - Phase Summary table + Active Work
- `## Verification Results` - test/lint/type check status
- `## Blockers` - current blockers
- `## Next Steps` - what to do next

## Step 4: Selective Artifact Loading

Load artifacts based on current phase to minimize context:

| Phase | Load | Rationale |
|-------|------|-----------|
| **Explore** | state.md summary only | Research in progress, nothing to implement yet |
| **Plan** | state.md + research summaries (first 50 lines each) | Need research context for planning |
| **Implement** | state.md + plan.md (full) + current phase from progress | Need full plan + current progress |
| **Validate** | state.md + plan.md (summary) + progress + validation.md | Need to know what was built + test results |
| **Commit** | state.md + all artifact summaries (first 30 lines each) | Need overview for commit message |

### Efficiency Rules

**DO:**
- Load handoff documents in full (already compacted)
- Use `file:line` references instead of full content
- Load only phase-relevant artifacts
- Present summaries, not raw data
- Read first N lines for context, not entire files

**DON'T:**
- Read all research files in full
- Re-read implementation details unless in Implement phase
- Load validation results unless in Validate/Commit phase
- Load completed phases' artifacts

**Target**: Use < 20% of context window while providing full situational awareness.

## Step 5: Determine Next Action

Based on loaded context, identify:

1. **Current Phase**: Where in the workflow
2. **In-Progress Task**: What's actively being worked on
3. **Next Command**: What command should be run next
4. **Immediate Action**: What user should do right now

Examples:
- Explore phase + agents running → "Wait for agent completion"
- Plan phase + research complete → "Review research, then run /epic:plan"
- Implement phase + Phase 2 in progress → "Continue Phase 2 implementation"
- Validate phase + tests failing → "Fix failing tests, then run /epic:validate"

## Step 6: Present Context Summary

### Success (from Handoff)

```
✓ Resumed from Handoff

Source: .claude/handoffs/003-add-auth/2025-01-15_14-30-22_phase2-complete.md
Feature: Add JWT authentication to API endpoints
Phase: Implement - Phase 2 of 4
Git: feature/add-auth @ a1b2c3d

## Current State
Phase 2 (middleware implementation) completed and tested.
JWT validation middleware working with test coverage.

## In Progress
- [x] JWT middleware implementation
- [x] Unit tests for middleware
- [ ] Integration tests with protected routes

## Next Steps
1. Run /epic:implement --phase 3 to begin Phase 3 (protected routes)
2. Update existing route handlers to use auth middleware
3. Run /epic:validate after implementation

## Critical References
- .claude/workflows/003-add-auth/plan.md - Full implementation plan
- src/middleware/auth.ts:15-45 - JWT middleware implementation

## Loaded Artifacts
- Handoff document (full)
- plan.md (summary - phases 3-4)
- state.md (referenced)

Context: 18% | Ready to continue. What would you like to do?
```

### Success (from Workflow)

```
✓ Resumed from Workflow

Source: .claude/workflows/004-logging/state.md
Feature: Add structured logging with Winston
Phase: Plan
Last Updated: 2025-01-15 09:30

## Current State
Research complete. Codebase and documentation explored.
Ready to create implementation plan.

## In Progress
- [x] Codebase exploration (agent completed)
- [x] Winston v3 documentation review (agent completed)
- [ ] Create phased implementation plan

## Next Steps
1. Run /epic:plan to create implementation plan
2. Review plan for approval
3. Begin implementation after approval

## Loaded Artifacts
- state.md (full)
- codebase-research.md (summary)
- docs-research.md (summary)

Context: 15% | Ready to continue. What would you like to do?
```

### No Options Found

```
⚠️ Nothing to Resume

No handoffs found in .claude/handoffs/
No active workflows found in .claude/workflows/

Start a new workflow with: /epic:explore [feature]
```

### Path Not Found

```
⚠️ Cannot Resume

Path not found: .claude/handoffs/003-add-auth/nonexistent.md

Available handoffs:
- .claude/handoffs/003-add-auth/2025-01-15_14-30-22_phase2-complete.md
- .claude/handoffs/002-caching/2025-01-14_09-15-00_blocked.md

Available workflows:
- .claude/workflows/003-add-auth/state.md
- .claude/workflows/004-logging/state.md

Run /epic:resume without arguments to see a picker.
```

## Error Handling

### Missing Frontmatter
If a handoff or state file lacks required frontmatter fields, report:
```
⚠️ Invalid Document

File: [path]
Issue: Missing required frontmatter: [field names]

This file may be corrupted. Please check the file structure.
```

### Missing Referenced Artifacts
If artifacts listed in handoff don't exist, continue gracefully:
```
⚠️ Artifact Not Found

Expected: .claude/workflows/003-add-auth/plan.md
Status: File does not exist (may have been moved or deleted)

Continuing with available artifacts...
```

### Invalid Phase
If phase is not recognized:
```
⚠️ Unknown Phase

Phase: [unknown phase]
Expected: Explore, Plan, Implement, Validate, or Commit

Defaulting to minimal artifact loading.
```

## Context Reporting

Always report context utilization in the summary:
```
Context: 18% | Ready to continue
```

This transparency helps users understand context efficiency.

## Safety Rules

1. **Verify file exists** before attempting to read
2. **Validate frontmatter** - check for required fields
3. **Handle missing artifacts gracefully** - don't fail if referenced file doesn't exist
4. **Report what was loaded** - user should know what context is active
5. **Never assume phase** - always read from state/handoff, never infer
6. **Respect phase boundaries** - don't load artifacts from future phases

## Allowed Tools

- **Read**: Load handoff documents, state files, and selective artifacts
- **Glob**: Discover available handoffs and workflows
- **AskUserQuestion**: Present picker when no path provided
