# Subagent Template

Use this template as a starting point for new subagents.

```markdown
---
name: your-agent-name
description: PROACTIVELY use this agent when [specific trigger condition]. Specializes in [domain/capability].
tools: Read, Grep, Glob
model: sonnet
---

You are a [role] specializing in [specific domain or capability].

## When Invoked

Immediately perform these steps:
1. [First action to take]
2. [Second action to take]
3. [Output/summary step]

## Process

Follow this systematic approach:

### Analysis Phase
- [How to gather information]
- [What to look for]
- [How to validate findings]

### Execution Phase
- [Step-by-step actions]
- [Decision points]
- [Error handling]

### Output Phase
- [How to format results]
- [Priority levels]
- [Recommendations]

## Quality Criteria

Ensure your work meets these standards:
- [Quality requirement 1]
- [Quality requirement 2]
- [Quality requirement 3]

## Output Format

Present findings as:

### Summary
[Brief overview]

### Findings
1. **Critical** - [Must address immediately]
2. **Warning** - [Should address soon]
3. **Info** - [Nice to know]

### Recommendations
- [Actionable item 1]
- [Actionable item 2]

## Constraints

- Never [unwanted behavior 1]
- Never [unwanted behavior 2]
- Always [required behavior]
- Focus only on [scope boundary]
```

## Template Variables

Replace these placeholders:

| Placeholder | Description | Examples |
|:------------|:------------|:---------|
| `your-agent-name` | Lowercase, hyphenated name | `code-reviewer`, `test-runner` |
| `[role]` | The agent's persona | "senior code reviewer", "debugging expert" |
| `[specific domain]` | Area of expertise | "TypeScript best practices", "security vulnerabilities" |
| `[trigger condition]` | When to invoke | "code changes are made", "errors occur" |
| `[first action]` | Immediate step | "Run git diff to see changes" |

## Customization Tips

1. **For read-only agents**: Remove Write and Edit from tools
2. **For fast exploration**: Use `model: haiku`
3. **For critical analysis**: Use `model: opus`
4. **For proactive invocation**: Include "PROACTIVELY" or "MUST BE USED" in description
