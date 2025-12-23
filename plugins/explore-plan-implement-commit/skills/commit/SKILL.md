---
name: commit
description: Use after implement to finalize the work. Creates summary commit, updates workflow artifacts, and offers next steps (PR, more features, etc).
---

# Commit

## Overview

Finalize the work. This skill wraps up the implementation by ensuring everything is committed, updating workflow artifacts with completion status, and offering next steps.

**Input:** Completed implementation from `implement` skill
**Output:** Clean git history, updated workflow artifacts, ready for next steps

**Announce at start:** "I'm using the commit skill to finalize this work."

## When to Use

- After `implement` skill completes
- User says "commit", "wrap up", "finalize", "we're done"
- Invoked directly via `/commit`
- End of the explore → design → plan → implement → commit flow

## The Process

### Phase 1: Status Check

**Goal:** Ensure everything is in order.

```bash
# Check for uncommitted changes
git status

# Check test status
[run test command]

# Check for any issues
[run lint/build if applicable]
```

Report:
```
"Checking status before finalizing:

**Uncommitted changes:** [Yes/No - list if any]
**Tests:** [All passing / X failing]
**Lint/Build:** [Clean / Issues found]

[If issues:]
We have some items to address before finalizing. Should I fix [issue]?

[If clean:]
Everything looks good. Ready to finalize?"
```

[Wait for confirmation]

### Phase 2: Handle Uncommitted Work

**Goal:** Commit any remaining changes.

If uncommitted changes exist:

```
"I see uncommitted changes in:
- [file 1]
- [file 2]

These should be committed. Suggested commit message:

[type]: [description]

- [Change 1]
- [Change 2]

Should I commit these?"
```

[Wait for approval, then commit]

### Phase 3: Update Workflow Artifacts

**Goal:** Mark the workflow as complete.

Update `.workflow/NNN-feature-slug/plan.md`:
- Add completion date
- Mark status as "Complete"

Create `.workflow/NNN-feature-slug/COMPLETE.md`:

```markdown
# [Feature Name] - Complete

**Completed:** YYYY-MM-DD
**Duration:** [If trackable from dates in artifacts]

## Summary

[Brief description of what was built]

## Artifacts

- [research.md](./research.md) - Research and codebase analysis
- [design.md](./design.md) - Architecture and technical design
- [plan.md](./plan.md) - Implementation plan

## Changes

### Files Created
- `path/to/file` - [purpose]

### Files Modified
- `path/to/file` - [what changed]

## Commits

[List of commits made during implementation]
```

### Phase 4: Final Summary

**Goal:** Give the user a clear wrap-up.

```
"Feature complete!

**[Feature Name]**

**What we built:**
[2-3 sentence summary]

**Key files:**
- [Most important files touched]

**Commits:** [Count] commits
**Tests:** All passing

**Workflow artifacts saved to:** `.workflow/NNN-feature-slug/`

What's next?"
```

### Phase 5: Next Steps

**Goal:** Offer paths forward.

```
"Options from here:

**A) Create a PR**
I can help draft the PR description based on our workflow artifacts.

**B) Start another feature**
Ready to explore something new?

**C) Done for now**
The work is committed and ready.

Which would you like?"
```

**If PR requested:**
- Use workflow artifacts to draft description
- Include summary from research, design decisions, implementation highlights
- Follow repo's PR template if one exists

**If new feature:**
- Transition back to `explore` skill

## Key Principles

- **Verify before finalizing** - Check tests, lint, uncommitted work
- **Clean commits** - Good messages, atomic changes
- **Document completion** - Update workflow artifacts
- **Offer next steps** - Don't leave user hanging
- **One question at a time** - Even at the end

## Commit Message Format

Follow conventional commits:

```
type(scope): description

- Detail 1
- Detail 2

Refs: #issue-number (if applicable)
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code restructuring
- `test`: Test additions/changes
- `docs`: Documentation
- `chore`: Maintenance

## Red Flags

**Never:**
- Commit with failing tests
- Skip the status check
- Force push without explicit request
- Leave uncommitted changes without addressing
- Ask multiple questions at once

**Always:**
- Verify clean state before finalizing
- Update workflow artifacts
- Provide clear summary
- Offer concrete next steps
- Let user decide what's next
