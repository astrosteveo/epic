# Harness Workflow

A structured development workflow plugin for Claude Code that guides projects from idea to PR.

## Core Principles

- **One question at a time** during clarification (no overwhelming)
- **Dynamic scaling** - simple features get light process, complex features get full rigor
- **TDD by default** where applicable, with pragmatic exceptions
- **Trust but verify** - light review after each task, thorough review before shipping
- **Git as audit trail** - incremental commits document the entire journey

## Skills

| Skill | Purpose |
|-------|---------|
| `/workflow` | Main orchestrator - full flow from idea to PR |
| `/constitution` | Create/update CLAUDE.md project conventions |
| `/clarify` | Socratic discovery to produce specifications |
| `/design` | Create architecture and technical design |
| `/plan` | Break design into actionable tasks |
| `/implement` | TDD implementation (RED → GREEN → REFACTOR) |
| `/review` | Verify implementation against design/plan |
| `/commit` | Final push and GitHub PR creation |

## Workflow Phases

### 1. Constitution (Gate)
- Check if CLAUDE.md exists
- If missing: invoke `/constitution` to create it
- If exists: internalize conventions and proceed
- **Standalone**: `/constitution` can be invoked anytime to update

### 2. Clarify (Socratic Discovery)
- Ask exactly ONE question at a time
- Build understanding through natural conversation
- If scope too broad: recommend creating backlog first
- Summarize understanding and get explicit confirmation
- **Output**: `.harness/NNN-{slug}/spec.md`

### 3. Design + Plan (Dynamic)
**Simple changes** (< 3 tasks, single file, clear scope):
- Combined design+plan in conversation
- Brief architecture notes + task list
- Single confirmation point

**Complex changes** (3+ tasks, multi-file, architectural decisions):
- Full design with Mermaid diagrams
- Separate confirmation
- Detailed task breakdown
- Separate confirmation

**Output**: `.harness/NNN-{slug}/design.md` and `plan.md`

### 4. Implement (TDD)
For each task:
1. **RED**: Write failing test first
2. **GREEN**: Write minimum code to pass
3. **REFACTOR**: Improve while keeping tests green
4. **Light Review**: Quick verification against plan
5. **Commit**: Atomic commit for this task

**Pragmatic exceptions**: Skip TDD for config, docs, pure styling

### 5. Final Review
- Full design compliance check
- All tasks completed
- All tests passing
- No unintended side effects
- Security and quality checks

### 6. Commit & Push
- Verify clean worktree
- Push feature branch
- Create GitHub PR via `gh` CLI
- Report PR URL

## Artifacts

```
.harness/
├── NNN-{feature-slug}/
│   ├── spec.md         # Specification from clarify phase
│   ├── design.md       # Technical design
│   ├── plan.md         # Task breakdown with checkboxes
│   ├── state.json      # Current workflow state
│   └── issues.md       # Issues found during review (if any)
└── backlog.md          # Roadmap for large-scope projects

CLAUDE.md               # Project constitution (in project root)
```

## State Management

Triple redundancy for resumability:
1. **state.json** - Explicit phase and task tracking
2. **Artifacts** - Check which files exist to validate state
3. **Git history** - Audit trail shows progress

## Git Workflow

### New Project (no repo)
```bash
git init
git add . && git commit -m "Initial commit"
```

### Feature Start
```bash
git checkout -b feature/NNN-{slug}
```

### Incremental Commits
After each task:
```bash
git add . && git commit -m "feat(NNN): {task description}"
```

### Final Push
```bash
git push -u origin feature/NNN-{slug}
gh pr create --title "feat: {feature}" --body "..."
```

## Backlog Mode

When scope is too broad (e.g., "build a game"):
1. Acknowledge the scope
2. Create `.harness/backlog.md` with prioritized items
3. Ask user which item to start with
4. Begin normal workflow on selected item

---

## Original Concept

<details>
<summary>Initial brainstorm (preserved for reference)</summary>

### Constitution (CLAUDE.md)
- The user states conventions for the project to follow
- This can be testing frameworks, coding styles, etc
- This should include non-negotiables
- Getting this right solves 80% of the problems AI agents cause

### Specification or feature
- The user states what they want the project to do
- This can be a feature, bug fix, or refactor
- This can be vague as I want to create a game, or specific as I need to create a third-person player controller in Godot using GDScript
- The feature branch is created at the time; if no Git repo exists, one is initialized, and the main branch and feature branch are created

### Clarify (socratic method/discovery)
- Claude goes into a socratic discovery method to clarify the specification
- This is an iterative process where Claude asks exactly ONE question at a time in natural conversation to narrow down specific requirements
- If the request is too broad, Claude acknowledges that, and recommends creating a roadmap to break it down into smaller pieces
- Once Claude has the information necessary to in good faith present a design that meets the specification and quality standards expected from Claude Code, it begins to present a design, section by section, asking for confirmation for each section before moving on
- This is the final chance to clarify and remaining ambiguities should be resolved before moving on to the next step

### Design
- Claude presents the finalized design for the feature, bug fix, or refactor
- This includes architecture, data structures, algorithms, and any other relevant technical details
- Mermaid diagrams are used where applicable to illustrate complex relationships
- Claude waits for user confirmation before moving on to the next step
- The design is written to .feature/NNN-{feature-slug}/design.md
- The design is committed to Git

### Plan
- Claude breaks down the design into a detailed implementation plan, as well as a task breakdown which is loaded into the TaskTool for tracking progress
- The implementation plan includes step-by-step instructions for coding the feature, bug fix, or refactor. It is the source of truth for the implementation phase
- Claude waits for user confirmation before moving on to the next step
- The plan is written to .feature/NNN-{feature-slug}/plan.md
- The plan is committed to Git

### Implement (RED -> GREEN -> REFACTOR)
- Implementation is done in TDD style, following the implementation plan
- Each task is implemented in isolation, with tests written first to define the expected behavior
- Each subagent is prompted with an implementation prompt that is the implementation, so all the implementer has to do is write the code
- Once tests are written, the implementer writes the minimum amount of code necessary to make the tests pass
- Once tests pass, the implementer refactors the code to improve readability, maintainability, and performance, while ensuring that all tests still pass
- The implementer moves on to the next task and repeats the process until all tasks are complete
- The implementation is committed to Git incrementally as each task is completed

### Commit & Push
- One final worktree check is performed to ensure everything is committed
- The feature branch is pushed to the remote repository
- A pull request is created from the feature branch to the main branch with a summary of the changes made

### Iterate
- The process repeats for the next feature, bug fix, or refactor as specified by the user

</details>
