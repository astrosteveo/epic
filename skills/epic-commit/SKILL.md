---
name: epic-commit
description: Create documented commits from workflow artifacts using conventional commit format. Triggers when user runs /epic:commit or requests to commit changes with workflow documentation. Analyzes plan.md, state.md, and validation.md to draft comprehensive commit messages, ensures pre-commit validation, and never commits without explicit user confirmation.
allowed-tools:
  - Read
  - Glob
  - Edit
  - Bash(git:status, git:diff, git:add, git:commit, git:log, git:show)
  - AskUserQuestion
---

# Epic Commit

## Overview

Creates well-documented commits that include workflow artifacts (research, plan, progress, validation) and follow conventional commit format. This skill ensures commits are traceable to their planning phase and validation results.

## When to Use This Skill

Trigger this skill when:
- User runs `/epic:commit` command
- User requests to commit changes after completing implementation
- User wants to create a documented commit with workflow artifacts
- User asks to finalize work with a commit

## Workflow

### 1. Locate Active Workflow

Find the current workflow state:
```bash
.claude/workflows/*/state.md
```

Read `state.md` to extract:
- Feature name and slug
- Directory path (e.g., `.claude/workflows/001-add-auth`)
- Phase completion status

If no `state.md` found, inform user to run `/epic:explore` first.

### 2. Gather Workflow Artifacts

From the feature directory, read:
- `plan.md` - What was planned
- `state.md` - What was done (Current Progress section)
- `validation.md` - Test/lint/build results (if exists)

Extract:
- Feature description for commit subject
- Key changes for commit body
- Deviations noted during implementation

### 3. Analyze Git State

Run these commands in parallel:
```bash
git status --short
git diff --stat
git log --oneline -3
```

Identify:
- Modified files (staged and unstaged)
- New untracked files
- Files that should NOT be committed (credentials, .env, etc.)

### 4. Pre-Commit Validation

Verify readiness:

| Check | Requirement |
|-------|-------------|
| Implementation | All phases marked complete in state.md |
| Validation | Results show PASS status (if validation.md exists) |
| Working tree | No uncommitted changes outside scope |

**If validation failed or incomplete:**
```
Warning: Not ready to commit:
- Validation status: [PASS/FAIL]
- Implementation: [X/Y phases complete]

Run /epic:validate or /epic:implement to resolve.
```
Stop and inform user.

**If suspicious files detected:**
```
Warning: Detected potentially sensitive files:
- .env
- credentials.json

These will NOT be staged. Confirm this is correct.
```

### 5. Stage Changes

Stage all relevant changes:
```bash
git add [implementation files]
git add .claude/workflows/[NNN-slug]/
```

**Include in commit:**
- All implementation changes
- Workflow artifacts (research, plan, state, validation)

**Exclude from commit:**
- `.env`, credentials, secrets
- Build artifacts, node_modules, dist/
- Temporary files, .DS_Store

### 6. Draft Commit Message

Use the commit type table to determine the type:

| Type | When |
|------|------|
| `feat:` | New feature or capability |
| `fix:` | Bug fix |
| `refactor:` | Code restructuring without behavior change |
| `docs:` | Documentation only |
| `test:` | Test additions or modifications |
| `chore:` | Maintenance, dependencies |

Use the commit message structure from `references/commit-template.md`.

### 7. Request User Confirmation

**CRITICAL: Never commit without explicit user confirmation.**

Present to user using AskUserQuestion:

**Show:**
- Files to be committed (list)
- Proposed commit message (full text)
- Any warnings or concerns

**Ask:** "Ready to create this commit?"
- Options: "Yes, commit" / "Edit message first" / "Cancel"

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
Commit created successfully

Commit: [hash]
Branch: [branch-name]
Files changed: [count]

Artifacts committed:
- .claude/workflows/[slug]/*-research.md
- .claude/workflows/[slug]/plan.md
- .claude/workflows/[slug]/state.md
- .claude/workflows/[slug]/validation.md
```

## Commit Type Reference

| Type | Description | Example |
|------|-------------|---------|
| `feat:` | New feature or capability | `feat: add user authentication` |
| `fix:` | Bug fix | `fix: resolve login timeout issue` |
| `refactor:` | Code restructuring | `refactor: simplify auth logic` |
| `docs:` | Documentation only | `docs: update API reference` |
| `test:` | Test changes | `test: add auth integration tests` |
| `chore:` | Maintenance | `chore: update dependencies` |
| `perf:` | Performance improvement | `perf: optimize database queries` |
| `style:` | Code style/formatting | `style: apply prettier formatting` |
| `build:` | Build system changes | `build: update webpack config` |
| `ci:` | CI/CD changes | `ci: add deployment workflow` |

## Output Formats

### Success
```
Commit Phase Complete

[commit-hash] [commit-subject]

[files changed] files changed, [insertions] insertions(+), [deletions] deletions(-)

Workflow artifacts included for traceability.
```

### Blocked
```
Cannot Commit

Reason: [specific issue]
Resolution: [specific action to take]
```

## Safety Rules

1. **Never commit without user confirmation** - Always use AskUserQuestion before executing commit
2. **Never commit secrets** - Check for .env, credentials, API keys, tokens
3. **Always include artifacts** - They document the change rationale and process
4. **Follow conventional commits** - Consistent format for repository readability
5. **Reference the workflow** - Future readers understand the process used
6. **Verify completion** - Ensure implementation and validation are complete before committing

## Resources

### references/commit-template.md
Template structure for commit messages with placeholders and formatting guidance.
