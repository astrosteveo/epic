---
name: Create Subagent
description: Use this skill when creating new Claude Code subagents, authoring agent definitions, writing agent system prompts, or when the user asks about "create agent", "new subagent", "agent template", "agent best practices", "agent configuration", "define specialist", or "custom agent". Provides templates, validation, and best practices for high-quality agent authoring.
version: 1.0.0
---

# Subagent Creation Guide

This skill provides comprehensive guidance for creating high-quality Claude Code subagents. Use this when helping users define new specialized agents.

## Overview

Subagents are specialized AI assistants that can be invoked from the main Claude Code conversation. They run in isolated contexts with specific tools, prompts, and capabilities tailored to their purpose.

### Key Principles

1. **Single Responsibility** - Each agent should have one clear, focused purpose
2. **Detailed Prompts** - Provide specific instructions, examples, and constraints
3. **Minimal Tools** - Only grant tools necessary for the agent's purpose
4. **Clear Descriptions** - Help Claude understand when to invoke your agent
5. **Version Control** - Keep agents in `.claude/agents/` and commit them

## File Format

Subagents are Markdown files with YAML frontmatter:

```markdown
---
name: agent-name
description: Description of when this agent should be invoked
tools: Tool1, Tool2, Tool3
model: sonnet
---

Your agent's system prompt goes here.
```

### Frontmatter Fields

| Field | Required | Description |
|:------|:---------|:------------|
| `name` | Yes | Unique identifier (lowercase, hyphens only) |
| `description` | Yes | When to use this agent. Use "PROACTIVELY" or "MUST BE USED" for auto-invocation |
| `tools` | No | Comma-separated tool list. If omitted, inherits all tools |
| `model` | No | Model to use: `sonnet`, `opus`, `haiku`, or `inherit` |
| `permissionMode` | No | Permission handling: `default`, `acceptEdits`, `bypassPermissions`, `plan` |
| `skills` | No | Comma-separated list of skills to auto-load |

## Available Tools

**File Operations:**
- `Read` - Read file contents
- `Write` - Create new files
- `Edit` - Make precise edits
- `Glob` - Find files by pattern

**Code Search:**
- `Grep` - Search with regex
- `Bash` - Run terminal commands

**Web & Research:**
- `WebSearch` - Search the web
- `WebFetch` - Fetch web pages

**Special:**
- `Task` - Invoke other subagents

### Tool Combinations by Use Case

| Use Case | Recommended Tools |
|:---------|:------------------|
| Read-only analysis | `Read`, `Grep`, `Glob` |
| Code modification | `Read`, `Edit`, `Write`, `Grep`, `Glob` |
| Test execution | `Bash`, `Read`, `Grep` |
| Web research | `WebSearch`, `WebFetch`, `Read` |
| Full access | (omit tools field) |

## Model Selection

| Model | Use For |
|:------|:--------|
| `haiku` | Fast searches, simple lookups, exploration |
| `sonnet` | Balanced tasks, most common choice |
| `opus` | Complex analysis, critical reviews, security |
| `inherit` | Match parent conversation model |

## File Locations

**Project-Level** (highest priority):
- Location: `.claude/agents/`
- Scope: Current project only

**User-Level** (lower priority):
- Location: `~/.claude/agents/`
- Scope: All projects

## Creating a New Subagent

When helping a user create a subagent, follow this process:

### Step 1: Gather Requirements

Ask the user:
1. What is the agent's primary purpose?
2. What should trigger this agent?
3. What tools does it need?
4. Should it modify files or be read-only?
5. What model fits best for this task?

### Step 2: Design the Agent

Use the template from `references/agent-template.md` as a starting point.

Key considerations:
- Keep the name short and descriptive (use hyphens)
- Write a description that includes trigger keywords
- Choose the minimal set of tools needed
- Select appropriate model for the task complexity

### Step 3: Write the System Prompt

A good system prompt includes:
1. **Role definition** - Who the agent is
2. **Invocation behavior** - What to do immediately when invoked
3. **Process steps** - Ordered list of actions
4. **Quality criteria** - How to evaluate success
5. **Output format** - How to present results
6. **Constraints** - What NOT to do

### Step 4: Validate the Agent

Check:
- [ ] Name is lowercase with hyphens only
- [ ] Description explains when to invoke
- [ ] Tools are minimal and appropriate
- [ ] Model matches task complexity
- [ ] System prompt is specific and actionable
- [ ] Constraints prevent unwanted behavior

### Step 5: Save and Test

1. Create the file in `.claude/agents/` (project) or `~/.claude/agents/` (user)
2. Test by asking Claude to use the agent
3. Iterate based on results

## Example Agents

See `references/` for complete examples:
- `references/agent-template.md` - Base template
- `references/code-reviewer-example.md` - Code review specialist
- `references/debugger-example.md` - Debugging specialist
- `references/researcher-example.md` - Research specialist
- `references/security-scanner-example.md` - Security analysis

## Anti-Patterns to Avoid

1. **Too many tools** - Grants all tools when only a few are needed
2. **Vague description** - Doesn't help Claude know when to invoke
3. **Generic prompt** - Doesn't provide specific guidance
4. **No constraints** - Allows unintended behavior
5. **Wrong model** - Uses opus for simple tasks or haiku for complex analysis

## Quick Reference

```markdown
---
name: your-agent-name
description: PROACTIVELY use when [specific trigger conditions]
tools: Read, Grep, Glob
model: sonnet
---

You are a [role] specializing in [domain].

## When Invoked

1. First, [immediate action]
2. Then, [analysis step]
3. Finally, [output step]

## Process

- [Step-by-step guidance]
- [Quality criteria]
- [Edge case handling]

## Output Format

Provide results as:
- [Structured format]
- [Priority levels]
- [Actionable items]

## Constraints

- Never [unwanted behavior]
- Always [required behavior]
- Focus on [scope limitation]
```
