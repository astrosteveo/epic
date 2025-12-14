---
name: epic-handoff
description: Create structured handoff documents for session transfer, capturing current workflow context in under 200 lines. Use when ending a session, switching tasks, or at major phase completion (context exceeds 60%). Creates timestamped documents in .claude/handoffs/[slug]/YYYY-MM-DD_HH-MM-SS_[description].md with task status, git state, critical references, learnings, and next steps.
allowed-tools:
  - Read
  - Write
  - Glob
  - Bash(git:status, git:log, git:rev-parse, git:branch)
  - AskUserQuestion
---

# Epic Handoff

## Overview

Creates handoff documents that compact current session context into structured, concise format for efficient session resumption. Captures essential state, uses file references instead of full content, and maintains workflow continuity without context bloat.

## Workflow

### 1. Locate Active Feature

Search for current workflow state:
```bash
# Find workflow directory
ls .claude/workflows/*/state.md
```

Read `state.md` to extract:
- Feature name and slug
- Current phase (explore/plan/implement/validate/commit)
- Workflow directory path
- Task progress

**If no workflow found**: Create general handoff without workflow context. Prompt user for description.

### 2. Gather Context

#### Git Information
```bash
git rev-parse HEAD          # Current commit hash
git branch --show-current   # Current branch
git status --short          # Working tree status
```

#### Workflow Artifacts (if workflow exists)

From feature directory (`.claude/workflows/NNN-slug/`), read available artifacts:
- `state.md` - Current phase and task progress
- `plan.md` - Implementation plan with phases
- `codebase-research.md` - Internal codebase findings
- `docs-research.md` - External documentation research
- `validation.md` - Test/lint/build results

Extract:
- Current task IDs and status (pending/in_progress/completed)
- Which phase is active
- Completed vs remaining work
- Blockers or issues

### 3. Generate Handoff Path

Create timestamped path:
```
.claude/handoffs/[feature-slug]/YYYY-MM-DD_HH-MM-SS_[description].md
```

Components:
- `YYYY-MM-DD`: Current date
- `HH-MM-SS`: Current time (24-hour)
- `[feature-slug]`: From state.md or "general"
- `[description]`: From command argument or derived from feature

Example: `.claude/handoffs/003-add-auth/2025-01-15_14-30-22_phase2-complete.md`

### 4. Create Handoff Document

Use template structure (see `references/handoff-template.md`):

**Frontmatter:**
```yaml
---
date: [ISO 8601 timestamp with timezone]
git_commit: [commit hash]
branch: [branch name]
feature: [feature slug]
topic: "[Feature description]"
tags: [handoff, current-phase]
status: complete
---
```

**Content Sections:**
1. **Task(s)**: Current tasks with status (completed/WIP/planned), current phase, plan reference
2. **Critical References**: 2-3 most important documents with file paths
3. **Recent Changes**: Files changed in `file:line` format, focus on session changes
4. **Learnings**: Patterns discovered, root causes, gotchas, constraints
5. **Artifacts**: Exhaustive list of workflow artifacts with status
6. **Action Items & Next Steps**: Prioritized list for next session
7. **Other Notes**: Additional context, links, references

### 5. Confirm with User

Present handoff summary:
- Handoff file path
- Task summary (done vs remaining)
- Next steps

Ask: "Create this handoff?"
- Options: "Yes, create handoff" / "Edit description" / "Cancel"

### 6. Write and Report

After confirmation:
1. Create directory: `mkdir -p .claude/handoffs/[feature-slug]/`
2. Write handoff document
3. Report completion:

```
✓ Handoff Created

Path: .claude/handoffs/[slug]/[filename].md
Feature: [description]
Phase: [current phase]

Next session can resume with:
  /epic:resume .claude/handoffs/[slug]/[filename].md
```

## Handoff Document Structure

See `references/handoff-template.md` for complete template with placeholders.

**Key principles:**
- Use `file:line` references, not full content
- Target < 200 lines total
- Capture all task status
- Include git state for environment recreation
- More information, not more words

## Context Efficiency Rules

**When to create handoff:**
- Context utilization > 60%
- Switching to different task
- Session ending
- Major phase completion

**How handoffs save context:**
- Structured format vs raw artifacts
- File references vs full content
- Task status without implementation details
- Learnings without research duplicates

**Resume efficiency:**
- Next session reads handoff only
- References guide targeted artifact reading
- No need to re-grep or re-research
- Git state enables environment match

## Output Formats

### Success
```
✓ Handoff Created

Path: .claude/handoffs/[slug]/[filename].md
Feature: [description]
Phase: [current phase]

Next session can resume with:
  /epic:resume .claude/handoffs/[slug]/[filename].md
```

### Blocked
```
⚠️ Cannot Create Handoff

Reason: [specific issue]
Resolution: [specific action]
```

## Resources

### references/handoff-template.md
Complete handoff document template with all sections, placeholders, and formatting guidance.
