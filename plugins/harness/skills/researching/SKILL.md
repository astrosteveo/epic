---
name: researching
description: |
  Use this skill for informed discovery - exploring the codebase, mining git history, and researching best practices.
  Produces: .harness/{nnn}-{slug}/codebase.md and research.md
---

# Researching Phase

Informed discovery with clear direction. Gather technical context before planning.

## When to Use

- After requirements are established in Define phase
- When you need to understand the codebase before making changes
- To research best practices, APIs, or external documentation
- Returning to gather more information after planning reveals gaps

## The Process

### 1. Read Requirements

Start by reading the task's `requirements.md` to understand what you're researching for.

### 2. Explore the Codebase

**Structure and Patterns**
- Identify relevant files and directories
- Note existing patterns and conventions
- Find similar implementations to learn from

**Git History Mining**
- Use `git log` to understand how code evolved
- Use `git blame` to see who worked on what and when
- Use `git show` to understand specific changes
- Map findings to `file:line` with commit hashes for traceability

**Testing Context**
- Identify existing test frameworks and libraries
- Find test patterns used in the project
- Note test coverage expectations
- TDD is the default approach - understand how to add tests

### 3. Research Externally

When relevant:
- Best practices for the technology/pattern
- Library/framework API documentation
- Security considerations
- Performance implications

### 4. Document Findings

Create two artifacts in the task directory:

**`.harness/{nnn}-{slug}/codebase.md`**
```markdown
# Codebase Analysis: {Task Name}

## Relevant Files
{List of files that will be touched or referenced}

## Existing Patterns
{How similar things are done in this codebase}

## Git History
{Key commits and evolution of relevant code}
| File:Line | Commit | Author | Summary |
|-----------|--------|--------|---------|

## Testing Infrastructure
{Test frameworks, patterns, coverage expectations}

## Technical Dependencies
{Libraries, APIs, integrations involved}
```

**`.harness/{nnn}-{slug}/research.md`**
```markdown
# Research: {Task Name}

## Best Practices
{Industry standards and recommendations}

## API/Library Documentation
{Relevant docs for technologies involved}

## Security Considerations
{If applicable}

## Performance Considerations
{If applicable}

## Implementation Recommendations
{Summary of findings that inform the approach}
```

### 5. Present Approaches

After research, present implementation approaches:

- Offer as few or as many approaches as appropriate
- Mark one as **Recommended** with clear reasoning
- For each approach, note trade-offs (complexity, risk, flexibility)

Format:
```markdown
## Approach 1: {Name} (Recommended)
{Description and why it's recommended}

## Approach 2: {Name}
{Description and trade-offs}
```

### 6. Handle Rejection

If user rejects all approaches:
- Don't get stuck
- Use Socratic method: "What concerns you about these approaches?"
- Iterate based on feedback
- Loop back to Define if requirements need adjustment

### 7. Offer Transition

When user approves an approach:

> "Great, we'll go with {approach}. Ready to move to Plan where we'll design the architecture and detail the implementation steps?"

## Key Principles

- **Facts, not opinions** - codebase.md is unopinionated observations
- **Trace to source** - Include commit hashes, file:line references
- **TDD awareness** - Always identify how to test the implementation
- **Parallel research** - Use subagents for independent research tasks when appropriate
- **Stay focused** - Research what's needed for this task, not everything

## Returning to Research

You may return to this phase when:
- Planning reveals you don't understand something well enough
- Execution hits unexpected technical issues
- New requirements need technical assessment

Update the artifacts to reflect new findings.
