# Agile Workflow Plugin for Claude Code

A Claude Code plugin that enforces AGILE-style project management workflows optimized for LLM context limitations.

## Philosophy

AGILE methodology and LLM context limitations share the same solution: **break work into small, focused chunks**.

- LLM performance degrades at ~40% context, seriously at ~60%, breaks at ~80%
- AGILE breaks work into epics → stories for the same reason humans can't hold large projects in their heads
- This plugin enforces a workflow that keeps context minimal and work well-scoped

## Features

- **Single command**: `/agile-workflow:workflow` handles everything
- **PRD-first**: No exploration without requirements
- **Plan-first**: No implementation without a plan
- **Git-integrated**: Automatic commits at workflow milestones
- **Context-optimized**: State in JSON for LLM parsing, docs in Markdown for humans

## Usage

```bash
# Start a new project or continue existing workflow
/agile-workflow:workflow

# Add a new feature idea
/agile-workflow:workflow I want to add user authentication

# Explicitly run a phase
/agile-workflow:workflow explore user-auth
/agile-workflow:workflow plan user-auth
/agile-workflow:workflow implement user-auth
```

## Workflow

```
PRD exists? → Explore → Plan exists? → Implement
     ↓            ↓           ↓            ↓
   Gate        Research     Gate         Code
              doc created  Plan doc    + Commits
                            created
```

### Gates

| Gate | Prevents |
|------|----------|
| No PRD → No Explore | Aimless research without direction |
| No Plan → No Implement | Coding without thinking |

## Artifacts

All workflow artifacts live in `.claude/workflow/`:

```
.claude/workflow/
├── PRD.md              # Requirements and epic overview
├── state.json          # Machine-readable project state
└── epics/
    └── [epic-slug]/
        ├── research.md # Exploration findings
        └── plan.md     # Implementation plan
```

## Agents

| Agent | Phase | Purpose |
|-------|-------|---------|
| Discovery | PRD creation | Extract requirements through conversation |
| Explore | Research | Survey codebase, document with file:line refs |
| Plan | Design | Break epic into stories, estimate effort |
| Implement | Execution | Execute stories, commit after each |

## Effort Points

Stories use Fibonacci points: 1, 2, 3, 5, 8, 13

Epic effort = sum of story points, normalized to nearest Fibonacci.

Signal: 13+ means break it down further.

## License

MIT
