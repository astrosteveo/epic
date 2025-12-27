---
name: generator
description: "Parse natural language to scaffold Claude Code components. Use when user requests creating skills, agents, commands, or hooks."
---

# Plugin Builder Generator

Parse natural language input to create Claude Code components in `.claude/` directory.

## When to Use

- User says "create a skill for X"
- User says "create an agent for Y"
- User says "create a command to Z"
- User says "create a hook for W"
- User wants to scaffold any Claude Code component

## NL Parsing Patterns

### Component Type Detection

**Keywords mapping:**
- "skill", "agent skill", "capability" → Type: **skill**
- "agent" (not "agent skill"), "subagent" → Type: **agent**
- "command", "slash command" → Type: **command**
- "hook" → Type: **hook**

**Note**: "agent skill" is treated as "skill" because it's a colloquial term for skills.

**Parsing algorithm:**
1. Extract verb: "create", "add", "make", "scaffold", "generate"
2. Extract type: First keyword match from types above
3. Extract domain: Everything after "for" or "to"
4. Generate name: Slugify domain (lowercase, hyphens, no spaces)

**Examples:**
- "create a skill for code quality review"
  → type="skill", domain="code quality review", name="code-quality-review"

- "create an agent for deployment automation"
  → type="agent", domain="deployment automation", name="deployment-automation"

- "add a command to run tests"
  → type="command", domain="run tests", name="run-tests"

- "create a hook for pre-commit validation"
  → type="hook", domain="pre-commit validation", name="pre-commit-validation"

### Domain Extraction

Extract the purpose/domain from common patterns:
- "create X **for** {domain}" → domain
- "create X **to** {purpose}" → domain
- "create a {domain} X" → domain

If domain is unclear, extract everything after the type keyword.

### Name Generation

Convert domain to valid filename:
1. Lowercase everything
2. Replace spaces with hyphens
3. Remove special characters except hyphens
4. Trim leading/trailing hyphens

Examples:
- "Code Quality Review" → "code-quality-review"
- "Test Runner (Fast)" → "test-runner-fast"
- "Deploy to Production" → "deploy-to-production"

## Template Selection Logic

Based on component type, select template directory:

```
type=skill   → templates/skill/
type=agent   → templates/agent/
type=command → templates/command/
type=hook    → templates/hook/
```

## File Generation Process

### For Skills

1. Parse NL input → extract type, domain, name
2. Load `templates/skill/base.md`
3. Generate domain-specific content (will be added in next step)
4. Substitute variables in template
5. Create `.claude/skills/{name}/`
6. Write `SKILL.md`
7. Load example templates
8. Generate domain-specific examples
9. Write `examples/simple.md`, `examples/advanced.md`, `examples/production.md`
10. Confirm creation

**Files created:**
```
.claude/skills/{name}/
├── SKILL.md
└── examples/
    ├── simple.md
    ├── advanced.md
    └── production.md
```

### For Agents

1. Parse NL input
2. Load `templates/agent/base.md`
3. Generate domain-specific content
4. Substitute variables
5. Create `.claude/agents/`
6. Write `{name}.md`
7. Confirm creation

**Files created:**
```
.claude/agents/{name}.md
```

### For Commands

1. Parse NL input
2. Load `templates/command/base.md`
3. Generate domain-specific content
4. Substitute variables
5. Create `.claude/commands/`
6. Write `{name}.md`
7. Confirm creation

**Files created:**
```
.claude/commands/{name}.md
```

### For Hooks

1. Parse NL input
2. Determine hook type (ask user if unclear)
3. Load `templates/hook/hooks.json` and `example-hook.sh`
4. Generate hook-specific logic
5. Substitute variables
6. Create/update `.claude/hooks/hooks.json`
7. Write `.claude/hooks/{name}.sh`
8. Make script executable
9. Confirm creation

**Files created:**
```
.claude/hooks/
├── hooks.json (created or updated)
└── {name}.sh
```

## Variable Substitution

Replace these placeholders in templates:

- `{{NAME}}` - Slugified name (e.g., "code-quality-review")
- `{{DISPLAY_NAME}}` - Human-readable (e.g., "Code Quality Review")
- `{{DESCRIPTION}}` - Brief description
- `{{DOMAIN}}` - Domain/purpose as provided by user
- `{{DOMAIN_INTRO}}` - Generated introduction for the domain
- `{{WHEN_TO_USE}}` - When to invoke (for skills)
- `{{PROCESS_STEPS}}` - Step-by-step process
- `{{KEY_PRINCIPLES}}` - Best practices
- `{{ROLE_DESCRIPTION}}` - Agent's role (for agents)
- `{{CAPABILITIES}}` - Agent capabilities (for agents)
- `{{COMMAND_INSTRUCTIONS}}` - Command instructions (for commands)
- `{{HOOK_TYPE}}` - SessionStart, PreToolUse, PostToolUse (for hooks)
- `{{MATCHER}}` - Regex matcher (for hooks)
- `{{INPUT_HANDLING}}` - Stdin reading pattern (for hooks)
- `{{HOOK_LOGIC}}` - Hook implementation (for hooks)
- `{{EXIT_CODE}}` - Exit code logic (for hooks)

For skill examples:
- `{{SIMPLE_*}}` - Simple approach variables
- `{{ADVANCED_*}}` - Advanced approach variables
- `{{PRODUCTION_*}}` - Production approach variables

## Implementation Steps

1. **Parse Input**
   ```
   Input: User's NL description
   Output: {type, domain, name}
   ```

2. **Validate Component Type**
   ```
   If type not in [skill, agent, command, hook]:
     Error: "Unknown component type '{type}'. Valid types: skill, agent, command, hook"
   ```

3. **Check if Exists**
   ```
   If .claude/{type}/{name}/ exists (or {name}.md for agents/commands):
     Ask: "Component '{name}' already exists. Overwrite? (yes/no)"
   ```

4. **Load Template**
   ```
   Read templates/{type}/base.md
   For skills: Also read examples/*.md
   ```

5. **Generate Domain-Specific Content**
   ```
   Use Claude's knowledge of the domain to create relevant examples
   See "Domain-Specific Content Generation" section below
   ```

6. **Substitute Variables**
   ```
   Replace all {{VARIABLES}} with actual values
   ```

7. **Write Files**
   ```
   Use Write tool to create files in .claude/ directory
   Ensure directories exist first
   ```

8. **Confirm**
   ```
   List files created
   Suggest next steps (how to use/test)
   ```

## Test Cases

Test the NL parsing with these inputs:

1. **Clear skill request:**
   - Input: "create a skill for code quality review"
   - Expected: type=skill, domain="code quality review", name="code-quality-review"

2. **Agent skill (treated as skill):**
   - Input: "create an agent skill for deployment automation"
   - Expected: type=skill, domain="deployment automation", name="deployment-automation"

3. **True agent request:**
   - Input: "create an agent for test analysis"
   - Expected: type=agent, domain="test analysis", name="test-analysis"

4. **Command request:**
   - Input: "create a command to run all tests"
   - Expected: type=command, domain="run all tests", name="run-all-tests"

5. **Hook request:**
   - Input: "create a hook for pre-commit validation"
   - Expected: type=hook, domain="pre-commit validation", name="pre-commit-validation"

6. **Ambiguous (missing type):**
   - Input: "create something for testing"
   - Expected: Ask clarification

7. **Missing domain:**
   - Input: "create a skill"
   - Expected: Error or ask for domain

## Domain-Specific Content Generation

Use Claude's knowledge of the domain to generate relevant, practical examples.

### Content Generation Strategy

For each domain, generate contextually appropriate content based on what the domain involves.

**Process:**
1. Understand the domain (e.g., "code quality review" → linting, best practices, maintainability)
2. Generate introduction explaining the domain
3. Create when-to-use criteria specific to the domain
4. Develop process steps tailored to domain workflows
5. Formulate key principles/best practices for the domain
6. For skills: Create 3 examples showing progression

### Example Domains and Their Content

#### Code Quality Review

**Domain Intro:**
"Code quality review ensures code meets standards for readability, maintainability, security, and performance. It catches issues before they reach production."

**When to Use:**
- Before merging pull requests
- During code reviews
- When refactoring legacy code
- As part of CI/CD pipeline

**Process Steps:**
1. Check syntax and formatting
2. Review naming conventions
3. Identify code smells
4. Verify error handling
5. Assess security vulnerabilities
6. Evaluate performance implications

**Simple Example:** Basic linting checklist (syntax, formatting, simple rules)
**Advanced Example:** Code smell detection (duplication, complexity metrics, architectural violations)
**Production Example:** Full review workflow (security scanning, performance profiling, automated suggestions)

#### Deployment Automation

**Domain Intro:**
"Deployment automation streamlines the process of releasing code to various environments, reducing manual errors and increasing deployment frequency."

**When to Use:**
- Deploying to staging/production
- Implementing CI/CD pipelines
- Managing multi-environment deployments
- Coordinating rollouts with rollback capability

**Process Steps:**
1. Validate deployment prerequisites
2. Run pre-deployment tests
3. Execute deployment to target environment
4. Perform health checks
5. Monitor for issues
6. Rollback if necessary

**Simple Example:** Single command deploy script
**Advanced Example:** Multi-environment deployment with validation gates
**Production Example:** Blue-green deployment with automated rollback and monitoring

#### Test Runner

**Domain Intro:**
"Test automation ensures code correctness through systematic validation, catching regressions and verifying new functionality."

**When to Use:**
- During development (TDD workflow)
- Before committing code
- In CI/CD pipelines
- For regression testing

**Process Steps:**
1. Discover test files
2. Select tests to run (all, changed, by pattern)
3. Execute tests in appropriate environment
4. Collect and format results
5. Report failures with details
6. Generate coverage reports

**Simple Example:** Run all tests with single command
**Advanced Example:** Selective test execution with pattern matching
**Production Example:** Parallel test execution with detailed reporting and coverage

### Generation Function for Skills

When generating a skill, create:

1. **DOMAIN_INTRO** - 1-2 sentences explaining what the domain involves

2. **WHEN_TO_USE** - 3-5 bullet points of specific scenarios
   - Be specific: "When X happens" not "When you need Y"
   - Include trigger conditions
   - Reference common workflows

3. **PROCESS_STEPS** - Numbered list of 4-8 steps
   - Action-oriented verbs
   - Clear sequence
   - Specific to domain, not generic

4. **KEY_PRINCIPLES** - 4-6 best practices
   - Domain-specific wisdom
   - Trade-offs to consider
   - Common pitfalls to avoid

5. **Simple Example** - Basic pattern
   - Focus on fundamentals
   - Minimal complexity
   - Quick to implement (< 30 min)
   - Clear value proposition

6. **Advanced Example** - Intermediate pattern
   - Add key features from production pattern
   - Handle edge cases
   - Moderate complexity (1-2 hours)
   - Production-capable for small/medium use

7. **Production Example** - Enterprise pattern
   - Full feature set
   - Error handling, logging, monitoring
   - Scalable and maintainable
   - Significant investment (3-4 hours)

### Generation Function for Agents

When generating an agent, create:

1. **ROLE_DESCRIPTION** - What the agent specializes in
   - "You are a {domain} specialist"
   - "Your expertise includes..."
   - "You focus on..."

2. **CAPABILITIES** - Specific things the agent can do
   - List 4-8 capabilities
   - Be concrete: "Analyze test failures" not "Help with tests"
   - Domain-specific actions

3. **PROCESS_STEPS** - Agent's workflow
   - How the agent approaches problems
   - Information gathering
   - Analysis steps
   - Output generation

### Generation Function for Commands

When generating a command, create:

1. **COMMAND_INSTRUCTIONS** - What the command does and how
   - Clear description of command purpose
   - Input parameters (if any)
   - Expected output

2. **USAGE_EXAMPLES** - 2-3 concrete examples
   - Show different use cases
   - Include expected output
   - Demonstrate options/parameters

3. **OPTIONS** - Available command options (if applicable)
   - Option flags
   - Default values
   - Examples of each option

### Generation Function for Hooks

When generating a hook, create:

1. **Determine HOOK_TYPE**
   - SessionStart: For initialization, setup
   - PreToolUse: For validation, gates, blocking
   - PostToolUse: For cleanup, logging, follow-up

2. **INPUT_HANDLING** - How to read input
   - PreToolUse: Read JSON from stdin
   - SessionStart: No input needed
   - Include jq parsing examples

3. **HOOK_LOGIC** - Domain-specific validation/action
   - Check conditions
   - Perform validation
   - Execute actions

4. **MATCHER** - Regex pattern for when hook triggers
   - Tool names for PreToolUse
   - Event names for SessionStart

## Validation and Error Handling

### Input Validation

**Check 1: Component type is recognized**
```
Valid types: skill, agent, command, hook
If unrecognized type extracted:
  Error: "Unknown component type '{type}'. Valid types: skill, agent, command, hook"
```

**Check 2: Domain is provided**
```
Domain must be extracted from input
If missing or unclear:
  Error: "Please specify what the component is for. Example: 'create a skill for code review'"
```

**Check 3: Component doesn't already exist**
```
For skills: Check if .claude/skills/{name}/ exists
For agents: Check if .claude/agents/{name}.md exists
For commands: Check if .claude/commands/{name}.md exists
For hooks: Check if .claude/hooks/{name}.sh exists

If exists:
  Use AskUserQuestion: "Component '{name}' already exists. Overwrite?"
  Options:
    1. "No, cancel (Recommended)" - Keep existing component
    2. "Yes, overwrite" - Replace with new generated component
```

### Ambiguity Handling

**Use AskUserQuestion tool when input is ambiguous:**

**Example 1: Unclear type**
```
Input: "create something for testing"

Question: "What type of component would you like to create?"
Options:
  1. "Skill - Auto-invoked capability (Recommended)"
  2. "Agent - Specialized subagent"
  3. "Command - Slash command"
  4. "Hook - Event handler"
```

**Example 2: Confirm interpretation**
```
Input: "make a code reviewer"

Before generating, confirm:
Question: "I'll create a skill for code review. Is this correct?"
Options:
  1. "Yes, create skill (Recommended)"
  2. "No, create agent instead"
  3. "No, create command instead"
```

### Error Messages

**Clear, actionable error messages:**

❌ **Bad:** "Invalid input"
✅ **Good:** "Could not determine component type. Please specify: skill, agent, command, or hook"

❌ **Bad:** "Failed"
✅ **Good:** "Component 'code-review' already exists at .claude/skills/code-review/. Use a different name or confirm overwrite."

### Success Messages

**Confirm what was created with helpful next steps:**

For skills:
```
✅ Created skill 'code-quality-review' in .claude/skills/code-quality-review/

Files created:
- SKILL.md (main skill definition)
- examples/simple.md (basic approach)
- examples/advanced.md (intermediate approach)
- examples/production.md (production-ready approach)

Next steps:
1. Review and customize the generated skill
2. Claude will auto-invoke it when relevant
3. Edit examples/ to match your specific needs

The skill is ready to use immediately!
```

For agents:
```
✅ Created agent 'deployment-automation' in .claude/agents/deployment-automation.md

Usage: @deployment-automation {task description}

The agent specializes in deployment automation.
```

For commands:
```
✅ Created command 'run-tests' in .claude/commands/run-tests.md

Usage: /run-tests

The command is available as a slash command.
```

For hooks:
```
✅ Created hook 'pre-commit-validation' in .claude/hooks/

Files: hooks.json (updated), pre-commit-validation.sh (executable)

The hook will trigger automatically.
```

## Key Principles

- **Clear parsing** - Extract type, domain, name accurately
- **Domain-aware** - Generate content that demonstrates deep understanding of the domain
- **Fail gracefully** - Provide helpful error messages with actionable guidance
- **Confirm understanding** - List what will be created before writing, ask if ambiguous
- **File safety** - Check if files exist, offer overwrite option
- **Helpful output** - Show files created, suggest next steps
- **Template-driven** - Use templates for structure, Claude for domain content
- **Educational** - Show progression from simple to production-ready
- **Practical** - Examples should be realistic and immediately useful
- **Validate early** - Check all prerequisites before writing files
