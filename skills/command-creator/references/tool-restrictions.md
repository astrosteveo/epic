# Tool Restrictions Reference

Security best practices for `allowed-tools` in Claude Code commands.

## Principle: Least Privilege

Commands should request only the minimum tools necessary to complete their task. Over-permissive commands create security risks and reduce user trust.

## Tool Categories

### Read-Only Tools (Low Risk)

These tools cannot modify the system:

| Tool | Purpose | Risk Level |
|------|---------|------------|
| `Read` | Read file contents | Low |
| `Glob` | Find files by pattern | Low |
| `Grep` | Search file contents | Low |
| `WebFetch` | Fetch URL contents | Low |
| `WebSearch` | Search the web | Low |

**Recommendation**: Generally safe to include without restrictions.

### Write Tools (Medium Risk)

These tools can modify files:

| Tool | Purpose | Risk Level |
|------|---------|------------|
| `Write` | Create/overwrite files | Medium |
| `Edit` | Modify existing files | Medium |
| `NotebookEdit` | Edit Jupyter notebooks | Medium |

**Recommendation**: Include only when the command genuinely needs to create or modify files. Consider whether `Read` alone would suffice.

### Execution Tools (High Risk)

These tools can run arbitrary code:

| Tool | Purpose | Risk Level |
|------|---------|------------|
| `Bash` | Execute shell commands | High |
| `Task` | Launch subagents | Medium |

**Recommendation**: Always use command filters with Bash. Never include unrestricted `Bash`.

## Bash Filtering Syntax

### Basic Patterns

```yaml
# Single command
allowed-tools:
  - Bash(git:*)

# Multiple commands
allowed-tools:
  - Bash(git:*, npm:*, docker:*)

# Specific subcommands
allowed-tools:
  - Bash(git:status, git:diff, git:log)

# Command with specific args
allowed-tools:
  - Bash(npm:test, npm:run build)
```

### Common Safe Patterns

```yaml
# Git operations (read-only)
- Bash(git:status, git:log, git:diff, git:branch)

# Git operations (with commits)
- Bash(git:*)

# Node.js development
- Bash(npm:test, npm:run, npm:install)

# Python development
- Bash(python:*, pip:*, pytest:*)

# Docker (read-only)
- Bash(docker:ps, docker:images, docker:logs)

# Docker (with build/run)
- Bash(docker:*)

# File system (safe queries)
- Bash(ls:*, tree:*, find:*, wc:*)
```

### Dangerous Patterns to Avoid

```yaml
# NEVER do this - unrestricted shell access
allowed-tools:
  - Bash

# Avoid - too broad for most commands
allowed-tools:
  - Bash(rm:*, mv:*)

# Avoid - system modification
allowed-tools:
  - Bash(sudo:*, chmod:*, chown:*)
```

## Risk Assessment by Command Type

### Analysis Commands

Typically need only read access:

```yaml
# Good - minimal permissions
allowed-tools:
  - Read
  - Glob
  - Grep

# Only if truly needed
allowed-tools:
  - Bash(cloc:*, tokei:*)  # Code counting tools
```

### Generation Commands

Need write access, possibly templates:

```yaml
allowed-tools:
  - Read   # Read templates
  - Write  # Create new files
```

### Workflow Commands

May need broader access—be specific:

```yaml
# Deployment command - specific tools only
allowed-tools:
  - Read
  - Bash(git:*, npm:build, docker:build, docker:push)
```

### Query Commands

Usually read-only with specific queries:

```yaml
allowed-tools:
  - Bash(git:log, git:status, git:branch)
  - Read
```

## Tool Combinations

### Safe Combinations

```yaml
# Code review
allowed-tools: [Read, Glob, Grep]

# Documentation
allowed-tools: [Read, Write, Glob]

# Git workflow
allowed-tools: [Read, Bash(git:*)]

# Testing
allowed-tools: [Read, Bash(npm:test, pytest:*)]
```

### Combinations Requiring Caution

```yaml
# File operations + execution
allowed-tools:
  - Write
  - Bash(*)  # Dangerous! Be specific

# Better:
allowed-tools:
  - Write
  - Bash(prettier:*, eslint:--fix)  # Specific formatters only
```

## Verification Checklist

Before finalizing `allowed-tools`:

1. **Necessity**: Does the command actually need each tool?
2. **Specificity**: Are Bash commands filtered to specific programs?
3. **Write Access**: Is Write/Edit truly required, or would Read suffice?
4. **Execution**: Could the task be done without Bash?
5. **Scope**: Are permissions scoped to the command's actual purpose?

## Examples: Good vs Bad

### Code Analysis Command

```yaml
# Bad - overly permissive
allowed-tools:
  - Read
  - Write
  - Bash

# Good - minimal for analysis
allowed-tools:
  - Read
  - Glob
  - Grep
```

### Deployment Command

```yaml
# Bad - unrestricted
allowed-tools:
  - Bash

# Good - specific to deployment
allowed-tools:
  - Read
  - Bash(git:*, npm:run build, docker:build, docker:push, kubectl:apply)
```

### Test Runner Command

```yaml
# Bad - too broad
allowed-tools:
  - Bash(npm:*)

# Good - just testing
allowed-tools:
  - Bash(npm:test, npm:run test:*)
```

## When to Request More Permissions

If a command legitimately needs broader access:

1. Document why in the command body
2. Add verification steps before destructive operations
3. Consider breaking into multiple commands with different permission levels
4. Use confirmation prompts for high-risk operations
