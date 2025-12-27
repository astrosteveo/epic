# Implementation Plan: Plugin Builder

<!-- APPROVED -->

## Overview

Create a Claude Code plugin that scaffolds individual components (skills, agents, commands, hooks) in the current project's `.claude/` directory through natural language commands. The plugin parses NL input, selects appropriate templates, generates domain-specific examples, and creates files in the correct structure.

## Pre-Implementation Checklist
- [x] requirements.md reviewed
- [x] design.md approved
- [ ] User approval of plan (adds <!-- APPROVED --> marker)

---

## Step 001-1: Create Plugin Structure

**Dependencies:** Independent

**Files to create/modify:**
- `plugins/plugin-builder/.claude-plugin/plugin.json`
- `plugins/plugin-builder/README.md`

**TDD Approach:**
1. No tests for this step (metadata files)
2. Validation: Verify plugin.json is valid JSON
3. Manual test: Plugin structure follows conventions

**Details:**

Create the base plugin directory structure and metadata.

**plugin.json contents:**
```json
{
  "name": "plugin-builder",
  "description": "Scaffold Claude Code components (skills, agents, commands, hooks) through natural language",
  "author": {
    "name": "astrosteveo"
  },
  "license": "MIT",
  "keywords": ["scaffolding", "generator", "templates", "development"]
}
```

**README.md contents:**
- Plugin overview
- Installation instructions
- Usage examples
- Template customization guide

**Commit message:** `feat(plugin-builder): create plugin structure and metadata`

---

## Step 001-2: Create Template Files - Skill

**Dependencies:** Depends on: 001-1

**Files to create/modify:**
- `plugins/plugin-builder/templates/skill/base.md`
- `plugins/plugin-builder/templates/skill/examples/simple.md`
- `plugins/plugin-builder/templates/skill/examples/advanced.md`
- `plugins/plugin-builder/templates/skill/examples/production.md`

**TDD Approach:**
1. No automated tests for template files
2. Validation: Ensure {{VARIABLES}} are properly placed
3. Manual test: Variable substitution produces valid SKILL.md

**Details:**

Create skill templates with educational progression.

**base.md structure:**
```markdown
---
name: {{NAME}}
description: "{{DESCRIPTION}}"
---

# {{DISPLAY_NAME}}

{{DOMAIN_INTRO}}

## When to Use

{{WHEN_TO_USE}}

## The Process

{{PROCESS_STEPS}}

## Key Principles

{{KEY_PRINCIPLES}}
```

**Variable placeholders:**
- `{{NAME}}` - Slugified name (e.g., "code-quality-review")
- `{{DISPLAY_NAME}}` - Human-readable (e.g., "Code Quality Review")
- `{{DESCRIPTION}}` - Brief description
- `{{DOMAIN}}` - Domain/purpose
- `{{DOMAIN_INTRO}}` - Generated introduction for the domain
- `{{WHEN_TO_USE}}` - When to invoke the skill
- `{{PROCESS_STEPS}}` - Step-by-step process
- `{{KEY_PRINCIPLES}}` - Best practices

**Examples templates:**
- `simple.md` - Basic pattern with minimal complexity
- `advanced.md` - Intermediate with additional features
- `production.md` - Full-featured, production-ready pattern

Each example should have:
- Clear heading indicating complexity level
- Domain-specific implementation
- Inline comments explaining key decisions
- Trade-offs discussion

**Commit message:** `feat(plugin-builder): add skill base template and examples`

---

## Step 001-3: Create Template Files - Agent, Command, Hook

**Dependencies:** Depends on: 001-1

**Files to create/modify:**
- `plugins/plugin-builder/templates/agent/base.md`
- `plugins/plugin-builder/templates/command/base.md`
- `plugins/plugin-builder/templates/hook/hooks.json`
- `plugins/plugin-builder/templates/hook/example-hook.sh`

**TDD Approach:**
1. No automated tests for template files
2. Validation: Verify YAML frontmatter syntax
3. Manual test: Generated components load correctly

**Details:**

**Agent template (base.md):**
```markdown
---
name: {{NAME}}
description: |
  {{DESCRIPTION}}
---

# {{DISPLAY_NAME}}

You are a {{DOMAIN}} specialist.

## Role

{{ROLE_DESCRIPTION}}

## Capabilities

{{CAPABILITIES}}

## Process

{{PROCESS_STEPS}}
```

**Command template (base.md):**
```markdown
---
description: {{DESCRIPTION}}
disable-model-invocation: true
---

{{COMMAND_INSTRUCTIONS}}
```

**Hook template (hooks.json):**
```json
{
  "hooks": {
    "{{HOOK_TYPE}}": [
      {
        "matcher": "{{MATCHER}}",
        "hooks": [
          {
            "type": "command",
            "command": "bash \"${CLAUDE_PLUGIN_ROOT}/hooks/{{NAME}}.sh\""
          }
        ]
      }
    ]
  }
}
```

**Hook script template (example-hook.sh):**
- Bash shebang and set -euo pipefail
- Input reading pattern (stdin for PreToolUse)
- jq parsing example
- Comments explaining hook behavior
- Exit codes (0=allow, 2=block)

**Commit message:** `feat(plugin-builder): add agent, command, and hook templates`

---

## Step 001-4: Create Generator Skill - NL Parsing

**Dependencies:** Depends on: 001-2, 001-3

**Files to create/modify:**
- `plugins/plugin-builder/skills/generator/SKILL.md`

**TDD Approach:**
1. Write test cases for NL parsing logic (document in skill)
2. Test patterns: "create a skill for X", "create an agent for Y", "create a command to Z"
3. Validate extraction of: type, domain, name

**Details:**

Create the generator skill with NL parsing capability.

**Skill structure:**
```markdown
---
name: generator
description: "Parse natural language to scaffold Claude Code components. Use when user requests creating skills, agents, commands, or hooks."
---

# Plugin Builder Generator

Parse natural language input to create Claude Code components in .claude/ directory.

## NL Parsing Patterns

### Component Type Detection

**Keywords mapping:**
- "skill", "agent skill", "capability" → Type: skill
- "agent" (not "agent skill"), "subagent" → Type: agent
- "command", "slash command" → Type: command
- "hook" → Type: hook

**Parsing algorithm:**
1. Extract verb: "create", "add", "make", "scaffold"
2. Extract type: First keyword match from types above
3. Extract domain: Everything after "for" or "to"
4. Generate name: Slugify domain (lowercase, hyphens)

**Examples:**
- "create a skill for code quality review"
  → type="skill", domain="code quality review", name="code-quality-review"
- "create an agent for deployment automation"
  → type="agent", domain="deployment automation", name="deployment-automation"
- "add a command to run tests"
  → type="command", domain="run tests", name="run-tests"

### Domain Extraction

Extract the purpose/domain from common patterns:
- "create X **for** {domain}" → domain
- "create X **to** {purpose}" → domain
- "create a {domain} X" → domain

## Template Selection Logic

Based on component type, select template directory:
```
type=skill  → templates/skill/
type=agent  → templates/agent/
type=command → templates/command/
type=hook   → templates/hook/
```

## File Generation Process

1. Parse NL input → extract type, domain, name
2. Load base template for type
3. Generate domain-specific content
4. Substitute variables in template
5. Create directory structure in .claude/{type}/{name}/
6. Write files
7. Confirm creation to user
```

**Implementation notes:**
- Use regex or keyword matching for type detection
- Handle ambiguous cases with clarifying questions
- Validate that component doesn't already exist
- Provide meaningful error messages

**Commit message:** `feat(plugin-builder): add generator skill with NL parsing`

---

## Step 001-5: Add Domain Customization to Generator Skill

**Dependencies:** Depends on: 001-4

**Files to create/modify:**
- `plugins/plugin-builder/skills/generator/SKILL.md` (update)

**TDD Approach:**
1. Test domain customization with known domains
2. Verify: "code quality" → generates linting examples
3. Verify: "deployment" → generates CI/CD examples

**Details:**

Extend generator skill with domain-specific content generation.

**Add to SKILL.md:**

```markdown
## Domain-Specific Content Generation

Use Claude's knowledge of the domain to generate relevant, practical examples.

### Content Generation Strategy

For each domain, generate:
1. **Introduction** - What the domain involves
2. **When to Use** - Triggering criteria
3. **Process Steps** - Domain-specific workflow
4. **Examples** - Practical, realistic examples
5. **Key Principles** - Best practices for the domain

### Example Domains

**Code Quality Review:**
- Simple: Basic linting checklist (syntax, formatting)
- Advanced: Code smell detection (duplication, complexity)
- Production: Full review workflow (security, performance, maintainability)

**Deployment Automation:**
- Simple: Basic deploy script trigger
- Advanced: Multi-environment deployment with validation
- Production: Blue-green deployment with rollback

**Test Runner:**
- Simple: Single test command execution
- Advanced: Test selection by pattern or tag
- Production: Parallel test execution with reporting

### Generation Function

For skill type:
1. Read base template
2. Generate domain-specific content for each section
3. Generate 3 examples (simple, advanced, production)
4. Substitute all {{VARIABLES}}
5. Write SKILL.md + examples/

For agent type:
1. Read base template
2. Generate role description for domain
3. List capabilities specific to domain
4. Define process steps
5. Write agent.md

For command type:
1. Read base template
2. Generate command instructions
3. Add usage examples
4. Write command.md

For hook type:
1. Determine hook type (SessionStart, PreToolUse, PostToolUse)
2. Generate hook logic for domain
3. Write hooks.json + hook script
```

**Implementation approach:**
- Use Claude's knowledge to generate content
- Provide concrete, realistic examples
- Include inline comments explaining patterns
- Show progression from simple to complex

**Commit message:** `feat(plugin-builder): add domain-specific content generation`

---

## Step 001-6: Create Main Command

**Dependencies:** Depends on: 001-5

**Files to create/modify:**
- `plugins/plugin-builder/commands/create-plugin.md`

**TDD Approach:**
1. Test command invocation
2. Verify it passes input to generator skill
3. Manual test: /plugin-builder:create-plugin works

**Details:**

Create the main entry point command.

**create-plugin.md contents:**
```markdown
---
description: Create Claude Code components (skills, agents, commands, hooks) from natural language
disable-model-invocation: false
---

Parse the user's input and invoke the plugin-builder:generator skill to scaffold the requested component.

**Input format:**
- User provides natural language description
- Example: "create a skill for code quality review"

**Your task:**
1. Extract the full description from the user's input
2. Invoke the plugin-builder:generator skill
3. Pass the description to the skill
4. Let the skill handle parsing, generation, and file creation

**Do not modify or interpret the description - pass it verbatim to the generator skill.**
```

**Implementation notes:**
- Keep command simple - delegate to skill
- Command acts as thin wrapper
- Skill does all the heavy lifting

**Commit message:** `feat(plugin-builder): add create-plugin command`

---

## Step 001-7: Add Validation and Error Handling

**Dependencies:** Depends on: 001-6

**Files to create/modify:**
- `plugins/plugin-builder/skills/generator/SKILL.md` (update)

**TDD Approach:**
1. Test error cases:
   - Ambiguous input
   - Invalid type
   - Existing component
   - Missing domain
2. Verify appropriate error messages
3. Verify clarifying questions are asked

**Details:**

Add robust error handling to generator skill.

**Add to SKILL.md:**

```markdown
## Validation and Error Handling

### Input Validation

**Check 1: Component type is recognized**
- Valid types: skill, agent, command, hook
- If unrecognized: "Unknown component type '{type}'. Valid types: skill, agent, command, hook"

**Check 2: Domain is provided**
- Domain must be extracted from input
- If missing: "Please specify what the component is for. Example: 'create a skill for code review'"

**Check 3: Component doesn't exist**
- Check if `.claude/{type}/{name}/` exists
- If exists: Ask "Component '{name}' already exists. Overwrite? (yes/no)"

### Ambiguity Handling

**Use AskUserQuestion tool when input is ambiguous:**

Example 1: Unclear type
```
Input: "create something for testing"
Question: "What type of component would you like to create?"
Options:
  1. "Skill - Auto-invoked capability"
  2. "Agent - Specialized subagent"
  3. "Command - Slash command"
  4. "Hook - Event handler"
```

Example 2: Confirm interpretation
```
Input: "make a test runner"
Question: "I'll create a skill for test execution. Is this correct?"
Options:
  1. "Yes, create a skill (Recommended)"
  2. "No, create a command instead"
  3. "No, create an agent instead"
```

### Error Messages

**Clear, actionable error messages:**
- ❌ "Invalid input"
- ✅ "Could not determine component type. Please specify: skill, agent, command, or hook"

- ❌ "Failed"
- ✅ "Component 'code-review' already exists at .claude/skills/code-review/. Use a different name or confirm overwrite."

### Success Messages

**Confirm what was created:**
```
Created skill 'code-quality-review' in .claude/skills/code-quality-review/

Files created:
- SKILL.md (main skill definition)
- examples/simple.md (basic approach)
- examples/advanced.md (intermediate approach)
- examples/production.md (production-ready approach)

Next steps:
- Review and customize the generated skill
- Test with: /code-quality-review
- Edit examples/ to match your specific needs
```
```

**Implementation notes:**
- Use AskUserQuestion for all clarifications
- Provide helpful next steps
- List all created files
- Suggest how to test/use the component

**Commit message:** `feat(plugin-builder): add validation and error handling`

---

## Step 001-8: Create Example Generators and Documentation

**Dependencies:** Depends on: 001-7

**Files to create/modify:**
- `plugins/plugin-builder/README.md` (update)
- `plugins/plugin-builder/EXAMPLES.md` (new)

**TDD Approach:**
1. Test each example command
2. Verify generated components work correctly
3. Document expected outputs

**Details:**

Document the plugin with comprehensive examples and usage guide.

**Update README.md with:**
- Quick start guide
- Usage examples for each component type
- Template customization guide
- Troubleshooting section

**Create EXAMPLES.md with:**

```markdown
# Plugin Builder Examples

## Creating Skills

### Example 1: Code Quality Reviewer
```
/plugin-builder:create-plugin create a skill for code quality review
```

**Generated files:**
- `.claude/skills/code-quality-review/SKILL.md`
- `.claude/skills/code-quality-review/examples/simple.md`
- `.claude/skills/code-quality-review/examples/advanced.md`
- `.claude/skills/code-quality-review/examples/production.md`

**Usage:**
The skill is automatically available. Claude will invoke it when discussing code quality.

### Example 2: Deployment Automation
```
/plugin-builder:create-plugin create a skill for deployment automation
```

## Creating Agents

### Example 3: Test Reporter
```
/plugin-builder:create-plugin create an agent for test result analysis
```

**Generated files:**
- `.claude/agents/test-result-analysis.md`

**Usage:**
Invoke with: `@test-result-analysis analyze the test failures`

## Creating Commands

### Example 4: Run Tests
```
/plugin-builder:create-plugin create a command to run project tests
```

**Generated files:**
- `.claude/commands/run-project-tests.md`

**Usage:**
Invoke with: `/run-project-tests`

## Creating Hooks

### Example 5: Pre-commit Validation
```
/plugin-builder:create-plugin create a hook for pre-commit validation
```

**Generated files:**
- `.claude/hooks/hooks.json` (updated)
- `.claude/hooks/pre-commit-validation.sh`

**Usage:**
Hook triggers automatically before commits.
```

**Commit message:** `docs(plugin-builder): add comprehensive examples and usage guide`

---

## Summary

| Step | Description | Dependencies | Files |
|------|-------------|--------------|-------|
| 001-1 | Create plugin structure and metadata | Independent | plugin.json, README.md |
| 001-2 | Create skill base template and examples | Depends on 001-1 | templates/skill/* |
| 001-3 | Create agent, command, hook templates | Depends on 001-1 | templates/agent/*, templates/command/*, templates/hook/* |
| 001-4 | Create generator skill with NL parsing | Depends on 001-2, 001-3 | skills/generator/SKILL.md |
| 001-5 | Add domain-specific content generation | Depends on 001-4 | skills/generator/SKILL.md (update) |
| 001-6 | Create main command | Depends on 001-5 | commands/create-plugin.md |
| 001-7 | Add validation and error handling | Depends on 001-6 | skills/generator/SKILL.md (update) |
| 001-8 | Create examples and documentation | Depends on 001-7 | README.md (update), EXAMPLES.md |

## Parallelization Opportunities

- Steps 001-2 and 001-3 can run in parallel (independent template types)
- Steps 001-4, 001-5, 001-7 are sequential (build on each other)
- Step 001-8 is independent but should wait for 001-7 (complete implementation)

## Deferred Items

None - all requirements are in scope for initial version.

## Notes

- No traditional TDD for template files (validated through manual testing)
- Focus on clear, educational examples in templates
- Generator skill is the core - invest time in robust parsing and error handling
- Domain customization leverages Claude's knowledge - no external APIs needed
