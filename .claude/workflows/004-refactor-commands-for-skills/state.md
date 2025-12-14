# Workflow State

**Feature**: Refactor `/epic:*` commands now that skills drive each phase
**Slug**: 004-refactor-commands-for-skills
**Directory**: .claude/workflows/004-refactor-commands-for-skills
**Current Phase**: implement
**Research Scope**: codebase only
**Last Updated**: 2025-12-14

## Background Agents

| Agent | Task ID | Status |
|-------|---------|--------|
| codebase-explorer | a0fe6d2 | complete (corrected) |
| codebase-explorer | a19dabc | complete |

## Phase Status

| Phase | Status | Artifact |
|-------|--------|----------|
| Explore | complete | codebase-research.md |
| Plan | complete | plan.md |
| Implement | complete | (state.md) |
| Validate | complete | validation.md |
| Commit | pending | git commit |

## Context

This refactoring is about clarifying the relationship between:
- **Commands** (`/epic:explore`, `/epic:plan`, etc.) - User-invoked slash commands
- **Skills** (`epic-explore`, `epic-plan`, etc.) - Skills that can be invoked by the Skill tool

The question: Now that skills exist for each workflow phase, how should commands and skills relate? Are they duplicating logic? Should one invoke the other?
