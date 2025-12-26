# Implementation Plan: Harness Workflow Plugin

## Overview

This plan implements the harness workflow plugin following Approach 1 (Minimal Commands + Rich Skills). Each step represents 1-3 logical commits of work.

## Pre-Implementation Checklist

- [x] requirements.md created
- [x] codebase.md created
- [x] research.md created
- [x] design.md created
- [x] plan.md created (this file)
- [x] User approval of plan

---

## Phase 1: Plugin Foundation

### Step 001-1: Create plugin configuration ✅

**Files to create:**
- `.claude-plugin/plugin.json`

**Details:**
```json
{
  "name": "harness",
  "description": "A 5-phase workflow for Claude Code: Define → Research → Plan → Execute → Verify",
  "version": "1.0.0",
  "author": {"name": "astrosteveo"},
  "license": "MIT",
  "keywords": ["workflow", "tdd", "planning", "socratic"]
}
```

**Commit message:** `feat(harness): add plugin configuration`

---

## Phase 2: Core Skills

### Step 001-2: Create `defining` skill ✅

**Files to create:**
- `skills/defining/SKILL.md`

**Key content:**
- YAML frontmatter with name and description
- Socratic process: vision → requirements → constraints → success criteria
- Task directory creation logic
- requirements.md template
- Phase transition offer

**Commit message:** `feat(harness): add defining skill for requirements gathering`

---

### Step 001-3: Create `researching` skill ✅

**Files to create:**
- `skills/researching/SKILL.md`

**Key content:**
- Codebase exploration guidance
- Git history mining instructions
- External research approach
- codebase.md and research.md templates
- Approach presentation format
- Phase transition offer

**Commit message:** `feat(harness): add researching skill for discovery phase`

---

### Step 001-4: Create `planning` skill ✅

**Files to create:**
- `skills/planning/SKILL.md`

**Key content:**
- Section-by-section Socratic dialogue process
- design.md template (architecture, mermaid diagrams)
- plan.md template (granular steps)
- Deferral handling → backlog.md
- Phase transition offer

**Commit message:** `feat(harness): add planning skill for collaborative design`

---

### Step 001-5: Create `executing` skill ✅

**Files to create:**
- `skills/executing/SKILL.md`

**Key content:**
- TDD-first approach with exception handling
- Plan following with progress tracking
- Incremental commit guidance
- Loop-back triggers for plan issues
- Phase transition offer

**Commit message:** `feat(harness): add executing skill for TDD implementation`

---

### Step 001-6: Create `verifying` skill ✅

**Files to create:**
- `skills/verifying/SKILL.md`

**Key content:**
- Full test suite execution
- requirements.md validation
- plan.md validation
- Verifier agent delegation
- Dual completion criteria (tests + user satisfaction)
- Loop-back triggers

**Commit message:** `feat(harness): add verifying skill for validation phase`

---

## Phase 3: Meta-Skill and Agent

### Step 001-7: Create `using-harness` meta-skill ✅

**Files to create:**
- `skills/using-harness/SKILL.md`

**Key content:**
- Workflow overview and intent detection
- Phase transition suggestions
- Lightweight mode recognition
- Spike pattern detection
- Active task context instructions
- Skill references for each phase

**Commit message:** `feat(harness): add using-harness meta-skill for intent detection`

---

### Step 001-8: Create `verifier` agent ✅

**Files to create:**
- `agents/verifier.md`

**Key content:**
- Peer reviewer persona
- Code review checklist
- Test quality assessment
- Requirements compliance check
- Reporting format

**Commit message:** `feat(harness): add verifier agent for peer review simulation`

---

## Phase 4: Commands

### Step 001-9: Create slash commands ✅

**Files to create:**
- `commands/define.md`
- `commands/research.md`
- `commands/plan.md`
- `commands/execute.md`
- `commands/verify.md`

**Pattern for each:**
```markdown
---
description: "Start or return to {Phase} phase"
disable-model-invocation: true
---

Invoke the harness:{skill} skill and follow it exactly.
```

**Commit message:** `feat(harness): add slash commands for all workflow phases`

---

## Phase 5: Hook Integration

### Step 001-10: Create SessionStart hook ✅

**Files to create:**
- `hooks/hooks.json`

**Key content:**
```json
{
  "hooks": {
    "SessionStart": [{
      "matcher": "startup|resume|clear",
      "hooks": [{
        "type": "command",
        "command": "cat skills/using-harness/SKILL.md"
      }]
    }]
  }
}
```

**Commit message:** `feat(harness): add SessionStart hook for workflow injection`

---

## Phase 6: Verification

### Step 001-11: Test the workflow

**Manual verification:**
1. Start new Claude Code session in plugin directory
2. Verify SessionStart hook injects using-harness content
3. Test `/define` command creates task directory and requirements.md
4. Test `/research` command produces codebase.md and research.md
5. Test `/plan` command produces design.md and plan.md
6. Test `/execute` follows TDD approach
7. Test `/verify` runs validation and engages verifier agent
8. Test phase transitions work (both offered and explicit)
9. Test lightweight mode suggestion for trivial task
10. Verify backlog.md management

**Commit message:** `test(harness): verify workflow end-to-end`

---

## Summary

| Step | Description | Files |
|------|-------------|-------|
| 001-1 | Plugin config | 1 |
| 001-2 | defining skill | 1 |
| 001-3 | researching skill | 1 |
| 001-4 | planning skill | 1 |
| 001-5 | executing skill | 1 |
| 001-6 | verifying skill | 1 |
| 001-7 | using-harness meta-skill | 1 |
| 001-8 | verifier agent | 1 |
| 001-9 | slash commands | 5 |
| 001-10 | SessionStart hook | 1 |
| 001-11 | End-to-end testing | 0 |

**Total: 14 files across 11 steps**

---

## Deferred Items (to backlog.md)

- Spike directory pattern (`.harness/{nnn}-spike-{topic}/`)
- Active task tracking (`.harness/active-task.md`)
- Cross-platform hook scripts (run-hook.cmd pattern)
- Integration with external issue trackers
