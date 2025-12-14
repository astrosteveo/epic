# Command Patterns Reference

This reference covers common patterns for structuring Claude Code commands.

## Pattern Categories

### 1. Analysis Commands

Commands that examine code/data and report findings.

**Structure**:
```markdown
---
description: [What is being analyzed]
argument-hint: [target]
allowed-tools:
  - Read
  - Glob
  - Grep
---

Analyze [target] for [criteria].

## Analysis Criteria
1. [Criterion 1]
2. [Criterion 2]

## Output Format
[Specify table, list, or prose format]
[Include severity levels if applicable]
```

**Example Use Cases**:
- Security vulnerability scanning
- Code quality review
- Dependency analysis
- Performance profiling
- Test coverage assessment

### 2. Generation Commands

Commands that create new files or content.

**Structure**:
```markdown
---
description: Generate [thing]
argument-hint: [name] [type]
allowed-tools:
  - Write
  - Read
---

Generate a new $2 named $1.

## Template Selection
[How to choose the right template]

## File Location
[Where to create the file]

## Content Requirements
[What must be included]

## Post-Generation
[Any follow-up steps]
```

**Example Use Cases**:
- Component scaffolding
- Test file generation
- Documentation stubs
- Configuration files
- Migration scripts

### 3. Workflow Commands

Commands that orchestrate multi-step processes.

**Structure**:
```markdown
---
description: [Workflow name]
argument-hint: [key-parameter]
allowed-tools:
  - Read
  - Write
  - Bash([specific commands])
---

Execute the [workflow name] workflow.

## Pre-Conditions
- [ ] Condition 1
- [ ] Condition 2

## Step 1: [Name]
[Instructions]

## Step 2: [Name]
[Instructions]

## Verification
[How to verify success]

## Rollback
[How to undo if needed]
```

**Example Use Cases**:
- Deployment pipelines
- Release processes
- Database migrations
- Environment setup
- CI/CD triggers

### 4. Query Commands

Commands that retrieve and format information.

**Structure**:
```markdown
---
description: Show [information]
allowed-tools:
  - Bash([specific query commands])
  - Read
---

Retrieve and display [information].

## Data Sources
[Where to get the data]

## Formatting
[How to present it]

## Filters
[Any filtering criteria]
```

**Example Use Cases**:
- Git history summaries
- Environment status
- Dependency listings
- Configuration display
- Log analysis

### 5. Transformation Commands

Commands that modify existing content.

**Structure**:
```markdown
---
description: Transform [thing]
argument-hint: [target] [options]
allowed-tools:
  - Read
  - Edit
  - Write
---

Transform $1 according to [rules].

## Transformation Rules
1. [Rule 1]
2. [Rule 2]

## Validation
[How to verify transformation was correct]

## Backup
[Whether/how to preserve original]
```

**Example Use Cases**:
- Code formatting
- Refactoring operations
- Configuration updates
- Data migrations
- Bulk renames

## Composition Patterns

### Chained Commands

Commands that call other commands or suggest next steps:

```markdown
After completing this analysis, the user may want to run:
- `/fix-issues` to auto-fix detected problems
- `/generate-report` to create a detailed report
```

### Conditional Branching

Commands that behave differently based on context:

```markdown
## Detect Environment

First, determine the project type:
- If `package.json` exists → Node.js workflow
- If `Cargo.toml` exists → Rust workflow
- If `go.mod` exists → Go workflow

Then apply the appropriate [action] for that environment.
```

### Interactive Commands

Commands that gather input during execution:

```markdown
If the required information is not provided as arguments,
use AskUserQuestion to gather:

1. Target environment (staging/production)
2. Deployment strategy (rolling/blue-green)
3. Notification preferences
```

### Agent Integration

Commands that leverage specialized agents:

```markdown
For complex analysis, invoke the appropriate agent:

Use the `codebase-explorer` agent to understand the system before making changes.
Use the `plan-validator` agent to verify the approach before implementation.
```

## State Management

### Stateless Commands

Most commands should be stateless—they do their job and complete.

### Stateful Workflows

For multi-phase workflows, use artifact files:

```markdown
## State File

Write current progress to `.claude/workflow-state.md`:
- Current step
- Completed items
- Pending items
- Any blockers

This allows resuming the workflow in a fresh session.
```

## Error Handling

### Graceful Failures

```markdown
## Error Handling

If [operation] fails:
1. Report the specific error
2. Suggest potential causes
3. Provide recovery options
4. Do NOT proceed with subsequent steps
```

### Validation Before Action

```markdown
## Pre-flight Checks

Before executing, verify:
- [ ] Required files exist
- [ ] Permissions are sufficient
- [ ] No conflicting operations in progress

If any check fails, report the issue and stop.
```

## Output Patterns

### Structured Tables

```markdown
Present findings as a table:
| File | Issue | Severity | Line |
|------|-------|----------|------|
```

### Progress Indicators

```markdown
Report progress after each major step:
- ✓ Step 1 complete
- ✓ Step 2 complete
- → Step 3 in progress
```

### Summary + Details

```markdown
## Summary
[High-level outcome in 1-2 sentences]

## Details
[Expandable detailed findings]

## Next Steps
[Recommended actions]
```
