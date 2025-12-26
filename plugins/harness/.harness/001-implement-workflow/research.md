# Research: Claude Code Plugin Best Practices

## Plugin System Overview

Claude Code plugins extend functionality through:
- **Commands** - User-invokable slash commands
- **Skills** - Reusable workflow modules
- **Agents** - Named personas for subagent work
- **Hooks** - Lifecycle event handlers

## Best Practices (from existing plugins)

### Command Design
1. **Keep commands thin** - Delegate to skills
2. **Use `disable-model-invocation: true`** - Prevents AI from improvising
3. **Descriptive help text** - Users see this in `/help`
4. **One action per command** - Focused responsibility

### Skill Design
1. **Explicit instructions** - No room for interpretation
2. **Socratic method** - Guide through questions, not dictation
3. **Incremental validation** - Seek feedback on sections
4. **Reference other skills** - Use `@skill-name` syntax
5. **One responsibility per skill** - Don't overload

### Agent Design
1. **Clear persona** - Define role explicitly
2. **Explicit responsibilities** - List what agent does
3. **Quality gates** - Define what's required before completion
4. **Communication protocol** - How agent reports back

### Hook Usage
1. **SessionStart for context injection** - Common pattern
2. **Return valid JSON** - Required format
3. **Cross-platform scripts** - Use polyglot run-hook.cmd pattern

## Workflow Patterns (from research)

### Phase-Based Development
The harness workflow follows: Define → Research → Plan → Execute → Verify

Similar to:
- agent-workflow: Brainstorm → Plan → Execute
- explore-plan-implement-commit: Discover → Code → Review

### Artifact Management
Best practice from existing plugins:
- Numbered task directories: `001-feature-name/`
- Consistent artifact names: requirements.md, design.md, plan.md
- Project-level backlog: `backlog.md`

### TDD Integration
Both existing plugins emphasize:
- Write failing test first
- Watch it fail correctly
- Implement minimal code
- Verify it passes
- Commit atomically

### Subagent Coordination
Pattern from agent-workflow:
- Fresh subagent per task (no context pollution)
- Two-stage review: spec compliance → code quality
- Clear handoff protocols

## Implementation Recommendations

### For Harness Plugin:

1. **5 Commands** mapping to 5 phases:
   - `/define` → `defining` skill
   - `/research` → `researching` skill
   - `/plan` → `planning` skill
   - `/execute` → `executing` skill
   - `/verify` → `verifying` skill

2. **5 Core Skills** with detailed process:
   - Each skill = one phase's complete workflow
   - Socratic questioning built into Define and Plan
   - TDD enforcement in Execute
   - Rigorous validation in Verify

3. **1-2 Agents** for specialized work:
   - `verifier.md` - Peer review simulation
   - Consider: `researcher.md` for codebase exploration

4. **SessionStart Hook** to:
   - Inject workflow awareness
   - Load any active task context

5. **Artifact Structure** per WORKFLOW.md:
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

## Open Considerations

1. **Skill chaining** - How do skills transition? Explicit offer or automatic?
2. **Lightweight mode** - Skip artifacts for trivial tasks. Separate skill or flag?
3. **Spike handling** - Different directory pattern, simplified artifacts
4. **Context persistence** - How to resume tasks across sessions?
