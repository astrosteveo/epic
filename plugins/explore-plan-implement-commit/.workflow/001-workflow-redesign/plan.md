# Implementation Plan: Workflow Redesign

## Overview

Restructure the plugin from scattered skills to a clean 4-skill, 3-subagent architecture with intent-based natural language entry.

## Structure

```
skills/
  workflow/       → Entry point, intent detection, phase progression
  discover/       → Codebase mapping + research
  code/           → Implementation + TDD + debugging
  review/         → Code/test/plan validation

agents/
  discoverer.md   → Loads discover skill
  coder.md        → Loads code skill
  reviewer.md     → Loads review skill
```

---

## Tasks

### Phase 1: Cleanup

- [x] Task 1: Delete obsolete skill folders *(committed: 71778f7)*
  - Remove: `brainstorm/`, `codebase-explorer/`, `research/`, `design-writer/`, `plan-writer/`, `implement/`, `commit/`, `code-reviewer/`, `test-reviewer/`, `plan-validator/`
  - Keep: `skills/` directory for new structure

- [x] Task 2: Delete obsolete files *(committed: 71778f7)*
  - Remove: `prompt.md` (old plugin prompt)
  - Remove: `commands/` directory (no slash commands needed)
  - Keep: `agents/` directory for restructure

### Phase 2: Subagent Definitions

- [x] Task 3: Create `agents/discoverer.md` *(committed: f944c19)*
  - Persona: Truth-documenter, researcher
  - Focus: Epistemic humility, no opinions, verify everything
  - Loads: `discover` skill

- [x] Task 4: Create `agents/coder.md` *(committed: f944c19)*
  - Persona: Builder, implementer
  - Focus: TDD, atomic commits, follows specs exactly
  - Loads: `code` skill
  - Includes: Debugging mode when tests fail

- [x] Task 5: Create `agents/reviewer.md` *(committed: f944c19)*
  - Persona: Critical analyst
  - Focus: Quality gates, catching issues, validation
  - Loads: `review` skill

### Phase 3: Skills

- [x] Task 6: Create `skills/discover/SKILL.md` *(committed: c70c1df)*
  - Codebase mapping: document what exists with file:line refs
  - Research: fetch from authoritative sources, verify everything
  - Outputs: `codebase.md`, `research.md`
  - Commit after each artifact

- [x] Task 7: Create `skills/code/SKILL.md` *(committed: c70c1df)*
  - Implementation: follow task specs exactly
  - TDD: write tests first when appropriate
  - Debugging: systematic root cause analysis when tests fail
  - Atomic commits: one task = one commit
  - Update `plan.md` with commit hash after each task

- [x] Task 8: Create `skills/review/SKILL.md` *(committed: c70c1df)*
  - Code review: quality, best practices, design alignment
  - Test review: validate tests are real, not stubs/mocks
  - Plan validation: confirm implementation matches plan
  - Output: pass/fail with actionable feedback

- [x] Task 9: Create `skills/workflow/SKILL.md` *(committed: c70c1df)*
  - Intent detection: infer from natural language
    - Vague + creative → start with brainstorm questions
    - Clear request → start at Explore
    - "Resume NNN" → check artifacts, pick up where left off
  - Phase progression: Explore → Plan → Code → Commit
  - Brainstorm logic: broad questions → narrow down
  - Design logic: architecture decisions, Mermaid diagrams
  - Plan logic: break design into atomic tasks
  - Implementation modes:
    - Batched: 2-3 tasks, pause for user review
    - Autonomous: all tasks, no pauses
  - Both modes: Reviewer runs after every task (non-negotiable)
  - Commit conventions: `<stage>: <what>`
  - Artifact management: create `.workflow/NNN-slug/` structure

### Phase 4: Integration

- [x] Task 10: Update `plugin.json` *(committed: 3d6e6a4)*
  - Update description to reflect new architecture
  - Update keywords

- [x] Task 11: Delete old agent files *(committed: f944c19)*
  - Remove: `agents/orchestrator.md` (replaced by workflow skill)
  - Remove any other legacy agent files

- [ ] Task 12: Test the workflow *(deferred - manual testing by user)*
  - Test: new feature request (natural language)
  - Test: vague request triggers brainstorm
  - Test: resume existing workflow
  - Test: batched implementation mode
  - Test: autonomous implementation mode

### Phase 5: Finalize

- [x] Task 13: Clean up `.workflow/001-workflow-redesign/`
  - Verify all artifacts present: design.md ✓, plan.md ✓
  - Final commit: `commit: finalize workflow redesign`

---

## Commit Plan

| Task | Commit message |
|------|----------------|
| 1-2 | `explore: clean up obsolete plugin files` |
| 3 | `code: create discoverer subagent` |
| 4 | `code: create coder subagent` |
| 5 | `code: create reviewer subagent` |
| 6 | `code: create discover skill` |
| 7 | `code: create code skill` |
| 8 | `code: create review skill` |
| 9 | `code: create workflow skill` |
| 10-11 | `code: update plugin.json and remove legacy files` |
| 12 | `code: test workflow integration` |
| 13 | `commit: finalize workflow redesign` |

---

## Implementation Modes Reference

### Batched Mode
```
Task 1 → Reviewer ─┐
Task 2 → Reviewer ─┼→ User checkpoint
Task 3 → Reviewer ─┘
Task 4 → Reviewer ─┐
Task 5 → Reviewer ─┼→ User checkpoint
Task 6 → Reviewer ─┘
...
```

### Autonomous Mode
```
Task 1 → Reviewer → Task 2 → Reviewer → Task 3 → Reviewer → ... → Done → User review
```

Both modes: Reviewer after every task. Quality gates are non-negotiable.
