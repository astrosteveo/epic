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
│   ├── commit.md                 # /commit - Create documented commit
│   ├── handoff.md                # /handoff - Create session handoff document
│   └── resume.md                 # /resume - Resume from handoff or workflow
├── templates/                    # Artifact templates
│   ├── codebase.md, docs.md      # Research output templates
│   ├── implementation-plan.md    # Plan structure template
│   ├── state.md                  # Workflow state + progress tracker
│   └── handoff.md                # Handoff document template
└── skills/                       # Workflow skills (contain full logic)
    ├── epic-explore/SKILL.md     # Research phase logic
    ├── epic-plan/SKILL.md        # Planning phase logic
    ├── epic-implement/SKILL.md   # Implementation phase logic
    ├── epic-validate/SKILL.md    # Validation phase logic
    ├── epic-commit/SKILL.md      # Commit phase logic
    ├── epic-handoff/SKILL.md     # Handoff creation logic
    └── epic-resume/SKILL.md      # Session resume logic
```

## Commands

Commands are thin entry-point wrappers that invoke skills. The workflow logic lives in skills.

| Command | Invokes Skill | Purpose |
|---------|---------------|---------|
| `/epic:explore <feature>` | `epic:epic-explore` | Launch research agents |
| `/epic:plan` | `epic:epic-plan` | Create implementation plan |
| `/epic:implement [--phase N]` | `epic:epic-implement` | Execute plan phase-by-phase |
| `/epic:validate [--fix]` | `epic:epic-validate` | Run tests/lint/build |
| `/epic:commit [--amend]` | `epic:epic-commit` | Create documented commit |
| `/epic:handoff [desc]` | `epic:epic-handoff` | Create session handoff |
| `/epic:resume [path]` | `epic:epic-resume` | Resume from handoff/workflow |

**Architecture**: Commands handle entry point and argument parsing. Skills handle full workflow logic, tool execution, and artifact creation.

## Agents

- **codebase-explorer**: Maps relevant files with `file:line` references. Documents facts only—no suggestions or critique. Uses Grep/Glob/Read efficiently.
- **docs-researcher**: Fetches current external documentation. Only launched when feature involves external libraries, security, or unfamiliar technology.
- **plan-validator**: Reviews implementation plans for completeness and feasibility.
- **implementation-validator**: Verifies code changes align with approved plan.

## Workflow Artifacts

All artifacts are stored in `.claude/workflows/NNN-slug/` (flat structure):
```
.claude/workflows/001-add-authentication/
├── state.md                    # Current phase, task IDs, status, progress tracking
├── codebase-research.md        # Internal codebase findings
├── docs-research.md            # External documentation (if researched)
├── plan.md                     # Phased plan with verification steps
└── validation.md               # Test/lint/build results
```

Handoff documents are stored separately in `.claude/handoffs/NNN-slug/`:
```
.claude/handoffs/001-add-authentication/
└── 2025-01-15_14-30-22_phase2-complete.md
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
