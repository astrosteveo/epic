---
name: using-harness
description: |
  Meta-skill for workflow awareness and intent detection. Injected at session start.
---

# Harness Workflow

You are working in a project that uses the harness workflow: **Define → Research → Plan → Execute → Verify**.

## Workflow Overview

| Phase | Purpose | Produces |
|-------|---------|----------|
| **Define** | Establish requirements through Socratic dialogue | `requirements.md` |
| **Research** | Explore codebase and best practices | `codebase.md`, `research.md` |
| **Plan** | Collaborative design with user approval | `design.md`, `plan.md` |
| **Execute** | TDD implementation following the plan | Code + tests |
| **Verify** | Rigorous validation before completion | Passing tests + user satisfaction |

## Slash Commands

- `/define` - Start or return to Define phase
- `/research` - Start or return to Research phase
- `/plan` - Start or return to Plan phase
- `/execute` - Start execution
- `/verify` - Run verification

## Intent Detection

When the user presents a task, determine the appropriate response:

**New Task**
- Invoke the `harness:defining` skill
- Create task directory: `.harness/{nnn}-{slug}/`
- Guide through requirements gathering

**Continuing Existing Task**
- Check for active task in `.harness/`
- Read artifacts to restore context
- Confirm with user: "Last time we completed X, ready to continue with Y?"

**Simple/Trivial Task**
- Suggest lightweight mode
- "This seems straightforward. Want to skip the full workflow and just do it?"
- If accepted: quick verbal define → execute → verify

**Exploratory/Unknown Task**
- Suggest a spike
- "We don't know enough to define this yet. Want to do a quick spike to explore?"
- Create: `.harness/{nnn}-spike-{topic}/`
- Spike produces: `spike-findings.md`

## Phase Transitions

**Hybrid Approach**
- Recognize when a phase is complete
- Offer transition: "Ready to move to {next phase}?"
- User can accept, decline, or redirect
- User can always use slash commands for explicit control

**Transition Triggers**
- Define → Research: Requirements documented, user confirms
- Research → Plan: Approach approved by user
- Plan → Execute: Full plan approved
- Execute → Verify: All plan steps complete
- Verify → Done: Tests pass AND user satisfied

## Artifact Structure

```
.harness/
├── backlog.md                # Project-level deferred items
├── {nnn}-{slug-name}/        # Task directory
│   ├── requirements.md       # Vision, requirements, constraints
│   ├── codebase.md          # Codebase analysis
│   ├── research.md          # External research
│   ├── design.md            # Architecture
│   └── plan.md              # Implementation steps
└── {nnn}-spike-{topic}/     # Spike directory
    └── spike-findings.md    # Spike learnings
```

## Key Principles

- **Socratic method** - Guide through questions, don't dictate
- **Human in the loop** - User controls all decisions
- **TDD by default** - Write tests first, document exceptions
- **Git as audit trail** - Commits tell the story
- **Artifacts stay current** - Update when understanding changes
- **Don't get stuck** - Loop back when blocked, iterate

## Checking Active Context

At session start or when resuming:

1. Check for `.harness/` directories
2. Find the most recent task (highest number or most recent modification)
3. Read its artifacts to understand current state
4. Offer to continue or start fresh

## Backlog Management

Deferred items, discovered bugs, and refactoring opportunities go to `.harness/backlog.md`:

```markdown
# Backlog

## Deferred from {nnn}-{slug}
- [ ] {Item} - {Reason}

## Discovered Bugs
- [ ] {Bug description} - Found in {location}

## Refactoring Opportunities
- [ ] {Opportunity} - {Context}

## Blocked Items
- [ ] [BLOCKED by {nnn}] {Item description}
```

Periodically suggest backlog review during natural breaks.
