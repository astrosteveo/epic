# Command Creator Skill

This skill provides guidance for creating high-quality Claude Code slash commands following Anthropic's best practices.

## When to Use This Skill

Use this skill when the user asks to:
- "Create a slash command"
- "Make a /command for..."
- "Add a custom command"
- "Write a command that..."
- "I need a command to..."
- "Create a /something command"
- "Help me build a command"

## Command Fundamentals

### What Commands Are

Commands are **instructions FOR Claude**, not messages TO users. When a user runs `/my-command`, the command content becomes part of Claude's prompt. Write in imperative form telling Claude what to do.

### File Location & Naming

Commands are markdown files that get auto-discovered:

| Location | Scope | Shown As |
|----------|-------|----------|
| `.claude/commands/foo.md` | Project | `(project)` |
| `~/.claude/commands/foo.md` | Personal | `(user)` |
| `plugin/commands/foo.md` | Plugin | `(plugin:name)` |

**Naming**: Use kebab-case. Filename becomes command name:
- `deploy-staging.md` → `/deploy-staging`
- `review-pr.md` → `/review-pr`

Subdirectories create namespaces but don't affect the command name.

## Command Structure

### YAML Frontmatter

All frontmatter fields are **optional**. A command works with just content.

```yaml
---
description: Brief action description (max 60 chars)
argument-hint: [required-arg] [optional-arg]
allowed-tools:
  - Read
  - Bash(git:*)
model: sonnet
---
```

| Field | Purpose | Example |
|-------|---------|---------|
| `description` | Shows in `/help` output | `Review PR for security issues` |
| `argument-hint` | Documents expected args | `[pr-number] [priority]` |
| `allowed-tools` | Restricts tool access | `Read, Bash(npm:*)` |
| `model` | Forces specific model | `sonnet`, `opus`, `haiku` |

### Tool Restrictions

**Always use minimal permissions.** Restrict tools to what's actually needed:

```yaml
# Good - specific permissions
allowed-tools:
  - Read
  - Bash(git:*)
  - Bash(npm:test)

# Bad - overly permissive
allowed-tools:
  - Bash
```

Tool filter patterns:
- `Bash(git:*)` - Any git command
- `Bash(npm:test)` - Only npm test
- `Bash(docker:build, docker:run)` - Multiple specific commands

### Command Body

Write clear instructions for Claude:

```markdown
---
description: Analyze code for security vulnerabilities
argument-hint: [file-or-directory]
allowed-tools:
  - Read
  - Glob
  - Grep
---

Perform a security analysis on: $1

## Analysis Steps

1. Identify the file type and framework
2. Check for common vulnerabilities:
   - SQL injection patterns
   - XSS vulnerabilities
   - Hardcoded credentials
   - Insecure dependencies

3. Report findings with:
   - File and line number
   - Vulnerability type
   - Severity (Critical/High/Medium/Low)
   - Recommended fix

## Output Format

Present findings in a structured table, then provide remediation guidance.
```

## Dynamic Features

### Arguments

| Syntax | Description | Example |
|--------|-------------|---------|
| `$1`, `$2`, `$3` | Positional arguments | `/cmd foo bar` → `$1`=foo, `$2`=bar |
| `$ARGUMENTS` | All arguments as string | `/cmd foo bar baz` → `foo bar baz` |

### File References

Include file contents directly:
- `@path/to/file.md` - Static file reference
- `@$1` - File from first argument

```markdown
Review the code in @$1 for:
- Code style consistency
- Potential bugs
- Performance issues
```

### Bash Execution

Execute commands and include output:
```markdown
Current git status: !`git status --short`

Recent commits: !`git log --oneline -5`
```

### Plugin Portability

Use `${CLAUDE_PLUGIN_ROOT}` for plugin-relative paths:
```markdown
Load config: @${CLAUDE_PLUGIN_ROOT}/config/settings.json
Run script: !`node ${CLAUDE_PLUGIN_ROOT}/scripts/analyze.js`
```

## Quality Standards

### DO

1. **Be specific** - Clear, actionable instructions
2. **Use sections** - Break complex commands into steps
3. **Define output format** - Tell Claude how to present results
4. **Restrict tools** - Minimum necessary permissions
5. **Document arguments** - Use `argument-hint` for clarity
6. **Keep descriptions short** - Under 60 characters

### DON'T

1. **Don't write to users** - Commands are FOR Claude
2. **Don't be vague** - "Do the thing" is not helpful
3. **Don't over-permit** - Never use unrestricted `Bash`
4. **Don't forget context** - Reference relevant files/configs
5. **Don't hardcode paths** - Use `${CLAUDE_PLUGIN_ROOT}` in plugins

## Command Patterns

### Simple Analysis Command
```markdown
---
description: Count lines of code by language
allowed-tools:
  - Bash(cloc:*, tokei:*, find:*)
---

Count lines of code in this project, grouped by language.
Show totals and percentages.
```

### Multi-Step Workflow Command
```markdown
---
description: Full deployment to staging
argument-hint: [version-tag]
allowed-tools:
  - Read
  - Bash(git:*, npm:*, docker:*)
---

Deploy version $1 to staging environment.

## Pre-flight Checks
1. Verify on main branch
2. Ensure working directory is clean
3. Run test suite

## Deployment Steps
1. Build Docker image with tag $1
2. Push to registry
3. Update staging deployment
4. Verify health checks pass

## Post-Deployment
Report deployment status and provide rollback command if needed.
```

### Interactive Command with Choices
```markdown
---
description: Generate boilerplate code
argument-hint: [component-type]
allowed-tools:
  - Write
  - Read
---

Generate a new $1 component.

If $1 is not specified, ask the user to choose:
- component (React component)
- hook (Custom React hook)
- service (API service class)
- test (Test file)

Follow the patterns in @src/templates/ for consistency.
```

## Validation Checklist

Before finalizing a command, verify:

- [ ] Description under 60 characters
- [ ] `argument-hint` matches actual arguments used
- [ ] `allowed-tools` is minimally permissive
- [ ] Instructions are FOR Claude (imperative form)
- [ ] Output format is specified
- [ ] File references use correct syntax
- [ ] Plugin paths use `${CLAUDE_PLUGIN_ROOT}`

## References

- [Command Patterns](references/command-patterns.md) - Common command structures
- [Tool Restrictions](references/tool-restrictions.md) - Security best practices
- [Examples](examples/) - Complete working commands
