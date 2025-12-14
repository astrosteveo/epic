# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Claude Code marketplace plugin implementing the "Frequent Intentional Compaction" workflow for effective AI-assisted development in complex codebases. The plugin provides structured phases: **Explore → Plan → Implement → Validate → Commit**, with artifact documentation at each stage.

## Plugin Structure

```
├── .claude-plugin
│   └── plugin.json
├── agents/
├── commands/
├── hooks/
└── skills/
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

## Development

The plugin manifest at `.claude-plugin/plugin.json` defines the entry points for agents, commands, and skills directories which need to be created and populated.

## Key Design Goals

- Works in brownfield (large existing) codebases as well as greenfield (new projects)
- Solves complex multi-file problems
- No slop (passes expert review)
- Focused around professional developer workflows, NOT **vibe coding**
- NEVER make assumptions based on training data; ALWAYS rely on documented research or clarify ambiguities with humans
