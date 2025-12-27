# Research: Plugin Builder

## Best Practices

### Plugin Development (from Official Documentation)

**Source**: [Claude Code Plugin Documentation](https://code.claude.com/docs/en/plugins)

1. **Testing During Development**:
   - Use `--plugin-dir` flag to test plugins without installation
   - Iterate quickly on plugin structure and functionality
   - Example: `claude-code --plugin-dir ./my-plugin`

2. **Slash Command Naming**:
   - Filename becomes command name
   - Namespaced with plugin name: `/{plugin-name}:{command-name}`
   - Keep names concise and descriptive

3. **Plugin Manifest (`plugin.json`)**:
   - Required fields: `name`, `description`, `author`
   - Optional fields: `license`, `keywords`, `homepage`
   - Keywords improve discoverability

4. **Distribution**:
   - Plugins installable with `/plugin` command
   - Work across terminal and VS Code
   - Can be shared via Git repositories

### Skills vs Hooks vs Subagents

**Source**: [Understanding Claude Code's Full Stack](https://alexop.dev/posts/understanding-claude-code-full-stack/)

**When to use Skills**:
- Domain-specific capabilities that Claude should activate automatically
- Specialized prompt templates for recurring tasks
- Best for: Auto-invoked expertise based on conversation context

**When to use Hooks**:
- Automatic enforcement of standards or quality gates
- Event-driven reactions to tool usage
- Best for: Validation, workflow enforcement, session initialization

**When to use Subagents**:
- Parallel execution of independent tasks
- Isolating heavy computational work
- Specialized deep dives without context pollution
- Best for: Keeping main context minimal, parallelization

### Plugin Structure Best Practices

**Source**: [Plugin Structure Guide](https://claude-plugins.dev/skills/@anthropics/claude-plugins-official/plugin-structure)

1. **Auto-discovery**:
   - Components are auto-discovered based on directory structure
   - No manual registration required
   - Follow conventions exactly for automatic loading

2. **SKILL.md Requirements**:
   - Must have YAML frontmatter with `name` and `description`
   - Name should match directory name
   - Description drives auto-invocation logic

3. **Hook Events**:
   - `SessionStart`: Fires when session begins (startup, resume, clear, compact)
   - `PreToolUse`: Before tool execution (can block with exit code 2)
   - `PostToolUse`: After tool execution (for cleanup or logging)

4. **Environment Variables**:
   - `${CLAUDE_PLUGIN_ROOT}`: Absolute path to plugin directory
   - Use for referencing scripts within plugin
   - Critical for cross-platform compatibility

## API/Library Documentation

### Hook JSON Input Format (PreToolUse)

**Research finding**: Hooks receive JSON via stdin with this structure:

```json
{
  "tool_name": "Edit",
  "tool_input": {
    "file_path": "/path/to/file.ext",
    "old_string": "...",
    "new_string": "..."
  },
  "conversation_context": {...}
}
```

**Usage pattern**:
```bash
#!/bin/bash
INPUT=$(cat)  # Read from stdin
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')
```

**Critical**: Do NOT use environment variables for tool parameters - they're not set!

### Skill Description Guidelines

**Research finding**: Skill descriptions should be:
- **Action-oriented**: "Use this when..." not "This skill does..."
- **Explicit**: Clear triggering criteria
- **Example from harness**: "You MUST use this when the user wants to start any work - building, fixing, refactoring..."

**Anti-pattern**: Vague descriptions like "Helps with project management"
**Good pattern**: "Use after research is approved. Creates architecture design through Socratic dialogue."

### Testing Patterns

**Research finding**: Bash-based testing with simple assertions

```bash
# Test helper pattern
assert_success() {
  local command="$1"
  local description="$2"
  if eval "$command" &>/dev/null; then
    pass "$description"
  else
    fail "$description"
  fi
}

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local description="$3"
  if [[ "$haystack" == *"$needle"* ]]; then
    pass "$description"
  else
    fail "$description: '$needle' not found"
  fi
}
```

## Security Considerations

### Hook Script Execution

**Risk**: Hooks execute arbitrary bash scripts
**Mitigation**:
- Validate hook script paths before execution
- Use `set -euo pipefail` for fail-fast behavior
- Never trust user input in hook scripts
- Sanitize any data passed to shell commands

### JSON Parsing

**Risk**: Malformed JSON or injection attacks
**Mitigation**:
- Always use `jq` for JSON parsing (never eval)
- Provide defaults: `jq -r '.field // "default"'`
- Validate JSON before processing

### File Path Handling

**Risk**: Path traversal attacks in generated plugins
**Mitigation**:
- Validate file paths are within expected directories
- Use absolute paths when referencing plugin resources
- Avoid constructing paths from user input without validation

## Performance Considerations

### Skill Loading

**Consideration**: Skills are loaded at session start
**Impact**: Large skill files can slow session initialization
**Best Practice**:
- Keep skill content focused and concise
- Use includes/references for large documentation
- Skill content should be < 5KB for fast loading

### Hook Execution

**Consideration**: Hooks block tool execution
**Impact**: Slow hooks delay every matching tool call
**Best Practice**:
- Keep hook scripts < 100ms execution time
- Avoid network calls in hooks
- Cache expensive computations
- Use background processes for non-blocking work

### Template Generation

**Consideration**: Generating many files at once
**Impact**: Large plugins take time to scaffold
**Best Practice**:
- Generate templates lazily (basic first, advanced on demand)
- Provide progress feedback for long operations
- Allow cancellation for large scaffolding operations

## Implementation Recommendations

Based on research, here are recommended approaches for the plugin builder:

### 1. Template Storage Strategy

**Option A: Embedded Templates**
- Store templates as strings/heredocs in the plugin code
- Pros: Single file distribution, no external dependencies
- Cons: Harder to maintain, templates not easily editable

**Option B: Template Files**
- Store templates in `templates/` directory
- Use variable substitution (e.g., `{{PLUGIN_NAME}}`)
- Pros: Easy to edit and maintain, clear separation
- Cons: More files to distribute

**Recommendation**: Option B - Template files with variable substitution

### 2. Scaffolding Approach

**Interactive prompts using AskUserQuestion**:
1. Plugin name
2. Plugin type (basic, skill-focused, hook-based, workflow, subagent, custom-subagent)
3. Author information
4. Additional features (tests, examples, documentation level)

**Generation strategy**:
1. Create base directory structure
2. Generate plugin.json with user inputs
3. Copy template files for selected type
4. Perform variable substitution
5. Make scripts executable
6. Generate README with usage instructions

### 3. Variable Substitution Pattern

**Template markers**:
```markdown
{{PLUGIN_NAME}} - Plugin name
{{PLUGIN_DESCRIPTION}} - Plugin description
{{AUTHOR_NAME}} - Author name
{{AUTHOR_EMAIL}} - Author email
{{TIMESTAMP}} - Generation timestamp
{{YEAR}} - Current year
```

**Substitution implementation**:
```bash
sed -e "s/{{PLUGIN_NAME}}/$plugin_name/g" \
    -e "s/{{AUTHOR_NAME}}/$author_name/g" \
    template.md > output.md
```

### 4. Educational Content Strategy

**Multiple approaches pattern**:
```markdown
## Approach 1: Simple Pattern (Recommended for Beginners)
{Simple implementation}

## Approach 2: Advanced Pattern
{Advanced implementation with more features}

## Approach 3: Production Pattern
{Enterprise-grade implementation}
```

**Why teach multiple approaches**:
- Demonstrates evolution from simple to complex
- Helps developers understand trade-offs
- Enables experimentation and learning
- Shows "good, better, best" progression

## Documentation Sources

- [Create plugins - Claude Code Docs](https://code.claude.com/docs/en/plugins)
- [Agent Skills - Claude Code Docs](https://code.claude.com/docs/en/skills)
- [Understanding Claude Code's Full Stack](https://alexop.dev/posts/understanding-claude-code-full-stack/)
- [Building My First Claude Code Plugin](https://alexop.dev/posts/building-my-first-claude-code-plugin/)
- [Plugin Structure Guide](https://claude-plugins.dev/skills/@anthropics/claude-plugins-official/plugin-structure)
- [Official Plugins Repository](https://github.com/anthropics/claude-code/tree/main/plugins)
