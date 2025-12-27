# Codebase Analysis: Plugin Builder

## Relevant Files

### Harness Plugin (Reference Implementation)

| Path | Purpose | Notes |
|------|---------|-------|
| `plugins/harness/.claude-plugin/plugin.json` | Plugin metadata | Name, description, author, keywords |
| `plugins/harness/skills/*/SKILL.md` | Skill definitions | YAML frontmatter + markdown content |
| `plugins/harness/hooks/hooks.json` | Hook configuration | SessionStart, PreToolUse hook definitions |
| `plugins/harness/hooks/session-start.sh` | Hook script | Injects skill content at session start |
| `plugins/harness/hooks/run-hook.cmd` | Cross-platform wrapper | Polyglot bash/cmd wrapper for hooks |
| `plugins/harness/commands/*.md` | Slash commands | Simple markdown with frontmatter |
| `plugins/harness/agents/verifier.md` | Agent definition | Markdown with YAML frontmatter |
| `plugins/harness/scripts/gate-*.sh` | Gate scripts | PreToolUse hook validation scripts |
| `plugins/harness/tests/*.sh` | Test suite | Bash-based testing with assertions |

### Marketplace Structure

| Path | Purpose | Notes |
|------|---------|-------|
| `.claude-plugin/marketplace.json` | Marketplace metadata | Collection-level metadata, plugin registry |

## Existing Patterns

### Plugin Directory Structure

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json              # Required: Plugin manifest
├── commands/                     # Slash commands
│   └── command-name.md          # Filename = command name
├── agents/                       # Subagent definitions
│   └── agent-name.md            # YAML frontmatter + instructions
├── skills/                       # Agent skills (auto-discovery)
│   └── skill-name/
│       ├── SKILL.md             # Required: YAML frontmatter + content
│       └── examples/            # Optional: Usage examples
├── hooks/
│   ├── hooks.json               # Hook configuration
│   └── *.sh                     # Hook scripts (bash)
├── scripts/                      # Helper scripts
│   └── *.sh                     # Utility and gate scripts
├── tests/                        # Test suite
│   ├── test-helpers.sh          # Test utilities
│   └── test-*.sh                # Test files
├── README.md                     # Documentation
└── QUICKSTART.md                # Optional: Getting started guide
```

### Skill Pattern (SKILL.md)

```markdown
---
name: skill-name
description: "Concise description of what the skill does"
---

# Skill Name

{Detailed skill content in markdown}
```

**Key observations:**
- Skills are auto-discovered from `skills/*/SKILL.md` paths
- YAML frontmatter must include `name` and `description`
- Description should be action-oriented and clear about when to use
- Content can include detailed instructions, examples, checklists

### Command Pattern (*.md)

```markdown
---
description: Brief command description
disable-model-invocation: true  # Optional: Prevent auto-execution
---

{Command instructions}
```

**Key observations:**
- Filename becomes the command name (e.g., `define.md` → `/plugin:define`)
- Commands can invoke skills or provide direct instructions
- `disable-model-invocation: true` prevents immediate execution

### Hook Pattern (hooks.json)

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume|clear|compact",
        "hooks": [{"type": "command", "command": "script.sh"}]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [{"type": "command", "command": "script.sh"}]
      }
    ]
  }
}
```

**Key observations:**
- Hook types: `SessionStart`, `PreToolUse`, `PostToolUse`
- Matchers: Regex patterns for when to trigger
- Scripts receive JSON via stdin (for PreToolUse)
- Environment variables: `${CLAUDE_PLUGIN_ROOT}` for plugin path

### Agent Pattern (*.md)

```markdown
---
name: agent-name
description: |
  Multiline description
  of agent's purpose
---

# Agent Name

{Instructions for the subagent}
```

**Key observations:**
- Agents are specialized subagents with focused roles
- Content defines the agent's instructions and behavior
- Can reference other skills or provide custom workflows

## Git History

Key commits showing plugin evolution:

| Commit | Author | Summary | Insights |
|--------|--------|---------|----------|
| 176bdf6 | astrosteveo | feat(harness): implement 5-phase workflow plugin | Initial plugin creation |
| 0778c20 | astrosteveo | feat(harness): add hook-based gates for workflow enforcement | Hooks for validation |
| 55fba20 | astrosteveo | enhance(harness): improve intent detection, hook robustness, and onboarding | SessionStart hooks for skill injection |
| 98c3cbf | astrosteveo | feat(harness): improve skill triggering and add AskUserQuestion guidance | Enhanced skill descriptions |
| e7006d8 | astrosteveo | fix(harness): use stdin JSON parsing for PreToolUse hooks | PreToolUse hooks receive JSON via stdin |
| 6d7debf | astrosteveo | refactor(harness): limit subagent dispatch to execute phase only | Subagent orchestration patterns |

**Evolution pattern:**
1. Start with basic plugin structure (plugin.json, skills)
2. Add hooks for workflow enforcement
3. Refine skill descriptions for better triggering
4. Debug hook JSON parsing (critical learning!)
5. Add testing infrastructure
6. Iterate on patterns based on usage

## Testing Infrastructure

### Test Framework

**Pattern**: Bash scripts with custom assertion helpers

```bash
# Test structure from test-hook.sh
source "${SCRIPT_DIR}/test-helpers.sh"

start_suite "Suite Name"
assert_file_exists "$file" "Description"
assert_success "command" "Description"
assert_contains "$output" "substring" "Description"
assert_valid_json "$output" "Description"
print_summary
```

**Test helpers** (`tests/test-helpers.sh`):
- Color output for pass/fail
- Assertion functions (assert_success, assert_contains, assert_valid_json)
- Test suite organization (start_suite, print_summary)
- File operations (get_plugin_root, temp file handling)

**Coverage areas:**
- Hook script execution and JSON output
- Intent detection patterns
- Special character escaping in JSON
- Error handling (missing files, invalid JSON)

### Testing Philosophy

- **Functional tests**: Verify hooks run and produce valid output
- **Integration tests**: Test skill triggering and command execution
- **Pattern tests**: Validate intent detection regex patterns
- **No mocking**: Test with real files and scripts

## Technical Dependencies

### Required

- **bash**: Hook scripts, gate scripts, test suite
- **jq**: JSON parsing in hooks and scripts
- **git**: Repository operations (not strictly required but expected)

### Optional

- **tree**: For visualization (falls back to find)
- **Node.js/Python/etc.**: Depending on plugin functionality

### Claude Code Integration

- **Environment variables**:
  - `${CLAUDE_PLUGIN_ROOT}`: Path to plugin directory
  - `PWD`: Current working directory (project root)
  - `CLAUDE_CODE_ENTRYPOINT`: Entry point (e.g., "claude-vscode")
  - `CLAUDE_AGENT_SDK_VERSION`: SDK version

- **Current directory assumption**: Plugins assume `PWD` is the project directory
- **No explicit CLAUDE_PROJECT_DIR**: Use `PWD` or `.` for project root

## Key Insights for Plugin Builder

1. **Standardized structure is crucial**: Plugin discovery relies on conventional directory layout
2. **YAML frontmatter matters**: Skills and commands need proper frontmatter for discovery
3. **Hook stdin pattern**: PreToolUse hooks receive JSON via stdin, not env vars (common mistake!)
4. **Cross-platform considerations**: Use polyglot scripts (run-hook.cmd) for Windows compatibility
5. **Testing is bash-based**: Simple assertion-based testing with bash scripts
6. **Skill descriptions drive triggering**: Clear, action-oriented descriptions help auto-invocation
7. **Educational examples**: Harness plugin serves as excellent reference implementation
