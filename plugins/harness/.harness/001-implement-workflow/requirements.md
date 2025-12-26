# Requirements: Implement Harness Workflow Plugin

## Vision
Implement the workflow defined in WORKFLOW.md as a functional Claude Code plugin, enabling the Define → Research → Plan → Execute → Verify workflow with proper artifact management.

## Functional Requirements

### Core Phases as Slash Commands
- `/define` - Start or return to Define phase
- `/research` - Start or return to Research phase
- `/plan` - Start or return to Plan phase
- `/execute` - Start execution
- `/verify` - Run verification

### Artifact Management
- Create `.harness/{nnn}-{slug-name}/` directories for each task
- Generate and maintain:
  - `requirements.md`
  - `codebase.md`
  - `research.md`
  - `design.md`
  - `plan.md`
- Project-level `backlog.md` for deferred items

### Workflow Behaviors
- Socratic method for user interaction
- Phase transition suggestions (hybrid: Claude offers, user controls)
- Loop-back capability when requirements/plans change
- TDD by default during Execute
- Rigorous Verify phase (tests + user satisfaction)

### Edge Cases
- Lightweight mode for trivial tasks
- Spike support for exploratory work
- Context switching between tasks
- Failure recovery and rollback guidance

## Constraints

- Must work within Claude Code plugin system (commands, skills, hooks)
- Should integrate with existing git workflows
- Artifacts should be human-readable markdown
- No external dependencies beyond Claude Code

## Success Criteria

1. All 5 slash commands functional and invoke correct phase behavior
2. Artifacts created in proper directory structure
3. Phase transitions work (both suggested and explicit)
4. Backlog management works
5. Workflow feels natural and not overly ceremonial
6. Lightweight mode available for simple tasks
