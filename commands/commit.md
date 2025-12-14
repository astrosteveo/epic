---
description: Create documented commit from workflow artifacts
argument-hint: [--amend]
allowed-tools:
  - Read
  - Glob
  - Edit
  - Bash(git:status, git:diff, git:add, git:commit, git:log, git:show)
  - AskUserQuestion
---

# Commit Phase

Execute the **Commit** phase of the Frequent Intentional Compaction workflow.

Create a well-documented commit that includes workflow artifacts and follows conventional commit format.

## Process

### 1. Locate Active Feature

Find the current workflow state:
```
.claude/workflows/*/state.md
```

Read `state.md` to get:
- Feature name and slug
- Directory path (e.g., `.claude/workflows/001-add-auth`)
- Phase completion status

If no `state.md` found, inform user to run `/explore` first.

### 2. Gather Workflow Artifacts

From the feature directory, read:
- `plans/implementation-plan.md` - What was planned
- `implementation/progress.md` - What was done
- `validation/results.md` - Test/lint/build results

Extract:
- Feature description for commit subject
- Key changes for commit body
- Any deviations noted during implementation

### 3. Analyze Git State

Run these commands to understand current changes:
```bash
git status --short
git diff --stat
git log --oneline -3
```

Identify:
- Modified files (staged and unstaged)
- New untracked files
- Files that should NOT be committed (credentials, .env, node_modules, etc.)

### 4. Pre-Commit Validation

Verify readiness by checking:

| Check | Requirement |
|-------|-------------|
| Implementation | All phases marked complete in progress.md |
| Validation | Results show PASS status |
| Working tree | No uncommitted changes outside scope |

**If validation failed or incomplete:**
```
⚠️ Not ready to commit:
- Validation status: [PASS/FAIL]
- Implementation: [X/Y phases complete]

Run `/validate` or `/implement` to resolve.
```
Stop and inform user.

**If suspicious files detected:**
```
⚠️ Warning: Detected potentially sensitive files:
- .env
- credentials.json
- [other files]

These will NOT be staged. Confirm this is correct.
```

### 5. Stage Changes

Stage all relevant changes:
```bash
git add [implementation files]
git add .claude/workflows/[NNN-slug]/  # Include artifacts
```

**Include in commit:**
- All implementation changes
- Workflow artifacts (research, plan, progress, validation)

**Exclude from commit:**
- `.env`, credentials, secrets
- Build artifacts, node_modules
- Temporary files

### 6. Draft Commit Message

Determine commit type from the plan:
| Type | When |
|------|------|
| `feat:` | New feature or capability |
| `fix:` | Bug fix |
| `refactor:` | Code restructuring without behavior change |
| `docs:` | Documentation only |
| `test:` | Test additions or modifications |
| `chore:` | Maintenance, dependencies |

Structure the message:
```
<type>: <concise description from feature name>

<Summary of key changes from progress.md>

Artifacts:
- Research: .claude/workflows/[slug]/research/
- Plan: .claude/workflows/[slug]/plans/implementation-plan.md
- Validation: .claude/workflows/[slug]/validation/results.md

Generated with Claude Code using explore-plan-implement workflow
```

### 7. Request User Confirmation

Present to user using AskUserQuestion:

**Show:**
- Files to be committed (list)
- Proposed commit message (full text)
- Any warnings or concerns

**Ask:** "Ready to create this commit?"
- Options: "Yes, commit" / "Edit message first" / "Cancel"

**NEVER commit without explicit user confirmation.**

### 8. Execute Commit

After confirmation:
```bash
git add [files]
git commit -m "[message]"
```

If `--amend` argument provided:
```bash
git commit --amend -m "[message]"
```

### 9. Update State and Report

Update `state.md`:
- Set Commit status to "complete"
- Add commit hash reference

Report to user:
```
✓ Commit created successfully

Commit: [hash]
Branch: [branch-name]
Files changed: [count]

Artifacts committed:
- .claude/workflows/[slug]/research/
- .claude/workflows/[slug]/plans/
- .claude/workflows/[slug]/implementation/
- .claude/workflows/[slug]/validation/
```

## Output Format

### Success
```
✓ Commit Phase Complete

[commit-hash] [commit-subject]

[files changed] files changed, [insertions] insertions(+), [deletions] deletions(-)

Workflow artifacts included for traceability.
```

### Blocked
```
⚠️ Cannot Commit

Reason: [specific issue]
Resolution: [specific action to take]
```

## Safety Rules

1. **Never commit without user confirmation** - Always use AskUserQuestion
2. **Never commit secrets** - Check for .env, credentials, API keys
3. **Always include artifacts** - They document the change rationale
4. **Follow conventional commits** - Consistent format for readability
5. **Reference the workflow** - Future readers understand the process used
