# Implementation Plan: Context Window Progress Indicator

**Date**: 2025-12-13
**Feature Slug**: 001-context-window-progress-indicator
**Research**: [Codebase](../research/codebase.md) | [Docs](../research/docs.md)

## Goal

Add prose-based context utilization guidance to plugin commands, instructing Claude to self-report context window usage at key workflow points using its native context awareness capabilities.

## Approach Summary

Based on research findings:
- The plugin is purely declarative markdown with no runtime code capability
- Claude 4.5 models have native context awareness via `<system_warning>` tags
- The "X of Y" pattern (e.g., "~45K / 200K tokens") is recommended for CLI progress displays
- Context thresholds are already defined: 40-60% optimal, >60% triggers compaction

**Chosen approach**: Enhance existing commands with context reporting instructions at phase boundaries. This leverages Claude's native awareness without requiring external API calls or runtime code.

---

## Phase 1: Add Context Reporting to Output Formats

### Changes

| File | Action | Description |
|------|--------|-------------|
| `commands/explore.md:185-210` | Modify | Add context utilization line to Success output format |
| `commands/plan.md:175-200` | Modify | Add context utilization line to Success output format |
| `commands/implement.md:225-262` | Modify | Add context utilization line to phase completion output |
| `commands/validate.md:263-290` | Modify | Add context utilization line to Success output format |
| `commands/commit.md:170-195` | Modify | Add context utilization line to Success output format |

### Implementation Details

Add to each command's "## Output Format" → "### Success" section:

```markdown
**Context**: ~[X]K / 200K tokens ([Y]%)
```

Example output after modification:
```
✓ Explore Phase Complete

Feature: [description]
Directory: .claude/workflows/[NNN-slug]/

Research Artifacts:
- codebase.md ([X] files documented)
- docs.md ([Y] sources cited)

**Context**: ~45K / 200K tokens (23%)

Next: Review artifacts, then run `/plan`
```

### Verification

**Automated**:
- [ ] N/A - markdown only, no build/lint/test

**Manual**:
- [ ] Each command file contains context line in output format
- [ ] Format follows "X of Y" pattern from research
- [ ] Percentage calculation guidance is present

---

## Phase 2: Add Context Awareness Instructions

### Changes

| File | Action | Description |
|------|--------|-------------|
| `commands/explore.md` | Modify | Add "Context Reporting" section with instructions |
| `commands/plan.md` | Modify | Add "Context Reporting" section with instructions |
| `commands/implement.md` | Modify | Add "Context Reporting" section with instructions |
| `commands/validate.md` | Modify | Add "Context Reporting" section with instructions |
| `commands/commit.md` | Modify | Add "Context Reporting" section with instructions |

### Implementation Details

Add new section to each command file (before "## Important" section):

```markdown
## Context Reporting

At the end of this command, report estimated context utilization:

**Format**: `**Context**: ~[X]K / 200K tokens ([Y]%)`

**Estimation guidance**:
- Light exploration/research: ~20-40K tokens
- Medium complexity with multiple file reads: ~40-80K tokens
- Heavy implementation with many tool calls: ~80-120K tokens
- Extended session with background agents: ~100-150K tokens

**Threshold warnings**:
- 40-60%: Optimal range, continue normally
- 60-80%: Consider compacting after current phase
- >80%: Recommend immediate compaction before continuing

If context exceeds 60%, append warning:
```
⚠️ Context at [Y]% - consider running `/compact` or starting fresh session
```
```

### Verification

**Automated**:
- [ ] N/A - markdown only

**Manual**:
- [ ] Each command file has "Context Reporting" section
- [ ] Estimation guidance covers typical workflow scenarios
- [ ] Threshold warnings match CLAUDE.md values (40-60% optimal, >60% compact)

---

## Phase 3: Update State Template

### Changes

| File | Action | Description |
|------|--------|-------------|
| `templates/state.md` | Modify | Add Context Utilization field to template |

### Implementation Details

Add to `templates/state.md` after "Last Updated" field:

```markdown
**Context Estimate**: ~[X]K / 200K tokens ([Y]%)
```

Updated template header:
```markdown
# Workflow State

**Feature**: {{FEATURE}}
**Slug**: {{SLUG}}
**Directory**: .claude/workflows/{{SLUG}}
**Current Phase**: {{PHASE}}
**Last Updated**: {{DATE}}
**Context Estimate**: ~[X]K / 200K tokens ([Y]%)
```

### Verification

**Automated**:
- [ ] N/A - markdown only

**Manual**:
- [ ] Template includes Context Estimate field
- [ ] Field placement is logical (with other metadata)
- [ ] Format matches output format pattern

---

## Phase 4: Add Context Guidance to CLAUDE.md

### Changes

| File | Action | Description |
|------|--------|-------------|
| `CLAUDE.md:30-35` | Modify | Enhance context management section with reporting guidance |

### Implementation Details

Expand the existing context management section in CLAUDE.md:

```markdown
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
```

### Verification

**Automated**:
- [ ] N/A - markdown only

**Manual**:
- [ ] CLAUDE.md context section includes reporting guidance
- [ ] Thresholds are consistent across all files
- [ ] Instructions are clear and actionable

---

## Rollback Plan

If issues arise:
1. All changes are to markdown files - use `git checkout` to revert individual files
2. Changes are additive (new sections) - can be removed without breaking existing functionality
3. No runtime dependencies to uninstall

```bash
# Revert all changes
git checkout HEAD -- commands/ templates/state.md CLAUDE.md

# Or revert specific files
git checkout HEAD -- commands/explore.md
```

## Success Criteria

- [ ] All 5 command files include context reporting in output format
- [ ] All 5 command files include "Context Reporting" section
- [ ] templates/state.md includes Context Estimate field
- [ ] CLAUDE.md context section includes reporting guidance
- [ ] All threshold values are consistent (40-60% optimal, 60%+ warn, 80%+ urgent)
- [ ] Format follows "X of Y" pattern from external research
- [ ] Manual test: Run `/explore` and verify context line appears in output

## Open Questions

None - approach is straightforward and fully specified.
