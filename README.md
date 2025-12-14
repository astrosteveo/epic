# Explore-Plan-Implement Plugin

A Claude Code plugin implementing the **Frequent Intentional Compaction** workflow for effective AI-assisted development in complex codebases.

## Overview

This plugin provides a structured workflow that keeps context utilization optimal (40-60%) while maintaining high-quality outputs through deliberate phase separation and artifact documentation.

## The Workflow

```
/explore → /plan → /implement → /validate → /commit
```

### 1. Explore (`/explore [feature-description]`)
Launches parallel subagents to:
- **Codebase exploration**: Understand relevant files, code flow, patterns
- **External research**: Latest docs, best practices, library versions

Output: `docs/NNN-feature-slug/research/`

### 2. Plan (`/plan`)
Creates a phased implementation plan based on research:
- Specific changes per phase
- Automated verification steps
- Manual verification checkpoints

Output: `docs/NNN-feature-slug/plans/`

### 3. Implement (`/implement`)
Executes the plan phase-by-phase:
- One phase at a time
- Verification after each phase
- STOPS if reality diverges from plan

Output: `docs/NNN-feature-slug/implementation/`

### 4. Validate (`/validate`)
Auto-detects and runs project validation:
- Tests (npm/cargo/pytest/etc.)
- Linting
- Type checking
- Build

### 5. Commit (`/commit`)
Creates a well-documented commit with references to artifacts.

## Artifact Structure

```
docs/
└── 001-add-authentication/
    ├── research/
    │   ├── codebase-exploration.md
    │   └── external-research.md
    ├── plans/
    │   └── implementation-plan.md
    ├── implementation/
    │   └── progress.md
    └── validation/
        └── results.md
```

## The Leverage Hierarchy

```
Error in Research → 1000s of bad lines of code
Error in Plan     → 100s of bad lines of code
Error in Code     → ~1 bad line of code
```

Focus your review attention on Research > Plan > Code.

## Installation

```bash
claude --plugin-dir /path/to/explore-plan-implement
```

## Based On

This plugin implements the workflow described in [Frequent Intentional Compaction](./claude/rules/VISION.md) - a methodology for getting AI to work effectively in complex, brownfield codebases.
