# Codebase Exploration: Context Window Progress Indicator

**Date**: 2025-12-13
**Feature Slug**: 001-context-window-progress-indicator

## Goal

Document the codebase structure, existing patterns, and integration points relevant to adding a progress indicator that shows context window utilization percentage.

## Summary

This is a Claude Code marketplace plugin implementing the "Frequent Intentional Compaction" workflow. The codebase consists entirely of markdown files defining commands, agents, skills, and templates. The workflow philosophy emphasizes keeping context utilization at 40-60% and compacting when exceeding 60%. There is no existing runtime code or UI components - all functionality is defined declaratively through markdown-based command and agent definitions.

## Relevant Files

| File | Lines | Purpose |
|------|-------|---------|
| `/home/astrosteveo/workspace/research-plan-implement/.claude-plugin/plugin.json` | 1-26 | Plugin manifest defining entry points for agents, commands, and skills |
| `/home/astrosteveo/workspace/research-plan-implement/commands/explore.md` | 1-237 | Explore command with context efficiency guidelines at lines 212-227 |
| `/home/astrosteveo/workspace/research-plan-implement/commands/implement.md` | 1-281 | Implement command with phase-by-phase execution |
| `/home/astrosteveo/workspace/research-plan-implement/commands/plan.md` | 1-230 | Plan command with leverage hierarchy reminder |
| `/home/astrosteveo/workspace/research-plan-implement/CLAUDE.md` | 30-35 | Context management rules specifying 40-60% utilization target |
| `/home/astrosteveo/workspace/research-plan-implement/skills/workflow-guide/SKILL.md` | 89-98 | Context management section explaining utilization targets |
| `/home/astrosteveo/workspace/research-plan-implement/skills/workflow-guide/references/context-engineering.md` | 34-61 | Detailed context utilization guidance and compaction triggers |
| `/home/astrosteveo/workspace/research-plan-implement/skills/command-creator/references/command-patterns.md` | 294-301 | Progress indicator patterns for commands |
| `/home/astrosteveo/workspace/research-plan-implement/templates/state.md` | 1-17 | Workflow state tracking template |
| `/home/astrosteveo/workspace/research-plan-implement/templates/progress.md` | 1-62 | Implementation progress tracking template |

## Code Flow

```
[Plugin Load] → [Command/Agent Selection] → [Workflow Execution] → [Artifact Output]
```

### Detailed Flow

1. **Entry Point**: `/home/astrosteveo/workspace/research-plan-implement/.claude-plugin/plugin.json:1-26` - Plugin manifest declares available commands, agents, and skills directories
2. **Command Invocation**: `/home/astrosteveo/workspace/research-plan-implement/commands/*.md` - Commands define allowed tools, descriptions, and process steps
3. **Agent Execution**: `/home/astrosteveo/workspace/research-plan-implement/agents/*.md` - Agents define subagent configurations with tool restrictions and behavioral prompts
4. **Artifact Output**: `/home/astrosteveo/workspace/research-plan-implement/templates/*.md` - Templates define structure for workflow artifacts written to `.claude/workflows/`

## Architecture Overview

The plugin follows a declarative, markdown-based architecture:

```
.claude-plugin/
└── plugin.json              # Manifest with pointers to:
    ├── agents/              # Subagent definitions (codebase-explorer, docs-researcher, validators)
    ├── commands/            # Slash commands (/explore, /plan, /implement, /validate, /commit)
    └── skills/              # Reusable knowledge/patterns for commands

.claude/
├── rules/
│   └── VISION.md            # Core philosophy and methodology
└── workflows/
    └── NNN-feature-slug/    # Per-feature artifact storage
        ├── research/
        ├── plans/
        ├── implementation/
        └── validation/
```

## Existing Patterns

### Pattern 1: Context Management References
- Location: `/home/astrosteveo/workspace/research-plan-implement/CLAUDE.md:30-35`
- Description: Context rules are embedded as prose guidelines stating "Keep context utilization at 40-60%" and "Compact when: context > 60%"
- Relevance: Any progress indicator would surface these thresholds visually

### Pattern 2: Progress Indicators in Commands
- Location: `/home/astrosteveo/workspace/research-plan-implement/skills/command-creator/references/command-patterns.md:294-301`
- Description: Existing pattern for reporting progress uses checkmarks and arrows: `✓ Step complete`, `→ Step in progress`
- Relevance: Visual progress pattern exists but is step-based, not percentage-based

### Pattern 3: State Tracking via Markdown
- Location: `/home/astrosteveo/workspace/research-plan-implement/templates/state.md:1-17`
- Description: Workflow state tracked in markdown files with phase status tables
- Relevance: Context utilization percentage could be added as a tracked field in state.md

### Pattern 4: Allowed Tools Restrictions
- Location: `/home/astrosteveo/workspace/research-plan-implement/commands/explore.md:5-9`
- Description: Each command specifies `allowed-tools` in YAML frontmatter to constrain agent capabilities
- Relevance: Any tool that reports context utilization would need to be added to allowed-tools lists

## Dependencies

### Internal
- `templates/state.md` depends on workflow directory structure for artifact storage
- `commands/*.md` depend on `templates/*.md` for output structure
- `agents/*.md` depend on `skills/*.md` for behavioral guidance

### External
- Claude Code runtime - provides `Task` tool for subagent execution
- Claude Code plugin system - parses plugin.json and markdown frontmatter
- Claude Code context window - the actual context being measured (not directly accessible via documented APIs)

## Integration Points

- `/home/astrosteveo/workspace/research-plan-implement/CLAUDE.md:32` states the 40-60% target - a progress indicator would need to reference or align with this threshold
- `/home/astrosteveo/workspace/research-plan-implement/commands/explore.md:212-227` "Context Efficiency" section describes guidelines that could trigger indicator warnings
- `/home/astrosteveo/workspace/research-plan-implement/skills/workflow-guide/references/context-engineering.md:56-61` lists compaction triggers including "Context > 60% utilized" - indicator could visualize this threshold
- `/home/astrosteveo/workspace/research-plan-implement/templates/state.md:6-7` tracks "Current Phase" and "Last Updated" - could add "Context Utilization" field

## Constraints & Considerations

- **No runtime code exists**: This plugin is entirely declarative markdown. A context utilization indicator would require either:
  1. External tooling/hooks that Claude Code provides
  2. Estimating context from conversation length (heuristic approach)
  3. Relying on Claude's internal awareness of its context state

- **Plugin system limitations**: The plugin.json format at `/home/astrosteveo/workspace/research-plan-implement/.claude-plugin/plugin.json:1-26` defines only `agents`, `commands`, and `skills` directories. There is no `hooks` directory or UI extension point documented.

- **Context window size**: `/home/astrosteveo/workspace/research-plan-implement/.claude/rules/VISION.md:246` references "approximately 170k of context window" - the actual size depends on the model being used.

- **No hooks directory**: The glob search for `**/hooks/**/*` returned only git hooks, not Claude Code plugin hooks. The hooks directory mentioned in CLAUDE.md may be planned but not yet implemented.

## Open Questions

- [ ] Does Claude Code expose context utilization metrics via any API or tool that plugins can access?
- [ ] Is there a hooks system in the Claude Code plugin architecture that could trigger on context thresholds?
- [ ] Should the indicator be embedded in command output, state.md tracking, or a separate visual element?
- [ ] What is the exact context window size for the models this plugin targets (Haiku for agents, Opus/Sonnet for main)?
- [ ] Can the indicator be purely informational prose, or does it require programmatic access to context metrics?
