---
name: workflow
description: Use when the user wants to build a feature, implement functionality, fix a bug, create something new, or do any development work. Handles the complete workflow from brainstorming through implementation with research, design, planning, and quality gates. Invoke this skill for requests like "I want to add...", "Build me a...", "Create a...", "Implement...", "Fix...".
---

# Workflow

## Overview

The main entry point for the plugin. Handles intent detection, phase progression, and orchestrates the three subagents.

## Intent Detection

### Listen for intent, not commands

| User says | Plugin understands |
|-----------|-------------------|
| "I wanna make a..." | New feature → maybe brainstorm first, then Explore |
| "This isn't working..." | Bug fix → start at Explore (skip brainstorm) |
| "Resume 001" | Resume → check artifacts, pick up where left off |
| "Add dark mode" | Clear request → start at Explore |

### Brainstorm Trigger

If request is vague or creative:
- Use Socratic method
- Broad questions → narrow down
- Continue until clear direction emerges
- Then proceed to Explore

---

## The Four Stages

### EXPLORE

| Step | What | Output | Commit |
|------|------|--------|--------|
| Map codebase | Discoverer documents existing code | `codebase.md` | ✓ |
| Research | Discoverer fetches best practices | `research.md` | ✓ |

### PLAN

| Step | What | Output | Commit |
|------|------|--------|--------|
| Design | Architecture decisions, Mermaid diagrams | `design.md` | ✓ |
| Tasks | Break into atomic, ordered tasks | `plan.md` | ✓ |

### CODE

| Step | What | Output | Commit |
|------|------|--------|--------|
| Per task | Coder implements, Reviewer validates | code + tests | ✓ each |
| Update | Mark task complete with hash | `plan.md` | — |

### COMMIT

| Step | What | Output | Commit |
|------|------|--------|--------|
| Summarize | Document what was built | summary | ✓ |
| PR | Create PR if on feature branch | — | — |

---

## Artifact Management

### Directory Structure

```
.workflow/
├── 001-user-authentication/
│   ├── codebase.md
│   ├── research.md
│   ├── design.md
│   ├── plan.md
│   └── issues.md
├── 002-dark-mode/
│   └── ...
└── backlog.md
```

### Resume Logic

Check which artifacts exist:
- Has `plan.md` with unchecked tasks? → Resume at Code
- Has `design.md` but no `plan.md`? → Resume at Plan (tasks)
- Has `codebase.md` but no `research.md`? → Resume at Explore (research)

---

## Implementation Modes

### Batched Mode

```
Task 1 → Reviewer ─┐
Task 2 → Reviewer ─┼→ User checkpoint
Task 3 → Reviewer ─┘
...
```

User reviews every 2-3 tasks.

### Autonomous Mode

```
Task 1 → Reviewer → Task 2 → Reviewer → ... → Done → User review
```

No pauses until complete.

**Both modes:** Reviewer runs after every task. Quality gates are non-negotiable.

---

## Design Phase

When creating `design.md`:

1. Synthesize findings from `codebase.md` and `research.md`
2. Make architectural decisions
3. Use Mermaid diagrams where helpful
4. Document key decisions with rationale

### Mermaid Diagram Types

| Type | Use for |
|------|---------|
| Flowchart | Process flows, decision logic |
| Sequence | Component interactions |
| Class | Data models, interfaces |
| ER | Database schema |
| State | Lifecycle, state machines |

---

## Plan Phase

When creating `plan.md`:

1. Break design into atomic tasks
2. Order by dependencies
3. Each task has clear deliverables
4. Use checkboxes for progress tracking

### Task Format

```markdown
- [ ] Task 1: Set up auth routes
  - Create `src/routes/auth.ts`
  - Add login/logout endpoints
  - Expected: routes respond to requests

- [ ] Task 2: Add validation
  - Create `src/validation/auth.ts`
  - Validate email format, password strength
  - Expected: invalid inputs rejected
```

### Progress Tracking

Update as tasks complete:
```markdown
- [x] Task 1: Set up auth routes *(committed: abc1234)*
- [x] Task 2: Add validation *(committed: def5678)*
- [ ] Task 3: Create login form
```

---

## Commit Conventions

### Format

```
<stage>: <what was done>
```

### By Stage

```
explore: document codebase for user-auth
explore: research JWT best practices
plan: design authentication architecture
plan: create implementation tasks
code: implement login route
code: add session middleware
commit: finalize user-auth feature
```

---

## Subagent Deployment

| Subagent | When | For |
|----------|------|-----|
| Discoverer | Explore phase | Codebase mapping, research |
| Coder | Code phase | Task implementation |
| Reviewer | After each task | Quality validation |

The workflow skill coordinates; subagents execute.
