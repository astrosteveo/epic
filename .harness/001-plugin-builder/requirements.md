# Requirements: Plugin Builder

## Vision

Create a plugin builder plugin for Claude Code that scaffolds high-quality plugins with best practice examples. Enable developers to rapidly create and experiment with different plugin patterns (skills, hooks, commands, agents, subagents) through a simple slash command interface.

The plugin builder makes it easy to create custom Claude addons by generating well-structured, documented, educational examples that demonstrate multiple approaches to common patterns.

## Functional Requirements

### Core Scaffolding

1. **Slash Command Interface**
   - Use a slash command (e.g., `/create-plugin`) to trigger plugin scaffolding
   - Interactive prompts to gather plugin details (name, type, features)
   - Generate complete plugin structure in one operation

2. **Template Library**
   - **Basic Plugin**: Minimal starter with plugin.json, one simple skill, README
   - **Skill-focused Plugin**: Multiple skills demonstrating different skill patterns
   - **Hook-based Plugin**: Examples of hooks (PreToolUse, PostToolUse, SessionStart, etc.)
   - **Workflow Plugin**: Multi-phase workflow orchestration (inspired by harness pattern)
   - **Subagent Plugin**: Examples of creating and dispatching subagents
   - **Custom Subagent Plugin**: Advanced subagent patterns with custom capabilities

3. **Generated Content**
   Each scaffolded plugin includes:
   - `plugin.json` - Metadata (name, version, description, author, entry points)
   - `README.md` - Plugin overview, installation, usage, development guide
   - Example skills with inline comments explaining patterns
   - Hook examples (if applicable to template) with trigger documentation
   - **Best practice examples showing 2+ different approaches** for key patterns to enable learning and experimentation

4. **Output Location**
   - Default to `$CLAUDE_PROJECT_DIR/.claude/` with appropriate subdirectories:
     - `.claude/agents/` for agent definitions
     - `.claude/skills/` for skill files
     - `.claude/commands/` for custom commands
     - `.claude/hooks/` for hook scripts
   - (Note: Need to verify exact environment variable name in Claude Code)

### Educational Focus

- Generated code should teach plugin development through examples
- Show multiple valid approaches where applicable (e.g., "Approach 1: Simple pattern", "Approach 2: Advanced pattern")
- Include comments explaining *why* patterns are used, not just *what* they do
- Demonstrate idiomatic Claude Code plugin patterns

## Constraints

### Scope Boundaries

- **In scope**: Scaffolding plugin structure and code
- **Out of scope**: Plugin publishing, distribution, versioning, lifecycle management
- **Out of scope**: Plugin testing frameworks (initial version)
- **Out of scope**: Plugin marketplace integration

### Technical Constraints

- Must integrate with Claude Code's plugin system
- Generated plugins must load without errors
- Should work across platforms (macOS, Linux, Windows where Claude Code runs)
- Templates must stay current with Claude Code plugin API

### Dependencies

- Requires knowledge of Claude Code plugin structure
- May need to reference Claude Code documentation for current best practices
- Should align with existing plugin patterns (e.g., harness plugin as reference)

## Success Criteria

### Primary Success Criterion

**A well-written plugin is produced in the user's project directory.**

Specifically:
- ✅ Generated plugin has valid structure (plugin.json, proper file organization)
- ✅ Plugin loads in Claude Code without errors
- ✅ Example code is functional (skills work, hooks trigger correctly)
- ✅ Documentation is complete and helpful
- ✅ Code demonstrates best practices
- ✅ Multiple approaches are shown for educational value

### Validation Tests

1. **Functional Test**: Scaffold each template type, verify it loads in Claude Code
2. **Documentation Test**: README is complete and examples are explained
3. **Educational Test**: Generated code includes comments and multiple approach examples
4. **Structure Test**: Files are organized according to Claude Code conventions

### User Experience Success

- Developer can scaffold a working plugin in < 2 minutes
- Generated code serves as learning material for plugin development
- Easy to modify scaffolded plugin for specific needs
- Clear what each file/pattern does and why it's structured that way
