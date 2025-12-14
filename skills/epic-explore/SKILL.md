---
name: epic-explore
description: Launch research agents to understand a codebase before planning changes. Use when starting a new feature, fixing bugs, or refactoring. Creates workflow artifacts in `.claude/workflows/NNN-slug/`. Triggers on /epic:explore or when user wants to explore/understand codebase structure, patterns, or implementation details before making changes.
---

# Epic Explore

Research phase of the Explore-Plan-Implement workflow. Launch background agents to document codebase structure and (optionally) external documentation.

## Workflow

```
1. Parse feature description
2. Determine research scope (codebase only vs. codebase + docs)
3. Create workflow directory: .claude/workflows/NNN-slug/
4. Launch agent(s) in background
5. Wait for completion with TaskOutput
6. Update state.md
7. Present summary
```

## Research Scope Decision

**Launch BOTH agents when feature:**
- Mentions library/framework/API by name
- Involves security, auth, or authorization
- Requires new dependency
- Mentions "upgrade", "migrate", or versions
- Asks for best practices
- Involves unfamiliar technology

**Launch ONLY codebase-explorer when:**
- Bug fix in existing code
- Refactoring using existing patterns
- Internal functionality, no external deps
- User says "no external research"

**If unclear:** Ask user to choose scope.

## Agent Launch Pattern

Always use `run_in_background: true`. Launch parallel when both needed.

### Codebase Explorer (always)

```
Task tool:
  subagent_type: epic:codebase-explorer
  run_in_background: true
  prompt: |
    Explore codebase for: [feature]
    Output to: .claude/workflows/[NNN-slug]/codebase-research.md
    Template: references/codebase-template.md
```

### Docs Researcher (conditional)

```
Task tool:
  subagent_type: epic:docs-researcher
  run_in_background: true
  prompt: |
    Research docs for: [feature]
    Output to: .claude/workflows/[NNN-slug]/docs-research.md
    Template: references/docs-template.md
```

## State File

Create `.claude/workflows/[NNN-slug]/state.md` after launching agents. See `references/state-template.md` for structure.

Track:
- Feature name and slug
- Current phase: explore
- Research scope: codebase only | full
- Agent task IDs and status

## Completion

1. Call `TaskOutput` with `block: true` for each agent
2. Verify artifacts exist
3. Update state.md: Explore status → complete
4. Present summary with file counts and next step

## Output Format

```
✓ Explore Phase Complete

Feature: [description]
Directory: .claude/workflows/[NNN-slug]/
Research Scope: [codebase only | full]

Research Artifacts:
- codebase-research.md ([X] files documented)
- docs-research.md ([Y] sources) ← if applicable

Next: Review artifacts, then run /epic:plan
```

## References

- `references/codebase-template.md` - Output template for codebase-explorer
- `references/docs-template.md` - Output template for docs-researcher
- `references/state-template.md` - Workflow state tracking format
