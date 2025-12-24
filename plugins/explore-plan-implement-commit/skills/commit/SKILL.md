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
- End of the explore → research → design → plan → implement → commit flow

## Global Rule: Asking Questions

**ONE question at a time. Always.**

Use the AskUserQuestion tool pattern for all questions:

1. **Use multiple choice when possible** (2-4 options)
2. **Lead with your recommendation** - mark it clearly with "(Recommended)"
3. **Always include "Other"** - user can provide free text
4. **Single-select for mutually exclusive choices**

**Format:**

```
[Brief context for the question]

**A) [Option Name]** (Recommended)
   [1-2 sentence description of what this means]

**B) [Option Name]**
   [1-2 sentence description]

**C) [Option Name]**
   [1-2 sentence description]

**D) Other**
   [Tell me what you're thinking]
```

**Wait for response before asking next question.**

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
Checking status before finalizing:

**Uncommitted changes:** [Yes/No - list if any]
**Tests:** [All passing / X failing]
**Lint/Build:** [Clean / Issues found]

[If issues:]
We have some items to address before finalizing.

**A) Fix the issues** (Recommended)
   I'll address [issue] before proceeding

**B) Proceed anyway**
   Continue despite the issues

**C) Review what's wrong**
   Let's look at the problems first

**D) Other**
   Different approach in mind

[If clean:]
Everything looks good. Ready to finalize?

**A) Yes, finalize** (Recommended)
   Update artifacts and wrap up

**B) Run more checks**
   Additional verification before finalizing

**C) Review changes first**
   Let's look at what we're committing

**D) Other**
   Something else in mind
```

[Wait for confirmation]

### Phase 2: Handle Uncommitted Work

**Goal:** Commit any remaining changes.

If uncommitted changes exist:

```
I see uncommitted changes in:
- [file 1]
- [file 2]

Suggested commit message:

[type]: [description]

- [Change 1]
- [Change 2]

How should we handle these?

**A) Commit with this message** (Recommended)
   Use the suggested commit message

**B) Modify the message**
   I'll provide a different commit message

**C) Don't commit these**
   Leave these changes uncommitted

**D) Other**
   Different approach in mind
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

- [codebase.md](./codebase.md) - Codebase analysis with file:line references
- [research.md](./research.md) - Validated best practices and external research
- [design.md](./design.md) - Architecture and technical design
- [contracts.md](./contracts.md) - API contracts and interfaces (if created)
- [plan.md](./plan.md) - Implementation plan with task templates
- [issues.md](./issues.md) - Issues discovered during implementation (if any)

## Changes

### Files Created
- `path/to/file` - [purpose]

### Files Modified
- `path/to/file` - [what changed]

## Commits

[List of commits made during implementation]

## Issues

**Resolved:** [count]
**Deferred:** [count] (see backlog)
```

### Phase 4: Final Summary

**Goal:** Give the user a clear wrap-up.

```
Feature complete!

**[Feature Name]**

**What we built:**
[2-3 sentence summary]

**Key files:**
- [Most important files touched]

**Commits:** [Count] commits
**Tests:** All passing
**Issues:** [Count] resolved, [Count] deferred to backlog

**Workflow artifacts saved to:** `.workflow/NNN-feature-slug/`
```

### Phase 5: Next Steps

**Goal:** Offer paths forward.

```
What would you like to do next?

**A) Create a PR** (Recommended)
   I'll draft the PR description based on our workflow artifacts

**B) Start another feature**
   Ready to explore something new

**C) Done for now**
   The work is committed and ready

**D) Other**
   Something else in mind
```

**If PR requested:**
- Use workflow artifacts to draft description
- Include summary from research, design decisions, implementation highlights
- Follow repo's PR template if one exists

**If new feature:**
- Transition back to `explore` skill

## Key Principles

- **ONE question at a time** - Never batch questions
- **Multiple choice first** - Easier than open-ended
- **Always include "Other"** - User can provide free text
- **Lead with recommendation** - Mark it clearly with "(Recommended)"
- **Verify before finalizing** - Check tests, lint, uncommitted work
- **Clean commits** - Good messages, atomic changes
- **Document completion** - Update workflow artifacts
- **Offer next steps** - Don't leave user hanging

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
- Ask multiple questions at once
- Present options without a recommendation
- Skip the "Other" option
- Commit with failing tests
- Skip the status check
- Force push without explicit request
- Leave uncommitted changes without addressing

**Always:**
- One question at a time
- Use multiple choice format
- Include your recommendation
- Include "Other" for free text
- Wait for response before next question
- Verify clean state before finalizing
- Update workflow artifacts
- Provide clear summary
- Offer concrete next steps
- Let user decide what's next
