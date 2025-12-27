# Plugin Builder

Scaffold Claude Code components (skills, agents, commands, hooks) through natural language commands.

## Overview

The Plugin Builder makes it easy to create project-specific Claude Code components without writing boilerplate. Simply describe what you want in natural language, and it generates well-structured, documented, educational examples.

**What it creates:**
- **Skills**: Auto-invoked capabilities for domain-specific expertise
- **Agents**: Specialized subagents for focused tasks
- **Commands**: Custom slash commands
- **Hooks**: Event handlers for automation

**Where it creates them:**
All components are created in your project's `.claude/` directory, making them immediately available for use.

## Installation

```bash
# From your project directory
/plugin add astrosteveo-plugins/plugin-builder
```

Or install from local directory:
```bash
claude-code --plugin-dir /path/to/plugin-builder
```

## Usage

### Basic Syntax

```
/plugin-builder:create-plugin {natural language description}
```

### Examples

#### Create a Skill

```
/plugin-builder:create-plugin create a skill for code quality review
```

**Generated:**
```
.claude/skills/code-quality-review/
├── SKILL.md              # Main skill definition
└── examples/
    ├── simple.md         # Basic linting checklist
    ├── advanced.md       # Code smell detection
    └── production.md     # Full review workflow
```

#### Create an Agent

```
/plugin-builder:create-plugin create an agent for deployment automation
```

**Generated:**
```
.claude/agents/deployment-automation.md
```

#### Create a Command

```
/plugin-builder:create-plugin create a command to run tests
```

**Generated:**
```
.claude/commands/run-tests.md
```

#### Create a Hook

```
/plugin-builder:create-plugin create a hook for pre-commit validation
```

**Generated:**
```
.claude/hooks/
├── hooks.json              # Updated with new hook
└── pre-commit-validation.sh
```

## How It Works

1. **Parse**: Extract component type, domain, and name from your description
2. **Template**: Select appropriate base template
3. **Customize**: Generate domain-specific examples using Claude's knowledge
4. **Create**: Write files to `.claude/` directory

## Educational Features

Each generated component includes:
- **Multiple approaches**: Simple, advanced, and production-ready examples
- **Inline comments**: Explaining why patterns are used, not just what
- **Best practices**: Idiomatic Claude Code patterns
- **Domain-specific examples**: Tailored to your use case

## Template Customization

Templates are stored in `templates/` directory and can be customized:

```
plugin-builder/templates/
├── skill/
│   ├── base.md           # Main skill template
│   └── examples/
│       ├── simple.md
│       ├── advanced.md
│       └── production.md
├── agent/
│   └── base.md
├── command/
│   └── base.md
└── hook/
    ├── hooks.json
    └── example-hook.sh
```

**Template variables:**
- `{{NAME}}` - Slugified component name
- `{{DISPLAY_NAME}}` - Human-readable name
- `{{DESCRIPTION}}` - Brief description
- `{{DOMAIN}}` - Domain/purpose
- `{{DOMAIN_INTRO}}` - Generated domain introduction
- `{{WHEN_TO_USE}}` - Usage criteria
- `{{PROCESS_STEPS}}` - Step-by-step process
- `{{KEY_PRINCIPLES}}` - Best practices

## Component Types

### Skills
- **Purpose**: Auto-invoked domain expertise
- **When to use**: Recurring tasks, specialized knowledge
- **Location**: `.claude/skills/{name}/`

### Agents
- **Purpose**: Specialized subagents for deep dives
- **When to use**: Parallel execution, context isolation
- **Location**: `.claude/agents/{name}.md`

### Commands
- **Purpose**: Custom slash commands
- **When to use**: Explicit user-triggered actions
- **Location**: `.claude/commands/{name}.md`

### Hooks
- **Purpose**: Event-driven automation
- **When to use**: Validation, enforcement, auto-actions
- **Location**: `.claude/hooks/`

## Troubleshooting

### Component Already Exists

```
Component 'code-review' already exists. Overwrite? (yes/no)
```

Choose `yes` to replace or `no` to cancel and use a different name.

### Ambiguous Input

```
What type of component would you like to create?
1. Skill - Auto-invoked capability
2. Agent - Specialized subagent
3. Command - Slash command
4. Hook - Event handler
```

The plugin will ask for clarification if your intent isn't clear.

### Invalid Component Type

```
Unknown component type 'widget'. Valid types: skill, agent, command, hook
```

Use one of the supported component types.

## Examples

See [EXAMPLES.md](EXAMPLES.md) for comprehensive usage examples.

## Contributing

Contributions welcome! Areas for improvement:
- Additional template variations
- More domain-specific examples
- Enhanced NL parsing
- Custom template support

## License

MIT License - See LICENSE file for details.

## Author

Created by astrosteveo
