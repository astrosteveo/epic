---
feature: 004-refactor-commands-for-skills
phase: plan
created: 2025-12-14
status: complete
---

# Implementation Plan: Refactor Commands to Delegate to Skills

**Research**: [Codebase](./codebase-research.md)

## Goal

Eliminate 60-70% content duplication between commands and skills by making skills the execution engines with `allowed-tools`, and converting commands to thin entry-point wrappers that invoke skills via the Skill tool.

## Approach Summary

**Scenario B from research**: Skills become primary execution engines, commands delegate.

**Invocation method**: Commands instruct Claude to use the `Skill` tool inline (most efficient - no background agent overhead).

**Arguments**: Commands pass `$ARGUMENTS` to skills via the Skill tool prompt context.

**Migration**: All 7 command/skill pairs refactored in parallel using Task tool.

### Architecture After Refactoring

```
User types: /epic:explore "add auth"
     ↓
Command (5 lines): "Invoke epic:epic-explore skill with: $ARGUMENTS"
     ↓
Claude uses Skill tool → skill content loaded
     ↓
Skill (full logic + allowed-tools) → executes workflow
     ↓
Artifacts created, summary presented
```

---

## Phase 1: Add allowed-tools to All Skills

Add YAML frontmatter `allowed-tools` to each skill, matching the current command restrictions.

### Changes

| File | Action | Description |
|------|--------|-------------|
| `skills/epic-explore/SKILL.md:1-4` | Modify | Add allowed-tools from `commands/explore.md:4-9` |
| `skills/epic-plan/SKILL.md:1-4` | Modify | Add allowed-tools from `commands/plan.md:3-8` |
| `skills/epic-implement/SKILL.md:1-4` | Modify | Add allowed-tools from `commands/implement.md:4-11` |
| `skills/epic-validate/SKILL.md:1-4` | Modify | Add allowed-tools from `commands/validate.md` |
| `skills/epic-commit/SKILL.md:1-4` | Modify | Add allowed-tools from `commands/commit.md:4-8` |
| `skills/epic-handoff/SKILL.md:1-4` | Modify | Add allowed-tools from `commands/handoff.md:4-8` |
| `skills/epic-resume/SKILL.md:1-4` | Modify | Add allowed-tools from `commands/resume.md:4-6` |

### Implementation Details

**epic-explore/SKILL.md** frontmatter becomes:
```yaml
---
name: epic-explore
description: Launch research agents to understand a codebase before planning changes...
allowed-tools:
  - Read
  - Write
  - Glob
  - Task
  - Bash(ls:*, mkdir:*, date:*)
---
```

**epic-plan/SKILL.md** frontmatter becomes:
```yaml
---
name: epic-plan
description: Create phased implementation plans from research artifacts...
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Task
---
```

**epic-implement/SKILL.md** frontmatter becomes:
```yaml
---
name: epic-implement
description: Execute implementation plan phase by phase with verification...
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash(npm:*, npx:*, cargo:*, go:*, python:*, pytest:*, make:*, git:status, git:diff)
  - AskUserQuestion
---
```

**epic-validate/SKILL.md** frontmatter becomes:
```yaml
---
name: epic-validate
description: Run comprehensive project validation including tests, linting, type checking...
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Bash(npm:*, npx:*, cargo:*, go:*, python:*, pytest:*, ruff:*, mypy:*, make:*, tsc:*)
---
```

**epic-commit/SKILL.md** frontmatter becomes:
```yaml
---
name: epic-commit
description: Create documented commit from workflow artifacts...
allowed-tools:
  - Read
  - Glob
  - Edit
  - Bash(git:status, git:diff, git:add, git:commit, git:log, git:show)
  - AskUserQuestion
---
```

**epic-handoff/SKILL.md** frontmatter becomes:
```yaml
---
name: epic-handoff
description: Create handoff document for transferring work to another session...
allowed-tools:
  - Read
  - Write
  - Glob
  - Bash(git:status, git:log, git:rev-parse, git:branch)
  - AskUserQuestion
---
```

**epic-resume/SKILL.md** frontmatter becomes:
```yaml
---
name: epic-resume
description: Resume work from a handoff document or workflow state...
allowed-tools:
  - Read
  - Glob
  - AskUserQuestion
---
```

### Verification

**Automated:**
- [ ] All skill files have valid YAML frontmatter (parseable)
- [ ] Each skill declares `allowed-tools` array

**Manual:**
- [ ] Verify allowed-tools match corresponding command's tools exactly

---

## Phase 2: Expand Skills with Full Implementation Logic

Ensure each skill contains complete workflow logic from its corresponding command. Currently skills have 50-80% of command logic - fill the gaps.

### Changes

| File | Action | Description |
|------|--------|-------------|
| `skills/epic-explore/SKILL.md` | Modify | Add missing: detailed output formats (3 variants), context efficiency rules |
| `skills/epic-plan/SKILL.md` | Modify | Add missing: plan quality validation checklist, leverage hierarchy reminder |
| `skills/epic-implement/SKILL.md` | Modify | Verify complete - already 80% overlap with command |
| `skills/epic-validate/SKILL.md` | Modify | Add missing: project type detection patterns, fix command patterns |
| `skills/epic-commit/SKILL.md` | Modify | Add missing: artifact staging logic, commit message templates |
| `skills/epic-handoff/SKILL.md` | Modify | Add missing: state serialization, handoff file structure |
| `skills/epic-resume/SKILL.md` | Modify | Verify complete - already most detailed skill (340 lines) |

### Implementation Details

For each skill, copy missing sections from corresponding command:

**From commands/explore.md to skills/epic-explore/SKILL.md:**
- Output Format section (lines 187-220) - 3 variants: Success Full, Success Codebase-only, Blocked
- Context Efficiency section (lines 222-240)
- Important reminders section (lines 242-250)

**From commands/plan.md to skills/epic-plan/SKILL.md:**
- Plan Quality Validation checklist (from "Validate Plan Quality" section)
- Leverage Hierarchy Reminder section

**From commands/validate.md to skills/epic-validate/SKILL.md:**
- Project type detection logic
- Fix command patterns (--fix flag handling)

**From commands/commit.md to skills/epic-commit/SKILL.md:**
- Artifact gathering logic
- Commit message template with workflow reference

**From commands/handoff.md to skills/epic-handoff/SKILL.md:**
- Full handoff document structure
- State serialization patterns

### Verification

**Automated:**
- [ ] Skills parse without errors

**Manual:**
- [ ] Each skill contains all workflow steps from corresponding command
- [ ] No logic gaps that would cause execution failures

---

## Phase 3: Convert Commands to Thin Wrappers

Replace full command logic with thin wrappers that invoke skills via Skill tool.

### Changes

| File | Action | Description |
|------|--------|-------------|
| `commands/explore.md` | Rewrite | 339 lines → 5 lines |
| `commands/plan.md` | Rewrite | 232 lines → 5 lines |
| `commands/implement.md` | Rewrite | 286 lines → 5 lines |
| `commands/validate.md` | Rewrite | 200+ lines → 5 lines |
| `commands/commit.md` | Rewrite | 200+ lines → 5 lines |
| `commands/handoff.md` | Rewrite | 80+ lines → 5 lines |
| `commands/resume.md` | Rewrite | 80+ lines → 5 lines |

### Implementation Details

**Template for minimal wrapper commands (~5 lines):**

```markdown
---
description: [same description as before]
argument-hint: [same hint as before]
---

Invoke the `epic:[skill-name]` skill with: $ARGUMENTS
```

**All 7 commands follow this pattern:**

| Command | Content |
|---------|---------|
| `commands/explore.md` | `Invoke the epic:epic-explore skill with: $ARGUMENTS` |
| `commands/plan.md` | `Invoke the epic:epic-plan skill.` |
| `commands/implement.md` | `Invoke the epic:epic-implement skill with: $ARGUMENTS` |
| `commands/validate.md` | `Invoke the epic:epic-validate skill with: $ARGUMENTS` |
| `commands/commit.md` | `Invoke the epic:epic-commit skill with: $ARGUMENTS` |
| `commands/handoff.md` | `Invoke the epic:epic-handoff skill with: $ARGUMENTS` |
| `commands/resume.md` | `Invoke the epic:epic-resume skill with: $ARGUMENTS` |

**Example: commands/explore.md becomes:**

```markdown
---
description: Research codebase and external docs for a feature
argument-hint: <feature-description>
---

Invoke the `epic:epic-explore` skill with: $ARGUMENTS
```

### Verification

**Automated:**
- [ ] All command files have valid YAML frontmatter
- [ ] Each command declares `Skill` in allowed-tools

**Manual:**
- [ ] Each command correctly references its skill name
- [ ] Arguments pass-through pattern is consistent
- [ ] Test one command end-to-end: `/epic:explore test feature`

---

## Phase 4: Update Plugin Manifest and Documentation

Update plugin.json and CLAUDE.md to reflect new architecture.

### Changes

| File | Action | Description |
|------|--------|-------------|
| `CLAUDE.md` | Modify | Update Commands section to note delegation pattern |
| `.claude-plugin/plugin.json` | Verify | No changes needed - already registers both |

### Implementation Details

**CLAUDE.md updates:**

Add to Commands section:
```markdown
## Command Architecture

Commands are thin entry-point wrappers that invoke skills. The workflow logic lives in skills.

| Command | Invokes Skill | Purpose |
|---------|---------------|---------|
| `/epic:explore` | `epic:epic-explore` | Research phase |
| `/epic:plan` | `epic:epic-plan` | Planning phase |
| `/epic:implement` | `epic:epic-implement` | Implementation phase |
| `/epic:validate` | `epic:epic-validate` | Validation phase |
| `/epic:commit` | `epic:epic-commit` | Commit phase |
| `/epic:handoff` | `epic:epic-handoff` | Session handoff |
| `/epic:resume` | `epic:epic-resume` | Resume from handoff |

Commands handle: Entry point, argument parsing, skill invocation
Skills handle: Full workflow logic, tool execution, artifact creation
```

### Verification

**Automated:**
- [ ] Plugin loads without errors

**Manual:**
- [ ] CLAUDE.md accurately describes new architecture
- [ ] End-to-end test: Run full workflow explore → plan → implement → validate → commit

---

## Rollback Plan

If issues arise:

1. **Git revert**: All changes are in tracked files
   ```bash
   git checkout HEAD~1 -- commands/ skills/ CLAUDE.md
   ```

2. **Selective rollback**: If only one command/skill pair fails:
   - Revert that specific command to full logic
   - Remove allowed-tools from corresponding skill
   - Document as known issue

3. **Full rollback**: If architecture doesn't work:
   - Restore all commands to full logic
   - Remove allowed-tools from all skills
   - Skills return to passive reference documents

## Success Criteria

- [ ] All 7 commands successfully invoke their corresponding skills
- [ ] Skills execute with proper tool restrictions
- [ ] No workflow functionality lost
- [ ] Commands reduced: ~1,800 lines → ~35 lines (7 × 5 lines)
- [ ] Skills are single source of truth for all workflow logic
- [ ] End-to-end test passes: `/epic:explore` → `/epic:plan` → `/epic:implement` → `/epic:validate` → `/epic:commit`

## Implementation Notes

**Parallel execution**: Phases 1-3 can each be executed as 7 parallel Task agents (one per command/skill pair).

**Argument passing**: The Skill tool receives context including the original $ARGUMENTS. Skills should reference this via the conversation context.

**Testing approach**: After each phase, test one command/skill pair end-to-end before proceeding.

## Open Questions

None - all decisions resolved:
- Invocation: Skill tool (inline, most efficient)
- Arguments: Pass through via Skill tool context
- Migration: All at once, parallel execution
