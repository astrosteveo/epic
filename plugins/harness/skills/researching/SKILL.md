---
name: researching
description: "Use after requirements are defined. Explores codebase, git history, and best practices to inform implementation. Produces codebase.md and research.md with implementation approaches."
---

# Researching Phase

Informed discovery with clear direction. Gather technical context before planning.

## When to Use

- After requirements are established in Define phase
- When you need to understand the codebase before making changes
- To research best practices, APIs, or external documentation
- Returning to gather more information after planning reveals gaps

## CRITICAL: Verify, Don't Assume

**Before stating ANY technical fact, version number, or best practice - STOP and verify it.**

Common assumption traps:
- ❌ "Bevy 0.15 is the latest..." → ✅ Search "Bevy latest version 2025" first
- ❌ "React 18 introduced..." → ✅ Verify React version history first
- ❌ "The standard way to do X is..." → ✅ Research current best practices first
- ❌ "This library is still maintained..." → ✅ Check repo activity/docs first
- ❌ "Python 3.12 supports..." → ✅ Verify language version features first

**If you catch yourself about to state a version, feature, or technical claim - pause and research it.**

Your training data has a cutoff date. Technology changes. **Always verify current state.**

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

After research, present implementation approaches.

**CRITICAL: How to Present Approaches**
- **Use the AskUserQuestion tool** - Provides better UX than text-only presentation
- **Provide 1-4 implementation approaches** - As few or as many as appropriate
- **First option is your recommendation** - Mark with "(Recommended)" in the label
- **Include trade-offs in descriptions** - Complexity, risk, flexibility, etc.
- **Be thorough but concise** - Each description should be clear and complete

**Example using AskUserQuestion:**
```
Question: "Based on my research, which implementation approach should we use?"
Options:
  1. "API-based approach (Recommended)" - Uses existing REST endpoints, lower risk, easier to test
  2. "Direct database access" - More performant but bypasses business logic layer
  3. "Event-driven approach" - Most flexible but adds complexity with message queues
  4. "Hybrid approach" - Combines API and events, balanced but requires both infrastructures
```

**Alternative: Text-based presentation if AskUserQuestion isn't suitable:**
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

- **Verify, never assume** - Check version numbers, APIs, best practices - your training data is dated
- **Facts, not opinions** - codebase.md is unopinionated observations
- **Use AskUserQuestion** - Better UX for presenting implementation approaches
- **Be thorough** - Present as many viable approaches as appropriate
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
