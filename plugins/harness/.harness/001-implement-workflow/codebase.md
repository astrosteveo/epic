# Codebase Analysis: Harness Workflow Plugin

## Repository Structure

```
/Users/astrosteveo/workspace/claude-code-plugins/
├── .claude-plugin/
│   └── marketplace.json          # Plugin collection registry
├── plugins/
│   ├── agent-workflow/           # Existing workflow plugin (reference)
│   ├── explore-plan-implement-commit/  # Another workflow plugin
│   └── harness/                  # Target plugin (currently minimal)
│       ├── WORKFLOW.md           # Workflow spec to implement
│       └── .harness/001-implement-workflow/  # This task
```

## Plugin System Patterns (from existing plugins)

### 1. Plugin Configuration
**File:** `.claude-plugin/plugin.json`
```json
{
  "name": "plugin-name",
  "description": "Short description",
  "version": "1.0.0",
  "author": {"name": "Author"},
  "homepage": "...",
  "repository": "...",
  "license": "MIT",
  "keywords": [...]
}
```
*Source: plugins/agent-workflow/.claude-plugin/plugin.json*

### 2. Command Structure
**Location:** `commands/{name}.md`
**Format:**
```markdown
---
description: "What this command does"
disable-model-invocation: true
---

Invoke the {plugin}:{skill} skill and follow it exactly
```
*Pattern observed in: agent-workflow/commands/brainstorm.md, write-plan.md, execute-plan.md*

### 3. Skill Structure
**Location:** `skills/{skill-name}/SKILL.md`
**Format:**
```markdown
---
name: skill-name
description: "What this skill does"
---

# Skill Title

## Overview
## When to Use
## The Process
## Key Principles
```
*Pattern observed in: agent-workflow/skills/brainstorming/SKILL.md, writing-plans/SKILL.md*

### 4. Agent Structure
**Location:** `agents/{agent-name}.md`
**Format:**
```markdown
---
name: agent-name
description: |
  When to use this agent
---

# Agent Title
## Role
## Responsibilities
```
*Pattern observed in: agent-workflow/agents/code-reviewer.md*

### 5. Hooks Structure
**Location:** `hooks/hooks.json`
```json
{
  "hooks": {
    "SessionStart": [{
      "matcher": "startup|resume|clear",
      "hooks": [{"type": "command", "command": "..."}]
    }]
  }
}
```
*Pattern observed in: agent-workflow/hooks/hooks.json*

## Current Harness Plugin State

### Files Present:
- `WORKFLOW.md` - Comprehensive workflow specification (250 lines)

### Files Deleted (from git history, commit 727637b):
- `.claude-plugin/plugin.json`
- 8 commands: clarify, commit, constitution, design, implement, plan, review, workflow
- 8 skills: clarify, commit, constitution, design, implement, plan, review, workflow
- 1 agent: verifier
- hooks: hooks.json, init.sh

### Key Insight:
Previous harness structure had different phase names. New implementation should align with WORKFLOW.md phases:
- **Old:** clarify, constitution, design, implement, review, commit
- **New:** define, research, plan, execute, verify

## Reference: agent-workflow Plugin

### Commands (3):
- `brainstorm.md` → invokes `brainstorming` skill
- `write-plan.md` → invokes `writing-plans` skill
- `execute-plan.md` → invokes `executing-plans` skill

### Skills (14):
- brainstorming, writing-plans, executing-plans
- test-driven-development, debugging
- receiving-code-review, refactoring
- subagent-driven-development
- using-agent-workflow (meta skill for intent detection)
- And more...

### Hooks:
- SessionStart hook injects `using-agent-workflow` skill content into context

## Reference: explore-plan-implement-commit Plugin

### Skills (4):
- workflow (orchestrator)
- discover (research codebase)
- code (implementation)
- review (validation)

### Agents (3):
- discoverer.md
- coder.md
- reviewer.md

### Artifact Pattern:
```
.harness/
├── {nnn}-{slug}/
│   ├── requirements.md
│   ├── codebase.md
│   ├── research.md
│   ├── design.md
│   └── plan.md
└── backlog.md
```

## Git History Context

Recent commits in this repo:
```
109ab59 docs: add v1 Claude Code workflow brainstorm
727637b feat(harness): add verifier agent and improve command wrappers
71cd660 feat(harness): add slash command wrappers for skills
315d4e2 feat: add harness workflow plugin
```
*Source: git log --oneline*

## Key Technical Observations

1. **Commands are thin wrappers** - They delegate to skills via "Invoke the X skill"
2. **Skills contain the logic** - Detailed step-by-step instructions
3. **Agents are personas** - Used for subagent-driven development
4. **Hooks inject context** - SessionStart commonly used for skill awareness
5. **Artifacts live in .harness/** - Task-scoped directories with numbered prefixes
