---
description: Create phased implementation plan from research
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Task
---

# Plan Phase

Execute the **Plan** phase of the Frequent Intentional Compaction workflow.

Create a detailed, phased implementation plan based solely on research findings.

## Process

### 1. Locate Active Feature

Find the current workflow state:
```
.claude/workflows/*/state.md
```

Read `state.md` to get:
- Feature description
- Directory path (e.g., `.claude/workflows/001-add-auth`)
- Phase status (Explore should be "complete")

**If Explore not complete:**
```
⚠️ Cannot create plan - Explore phase incomplete

Run `/explore [feature]` first to gather research.
```
Stop and inform user.

### 2. Load Research Artifacts

From the feature directory, read both research documents:

| Document | Contains |
|----------|----------|
| `research/codebase-exploration.md` | File locations, patterns, dependencies |
| `research/external-research.md` | Best practices, library docs, security guidance |

Extract key information:
- Files that need modification (with line numbers)
- Patterns to follow
- Dependencies to consider
- Security/performance requirements
- Potential risks

**If research is missing or incomplete:**
```
⚠️ Research insufficient for planning

Missing: [specific gaps]

Options:
1. Run `/explore [feature]` again with more specific focus
2. Proceed with partial information (higher risk)
```

### 3. Design Implementation Phases

Create phases that are:
- **Atomic** - Each phase is independently verifiable
- **Sequential** - Earlier phases establish foundation for later ones
- **Right-sized** - Completable in one focused session

#### Phase Structure Template

```markdown
## Phase N: [Descriptive Name]

### Changes
| File | Action | Description |
|------|--------|-------------|
| `path/to/file.ts:45-67` | Modify | [what changes] |
| `path/to/new.ts` | Create | [what it does] |

### Implementation Details
[Specific code changes, following patterns from research]

### Verification
**Automated:**
- [ ] `npm test` - [what it verifies]
- [ ] `npm run lint` - [expected result]
- [ ] `npm run typecheck` - [expected result]

**Manual:**
- [ ] [Specific thing to check manually]
```

### 4. Write Plan Artifact

Write the complete plan to: `[feature-dir]/plans/implementation-plan.md`

Use template: `${CLAUDE_PLUGIN_ROOT}/templates/implementation-plan.md`

**Required Sections:**

```markdown
# Implementation Plan: [Feature]

**Created**: [date]
**Research**: [links to research docs]

## Goal
[Clear statement of what will be achieved]

## Approach Summary
[Why this approach, based on research findings]

## Phases

[Phase 1...]
[Phase 2...]
[Phase N...]

## Rollback Plan
[How to undo if things go wrong]

## Success Criteria
- [ ] [Measurable criterion]
- [ ] All automated checks pass
- [ ] [Manual verification criterion]

## Open Questions
[Any decisions that need human input]
```

### 5. Validate Plan Quality

Before presenting, verify the plan:

| Check | Requirement |
|-------|-------------|
| Research-based | All decisions reference research findings |
| Specific | File paths include line numbers where possible |
| Verifiable | Every phase has automated AND manual verification |
| Complete | Rollback plan and success criteria defined |
| Right-sized | No phase is too large to complete in one session |

### 6. Present Plan Summary

Show the user:

```
## Plan Created

**Feature**: [description]
**Phases**: [count]
**Estimated Complexity**: [Low/Medium/High]

### Phase Overview
1. [Phase 1 name] - [brief description]
2. [Phase 2 name] - [brief description]
...

### Key Decisions
- [Decision 1 based on research]
- [Decision 2 based on research]

### Open Questions
- [Questions needing human input]

---

**Plan Location**: .claude/workflows/[slug]/plans/implementation-plan.md

⚠️ Review the plan before running `/implement`
Running `/implement` implies approval of this plan.
```

### 7. Update State

Update `state.md`:
- Set "Current Phase" to "plan"
- Set Plan status to "complete"

## Output Format

### Success
```
✓ Plan Phase Complete

Feature: [description]
Phases: [N] phases defined
Artifact: .claude/workflows/[slug]/plans/implementation-plan.md

Phase Summary:
1. [Phase 1] - [files affected]
2. [Phase 2] - [files affected]
...

Next: Review plan, then run `/implement`
```

### Blocked
```
⚠️ Cannot Create Plan

Reason: [specific issue]
- Missing research: [what's needed]
- Ambiguity: [what's unclear]

Resolution: [specific action]
```

## Quality Rules

1. **Research is truth** - Base ALL decisions on research findings, never training data assumptions
2. **Specificity required** - Vague plans create vague implementations
3. **Verification mandatory** - Every phase must have testable verification
4. **Human decisions flagged** - Don't assume; ask when choices exist
5. **Plan is contract** - Implementation will follow this exactly

## Leverage Hierarchy Reminder

```
Error in Research → 1000s of bad lines
Error in Plan     → 100s of bad lines  ← YOU ARE HERE
Error in Code     → ~1 bad line
```

This is the second-highest leverage point. Take time to get it right.
