---
name: workflow
description: "Use when user wants to build a feature, fix a bug, or refactor code. Orchestrates the full development flow from idea to PR."
---

# Workflow

The main orchestrator for structured development. Guides work from initial idea through to merged PR.

## Intent Detection

| User Says | Action |
|-----------|--------|
| "I want to build...", "Add feature...", "Create..." | New feature → Start at Constitution gate |
| "Fix bug...", "This isn't working...", "There's an issue..." | Bug fix → Start at Constitution gate |
| "Refactor...", "Clean up...", "Improve..." | Refactor → Start at Constitution gate |
| "Resume...", "Continue...", "Pick up where..." | Resume → Check state and artifacts |
| Feature number (e.g., "001", "work on 002") | Resume specific feature |

## Phases

### 1. Constitution Gate
Check if CLAUDE.md exists in project root.
- **If missing**: Invoke `/constitution` skill to create it before proceeding
- **If exists**: Read it, internalize the conventions, proceed to Clarify

### 2. Clarify (Socratic Discovery)
Invoke `/clarify` skill to:
- Ask ONE question at a time to narrow down requirements
- Build understanding iteratively through natural conversation
- If scope is too broad, recommend creating a backlog first
- Summarize understanding and get explicit confirmation before proceeding

**Output**: `.harness/NNN-{slug}/spec.md`

### 3. Design + Plan (Dynamic)
Assess complexity:

**Simple changes** (single file, clear scope, < 3 tasks):
- Combined design+plan in conversation
- Brief architecture notes + task list
- Single confirmation point

**Complex changes** (multi-file, architectural decisions, 3+ tasks):
- Invoke `/design` skill for full architecture
- Wait for confirmation
- Invoke `/plan` skill for detailed task breakdown
- Wait for confirmation

**Output**: `.harness/NNN-{slug}/design.md` and `.harness/NNN-{slug}/plan.md`

### 4. Implement (TDD)
Invoke `/implement` skill for each task:
- RED: Write failing test first (where applicable)
- GREEN: Write minimum code to pass
- REFACTOR: Improve without breaking tests
- Light verification after each task (invoke `/review` with `--light` flag)
- Commit after each completed task

**Pragmatic exceptions**: Skip TDD for config files, documentation, UI-only changes where testing isn't practical.

### 5. Final Review
Invoke `/review` skill for thorough verification:
- Full implementation matches design
- All tasks from plan completed
- All tests passing
- Code quality checks
- No unintended side effects

### 6. Commit & Push
Invoke `/commit` skill:
- Verify clean worktree
- Push feature branch to origin
- Create PR via `gh` CLI
- Provide PR URL to user

## State Management

Maintain state in `.harness/NNN-{slug}/state.json`:
```json
{
  "feature": "feature-slug",
  "number": 1,
  "phase": "implement",
  "currentTask": 3,
  "totalTasks": 7,
  "created": "2025-01-15T10:00:00Z",
  "updated": "2025-01-15T14:30:00Z"
}
```

## Resume Logic

When resuming, check in order:
1. Read `state.json` for explicit phase
2. Check artifacts to validate state:
   - Has `plan.md` with unchecked tasks? → Resume at Implement
   - Has `design.md` but no `plan.md`? → Resume at Plan
   - Has `spec.md` but no `design.md`? → Resume at Design
   - Has nothing? → Start fresh at Clarify
3. Cross-reference with Git history for audit trail

## Git Workflow

### New Project (no Git repo)
```bash
git init
git add .
git commit -m "Initial commit"
# main branch now exists
```

### Feature Start
```bash
git checkout -b feature/NNN-{slug}
```

### Incremental Commits
After each task:
```bash
git add .
git commit -m "feat(NNN): {task description}"
```

### Final Push
```bash
git push -u origin feature/NNN-{slug}
gh pr create --title "feat: {feature}" --body "..."
```

## Feature Numbering

- Check `.harness/` for existing feature directories
- Next feature number = highest existing + 1
- Format: three digits, zero-padded (001, 002, ... 999)

## Backlog Mode

When scope is too broad:
1. Acknowledge the scope is large
2. Create `.harness/backlog.md` with prioritized items
3. Ask user which item to start with
4. Begin normal workflow on selected item
