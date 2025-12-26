---
name: commit
description: "Use for final push and PR creation. Verifies clean worktree, pushes branch, creates GitHub PR."
---

# Commit

Finalizes the feature by ensuring everything is committed, pushing to remote, and creating a pull request.

## Prerequisites

- Thorough review has passed (`/review`)
- All tasks completed
- All tests passing
- On feature branch

## Process

### 1. Verify Clean Worktree

```bash
git status
```

Expected: Nothing to commit, working tree clean

If uncommitted changes exist:
- Review what's uncommitted
- If legitimate, commit with appropriate message
- If accidental, discuss with user

### 2. Verify Branch State

```bash
# Check current branch
git branch --show-current

# Should be: feature/NNN-{slug}
```

If on wrong branch, alert user.

### 3. Verify All Tests Pass

```bash
# Run full test suite one more time
npm test  # or appropriate test command
```

If tests fail, do not proceed. Fix first.

### 4. Push to Remote

```bash
# Push branch to origin
git push -u origin feature/NNN-{slug}
```

If no remote exists, inform user:
"No remote repository configured. Would you like me to help set one up, or would you prefer to push manually later?"

### 5. Create Pull Request

Using GitHub CLI:

```bash
gh pr create \
  --title "feat: {feature title}" \
  --body "$(cat << 'EOF'
## Summary

{Brief description of what this PR does}

## Changes

{List of key changes}

## Testing

{How this was tested}

## Checklist

- [x] Tests passing
- [x] Code follows project conventions
- [x] Design reviewed and approved
- [x] Implementation matches plan

## Related

- Specification: `.harness/NNN-{slug}/spec.md`
- Design: `.harness/NNN-{slug}/design.md`
- Plan: `.harness/NNN-{slug}/plan.md`
EOF
)"
```

### 6. Report Success

"Feature complete!

**Branch**: `feature/NNN-{slug}`
**PR**: {PR URL}

The PR is ready for review. All artifacts are in `.harness/NNN-{slug}/`:
- `spec.md` - Original specification
- `design.md` - Technical design
- `plan.md` - Implementation plan (all tasks complete)
- `state.json` - Workflow state

What would you like to work on next?"

## Update State

Mark feature as complete in `state.json`:

```json
{
  "feature": "feature-slug",
  "number": 1,
  "phase": "complete",
  "currentTask": 7,
  "totalTasks": 7,
  "created": "2025-01-15T10:00:00Z",
  "updated": "2025-01-15T17:00:00Z",
  "completed": "2025-01-15T17:00:00Z",
  "prUrl": "https://github.com/user/repo/pull/123"
}
```

## Edge Cases

### No GitHub Remote
```
Remote 'origin' doesn't appear to be a GitHub repository.
Would you like to:
1. Push to origin anyway (manual PR creation)
2. Add a GitHub remote
3. Skip push for now
```

### `gh` CLI Not Installed
```
GitHub CLI (gh) is not installed or not authenticated.
Branch has been pushed to origin.
Please create the PR manually: https://github.com/user/repo/compare/feature/NNN-{slug}
```

### Merge Conflicts Possible
```bash
# Check if branch is behind main
git fetch origin
git log HEAD..origin/main --oneline
```

If behind:
"The main branch has new commits. Would you like to:
1. Rebase on main before creating PR
2. Create PR anyway (merge conflicts may need resolution)"

### PR Already Exists
```bash
gh pr list --head feature/NNN-{slug}
```

If PR exists:
"A PR already exists for this branch: {URL}
Would you like me to update it or view its status?"

## Commit Message Conventions

Follow conventional commits:
- `feat(NNN): {description}` - New feature
- `fix(NNN): {description}` - Bug fix
- `refactor(NNN): {description}` - Refactoring
- `docs(NNN): {description}` - Documentation
- `test(NNN): {description}` - Tests only

NNN is the feature number (e.g., 001).

## PR Template

The PR body should include:
1. **Summary**: What this does (from spec)
2. **Changes**: Key changes made (from plan)
3. **Testing**: How it was tested
4. **Checklist**: Verification items
5. **Related**: Links to workflow artifacts

## After PR Creation

Remind user of next steps:
- PR review process
- How to address review comments
- How to merge when approved

"Let me know if you'd like to:
- Start a new feature (`/workflow`)
- View the backlog
- Work on something else"
