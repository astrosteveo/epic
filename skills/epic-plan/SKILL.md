---
name: epic-plan
description: Create phased implementation plans from research artifacts. Use after /epic:explore completes to design atomic, verifiable implementation phases. Triggers on /epic:plan or when user wants to create an implementation plan, design phases, or prepare for coding based on completed research.
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Task
---

# Epic Plan

Planning phase of the Explore-Plan-Implement workflow. Create detailed, phased implementation plans based solely on research findings.

## Workflow

```
1. Locate active workflow: .claude/workflows/*/state.md
2. Verify Explore phase is complete
3. Load research artifacts (codebase-research.md, docs-research.md)
4. Design atomic, verifiable phases
5. Write plan to plan.md
6. Update state.md
7. Present summary for human review
```

## Prerequisites

- Explore phase must be complete
- Research artifacts must exist in workflow directory

If prerequisites not met:
```
⚠️ Cannot create plan - Explore phase incomplete
Run `/epic:explore [feature]` first.
```

## Phase Design Principles

Each phase must be:
- **Atomic** - Independently verifiable
- **Sequential** - Foundation for later phases
- **Right-sized** - Completable in one focused session

## Phase Structure

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
- [ ] `npm run lint` - passes
- [ ] `npm run typecheck` - passes

**Manual:**
- [ ] [Specific check requiring human verification]
```

## Plan Quality Checklist

| Check | Requirement |
|-------|-------------|
| Research-based | All decisions reference research findings |
| Specific | File paths include line numbers |
| Verifiable | Every phase has automated + manual checks |
| Complete | Rollback plan and success criteria defined |
| Right-sized | No phase too large for one session |

## Required Plan Sections

1. **Goal** - Clear statement of outcome
2. **Approach Summary** - Why this approach (from research)
3. **Phases** - Detailed phase definitions
4. **Rollback Plan** - How to undo if needed
5. **Success Criteria** - Measurable completion criteria
6. **Open Questions** - Decisions needing human input

See `references/plan-template.md` for full structure.

## Output Format

```
✓ Plan Phase Complete

Feature: [description]
Phases: [N] phases defined
Artifact: .claude/workflows/[slug]/plan.md

Phase Summary:
1. [Phase 1] - [files affected]
2. [Phase 2] - [files affected]

Next: Review plan, then run /epic:implement
```

## Leverage Hierarchy

```
Error in Research → 1000s of bad lines
Error in Plan     → 100s of bad lines  ← THIS PHASE
Error in Code     → ~1 bad line
```

This is the second-highest leverage point. Human review here prevents cascading errors.

## Quality Rules

1. **Research is truth** - Base ALL decisions on research, never training data
2. **Specificity required** - Vague plans create vague implementations
3. **Verification mandatory** - Every phase must have testable checks
4. **Human decisions flagged** - Don't assume; ask when choices exist
5. **Plan is contract** - Implementation follows this exactly

## References

- `references/plan-template.md` - Full implementation plan template
