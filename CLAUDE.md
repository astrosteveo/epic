# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Claude Code marketplace plugin implementing the "Frequent Intentional Compaction" workflow for effective AI-assisted development in complex codebases. The plugin provides structured phases: **Explore → Plan → Implement → Validate → Commit**, with artifact documentation at each stage.

## Plugin Structure

```
├── .claude-plugin/plugin.json    # Plugin manifest defining entry points
├── agents/                       # Specialized subagent definitions
│   ├── codebase-explorer.md      # Maps codebase structure (facts only)
│   ├── docs-researcher.md        # Researches external documentation
│   ├── plan-validator.md         # Validates plans before implementation
│   └── implementation-validator.md
├── commands/                     # Slash command definitions
│   ├── explore.md                # /explore - Launch research agents
│   ├── plan.md                   # /plan - Create implementation plan
│   ├── implement.md              # /implement - Execute plan phase-by-phase
│   ├── validate.md               # /validate - Run tests/lint/build
│   └── commit.md                 # /commit - Create documented commit
├── templates/                    # Artifact templates
│   ├── codebase.md, docs.md      # Research output templates
│   ├── implementation-plan.md    # Plan structure template
│   ├── progress.md               # Implementation progress template
│   └── state.md                  # Workflow state tracker
└── skills/                       # Interactive skills
```

## Commands

| Command | Purpose |
|---------|---------|
| `/explore <feature>` | Launch research agents, creates `.claude/workflows/NNN-slug/research/` |
| `/plan` | Create phased implementation plan from research |
| `/implement [--phase N] [--continue]` | Execute plan phase-by-phase with verification |
| `/validate [--fix]` | Run tests, lint, type check, build |
| `/commit` | Create commit with workflow artifacts |

## Agents

- **codebase-explorer**: Maps relevant files with `file:line` references. Documents facts only—no suggestions or critique. Uses Grep/Glob/Read efficiently.
- **docs-researcher**: Fetches current external documentation. Only launched when feature involves external libraries, security, or unfamiliar technology.
- **plan-validator**: Reviews implementation plans for completeness and feasibility.
- **implementation-validator**: Verifies code changes align with approved plan.

## Workflow Artifacts

All artifacts are stored in `.claude/workflows/NNN-slug/`:
```
.claude/workflows/001-add-authentication/
├── state.md                    # Current phase, task IDs, status
├── research/
│   ├── codebase.md            # Internal codebase findings
│   └── docs.md                # External documentation (if researched)
├── plans/
│   └── implementation-plan.md # Phased plan with verification steps
├── implementation/
│   └── progress.md            # Phase completion tracking
└── validation/
    └── results.md             # Test/lint/build results
```

## Core Workflow Principles (from VISION.md)

### The Three Phases

1. **RESEARCH**: Launch subagents in parallel, one exploring the codebase and the other researching latest documentation, library, framework, and versions and coding standards and best practices. Output structured documents with `file:line` references. The sole purpose is to document facts gathered from the research performed, NOT to propose changes or critique the current codebase.

2. **PLAN**: Read research first. Break work into phases with verification steps. Each phase needs: specific changes + automated checks + manual checks. The plan must be approved by a human before implementation. Do NOT make assumptions off training data - the research performed in phase 1 is the SINGLE source of truth.

3. **IMPLEMENT**: Read the plan. Execute one phase at a time. Run verification after each phase. If reality ≠ plan: STOP and communicate.

### Context Management Rules

- Keep context utilization at 40-60%
- Compact when: context > 60%, switching tasks, session ending, or major phase complete
- Avoid context bloat from excessive grep/glob/read — use subagents instead
- Summarize build/test output to errors only

**Context Reporting**:
When completing workflow phases, report estimated context utilization:
- Format: `**Context**: ~[X]K / 200K tokens ([Y]%)`
- Warn users when approaching 60% threshold
- Recommend compaction at 80%+ utilization

### The Leverage Hierarchy

```
Error in Research → 1000s of bad lines of code
Error in Plan     → 100s of bad lines of code
Error in Code     → ~1 bad line of code
```

Human review should focus on Research > Plan > Code.

## Installation

```bash
claude --plugin-dir /path/to/explore-plan-implement
```

## Key Design Goals

- Works in brownfield (large existing) codebases as well as greenfield (new projects)
- Solves complex multi-file problems
- No slop (passes expert review)
- Focused around professional developer workflows, NOT **vibe coding**
- NEVER make assumptions based on training data; ALWAYS rely on documented research or clarify ambiguities with humans
