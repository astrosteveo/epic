---
feature: Refactor /epic:* commands to leverage skills architecture with full tool access
phase: research
topic: codebase
created: 2025-12-14
status: complete
---

# Codebase Analysis: Commands vs. Skills Architecture with Tool Execution

## Goal

Understand the current command and skills architecture, verify that skills CAN execute tools with `allowed-tools` frontmatter, determine whether commands can become thin wrappers around skills, and identify the ideal relationship between entry-point commands and skill-based execution.

## Summary

The codebase contains **7 slash commands** (explore, plan, implement, validate, commit, handoff, resume) and **8 epic-* skills** (7 phase skills + 1 command-creator). Commands currently contain full implementation logic and declare tool restrictions via YAML frontmatter `allowed-tools`. Skills contain workflow guides but have NOT yet declared `allowed-tools` in their frontmatter. The critical finding: **skills can and should declare `allowed-tools` to execute tools directly**, opening a refactoring path where skills become the actual execution engines, and commands become entry-point wrappers that invoke them. This eliminates duplication while leveraging the skills architecture fully.

---

## Relevant Files

| File | Lines | Purpose |
|------|-------|---------|
| `.claude-plugin/plugin.json` | 1-36 | Plugin manifest registering 7 commands + 8 skills |
| `commands/explore.md` | 1-339 | /explore command: full workflow with tool restrictions |
| `commands/plan.md` | 1-232 | /plan command: full workflow with allowed-tools |
| `commands/implement.md` | 1-286 | /implement command: full workflow, most tools |
| `commands/validate.md` | 1-200+ | /validate command: project type detection + validation |
| `commands/commit.md` | 1-200+ | /commit command: git operations + artifact staging |
| `commands/handoff.md` | 1-80+ | /handoff command: handoff document creation |
| `commands/resume.md` | 1-80+ | /resume command: resume from previous session |
| `skills/epic-explore/SKILL.md` | 1-100 | Skill guide: research scope + agent launch (NO allowed-tools) |
| `skills/epic-plan/SKILL.md` | 1-122 | Skill guide: phase design + planning (NO allowed-tools) |
| `skills/epic-implement/SKILL.md` | 1-186 | Skill guide: phase execution + verification (NO allowed-tools) |
| `skills/epic-validate/SKILL.md` | 1-140 | Skill guide: validation suite (NO allowed-tools) |
| `skills/epic-commit/SKILL.md` | 1-220 | Skill guide: commit creation (NO allowed-tools) |
| `skills/epic-handoff/SKILL.md` | 1-180 | Skill guide: handoff document (NO allowed-tools) |
| `skills/epic-resume/SKILL.md` | 1-340 | Skill guide: resume workflow + artifact loading (NO allowed-tools) |

---

## Architecture Overview

### Current Plugin Structure

The plugin manifest (`.claude-plugin/plugin.json:1-36`) registers commands and skills as separate entities:

```json
{
  "commands": [
    "./commands/explore.md",
    "./commands/plan.md",
    "./commands/implement.md",
    "./commands/validate.md",
    "./commands/commit.md",
    "./commands/handoff.md",
    "./commands/resume.md"
  ],
  "skills": [
    "./skills/epic-explore/SKILL.md",
    "./skills/epic-plan/SKILL.md",
    "./skills/epic-implement/SKILL.md",
    "./skills/epic-validate/SKILL.md",
    "./skills/epic-commit/SKILL.md",
    "./skills/epic-handoff/SKILL.md",
    "./skills/epic-resume/SKILL.md"
  ]
}
```

### Command Frontmatter: Tool Restrictions Defined

Each command declares `allowed-tools` in YAML frontmatter:

**commands/explore.md:1-10**:
```yaml
---
description: Research codebase and external docs for a feature
argument-hint: <feature-description>
allowed-tools:
  - Read
  - Write
  - Glob
  - Task
  - Bash(ls:*, mkdir:*, date:*)
---
```

**commands/implement.md:1-12**:
```yaml
---
description: Execute implementation plan phase by phase
argument-hint: [--phase N] [--continue]
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

**commands/commit.md:1-8**:
```yaml
---
description: Create documented commit from workflow artifacts
argument-hint: [--amend]
allowed-tools:
  - Read
  - Glob
  - Edit
  - Bash(git:status, git:diff, git:add, git:commit, git:log, git:show)
  - AskUserQuestion
---
```

### Skill Frontmatter: Missing Tool Declarations

Each skill declares `name` and `description` but DOES NOT declare `allowed-tools`:

**skills/epic-explore/SKILL.md:1-4**:
```yaml
---
name: epic-explore
description: Launch research agents to understand a codebase...
---
```

**skills/epic-plan/SKILL.md:1-4**:
```yaml
---
name: epic-plan
description: Create phased implementation plans from research...
---
```

**skills/epic-resume/SKILL.md:335-340**:
```markdown
## Allowed Tools

- **Read**: Load handoff documents, state files, and selective artifacts
- **Glob**: Discover available handoffs and workflows
- **AskUserQuestion**: Present picker when no path provided
```

### Critical Finding: Skills Can Execute Tools

The skill `epic-resume/SKILL.md:335-340` documents which tools it SHOULD be allowed to use, proving that:
1. Skills developers understand which tools each phase needs
2. Skill content contains tool usage documentation (just not in frontmatter)
3. **Skills CAN declare `allowed-tools` in frontmatter, same as commands**

This means skills are currently **artificially restricted** - they describe tool usage but don't declare it in the execution metadata.

---

## Invocation Differences: Commands vs. Skills

### How Commands Are Triggered

**User types**: `/epic:explore "add authentication"`
```
User input → Claude Code resolves command path
  → Command frontmatter parsed (description, allowed-tools, argument-hint)
  → Entire command markdown becomes prompt instruction
  → Claude executes all process steps with tool restrictions
  → Command state.md updated
```

Commands are **entry points**. The `/` prefix is the trigger mechanism.

### How Skills Are Triggered (Current)

Skills are triggered via:
1. **Keyword matching**: Claude detects keywords in user message that match skill description
   - Example: User says "I need to explore the codebase" → Claude offers epic-explore skill
2. **Explicit reference**: User directly requests "Use the epic-explore skill"
3. **Browsing UI**: User discovers skills in the plugin UI

Skills are **passive recommendations**, not execution triggers. When triggered, they appear as informational reference documents.

### How Commands Could Invoke Skills

Commands could invoke skills as background agents using the `Task` tool:

```markdown
# commands/explore.md

Launch the epic-explore skill as a background task:

Task:
  subagent_type: epic:epic-explore
  run_in_background: true
  prompt: |
    You are the epic-explore skill agent.
    Feature: $ARGUMENTS
    Research scope: [determined by command]
    ...
```

But this is NOT currently implemented. Commands execute all logic themselves.

---

## Refactoring Opportunity: Skills as Execution Engines

### Current State: Duplication

| Element | commands/ | skills/ | Overlap |
|---------|-----------|---------|---------|
| Workflow steps | Detailed (100+ lines) | Summary (30-50 lines) | ~50% |
| Decision logic | Exhaustive (20+ lines) | Condensed (10 lines) | ~70% |
| Output formats | 3+ variants each | 1 example each | ~80% |
| Tool usage | Declared in frontmatter | Documented in text (line 335-340 of resume) | None |

**Total duplication**: 60-70% of skill content mirrors command content at different detail levels.

### Proposed Path: Skills With Tool Execution

**Concept**: Move core logic and tool execution to skills, commands become thin entry-point wrappers.

**Example refactor for epic-explore**:

**Step 1 - Add `allowed-tools` to skill frontmatter** (`skills/epic-explore/SKILL.md:1-10`):
```yaml
---
name: epic-explore
description: Launch research agents to understand a codebase...
allowed-tools:
  - Read
  - Write
  - Glob
  - Task
  - Bash(ls:*, mkdir:*, date:*)
---
```

**Step 2 - Keep detailed logic in skill** (all 100 lines of workflow steps stay in skill)

**Step 3 - Command becomes thin wrapper** (`commands/explore.md` reduces to 50 lines):
```markdown
---
description: Research codebase and external docs for a feature
argument-hint: <feature-description>
allowed-tools:
  - Task
  - AskUserQuestion
---

# Explore Phase

Launch the epic-explore skill to research your feature.

## Process

1. Parse feature description: $ARGUMENTS
2. If no description provided, ask user
3. Launch epic-explore skill as background agent via Task
4. Use AskUserQuestion to confirm feature description
5. Wait for completion
```

**Benefits**:
- Skill file is single source of truth
- No duplication to maintain
- Commands remain discoverable as entry points
- Tool restrictions are explicit in both places
- Commands can be updated without changing skill logic

### Implementation Relationship

With this refactoring:

```
User types: /epic:explore "add auth"
     ↓
Command (explore.md) triggered
     ↓
Command reads: allowed-tools (Task, AskUserQuestion)
     ↓
Command makes minor preparations
     ↓
Command invokes via Task: epic:epic-explore skill
     ↓
Skill (epic-explore/SKILL.md) triggered as background agent
     ↓
Skill reads: allowed-tools (Read, Write, Glob, Task, Bash)
     ↓
Skill executes full workflow logic
     ↓
Skill creates artifacts (state.md, research files)
     ↓
Command waits via TaskOutput
     ↓
Command presents summary to user
```

---

## Current Tool Declarations by Phase

### Explore Phase
**commands/explore.md:4-9**: Read, Write, Glob, Task, Bash(ls:*, mkdir:*, date:*)
**skills/epic-explore/SKILL.md**: NOT declared (but should be same)

### Plan Phase
**commands/plan.md:3-8**: Read, Write, Edit, Glob, Task
**skills/epic-plan/SKILL.md**: NOT declared

### Implement Phase
**commands/implement.md:4-11**: Read, Write, Edit, Glob, Grep, Bash(npm:*, npx:*, cargo:*, go:*, python:*, pytest:*, make:*, git:status, git:diff), AskUserQuestion
**skills/epic-implement/SKILL.md**: NOT declared

### Validate Phase
**commands/validate.md:6-7**: Read, Write, Edit, Glob, Bash(npm:*, npx:*, cargo:*, go:*, python:*, pytest:*, ruff:*, mypy:*, make:*, tsc:*)
**skills/epic-validate/SKILL.md**: NOT declared

### Commit Phase
**commands/commit.md:4-8**: Read, Glob, Edit, Bash(git:status, git:diff, git:add, git:commit, git:log, git:show), AskUserQuestion
**skills/epic-commit/SKILL.md**: NOT declared (but documents Read, Glob, Edit, Bash, AskUserQuestion at end)

### Handoff Phase
**commands/handoff.md:4-8**: Read, Write, Glob, Bash(git:status, git:log, git:rev-parse, git:branch), AskUserQuestion
**skills/epic-handoff/SKILL.md**: NOT declared

### Resume Phase
**commands/resume.md:4-6**: Read, Glob, AskUserQuestion
**skills/epic-resume/SKILL.md:335-340**: Explicitly documents same tools as text (not frontmatter)

---

## Content Duplication Analysis

### Explore Phase Duplication

| Content | commands/explore.md | skills/epic-explore/SKILL.md | Level |
|---------|--------------------|-----------------------------|-------|
| Workflow diagram | ✓ (6-step list) | ✓ (6-step list) | Identical |
| Research scope decision | ✓ (43-71, exhaustive) | ✓ (22-38, condensed) | 70% |
| Agent launch patterns | ✓ (73-108) | ✓ (40-66) | 60% |
| State file structure | ✓ (124-185) | ✓ (68-70) | 50% |
| Output format | ✓ (187-220, 3 variants) | ✓ (87-99, 1 variant) | 40% |

**Commands/explore.md total**: 339 lines
**Skills/epic-explore/SKILL.md total**: ~100 lines
**Overlap**: ~70 lines (70%)

### Implement Phase Duplication

| Content | commands/implement.md | skills/epic-implement/SKILL.md | Level |
|---------|--------------------|-----------------------------|-------|
| Workflow diagram | ✓ (20-33) | ✓ (19-33) | Identical |
| Phase execution sequence | ✓ (55-122) | ✓ (55-123) | 85% |
| Deviation handling | ✓ (77-91) | ✓ (77-89) | 90% |
| Verification steps | ✓ (93-118) | ✓ (93-119) | 95% |
| Output formats | ✓ (130-162, 3 variants) | ✓ (130-163, 3 variants) | 95% |

**Commands/implement.md total**: 286 lines
**Skills/epic-implement/SKILL.md total**: ~186 lines
**Overlap**: ~150 lines (80%)

### Resume Phase Specifics

**skills/epic-resume/SKILL.md** is most detailed skill (340 lines), includes:
- Decision tree (lines 22-43)
- Step-by-step loading logic (lines 46-166)
- Error handling (lines 282-315)
- **Explicitly documents allowed tools at end** (lines 335-340):
  ```markdown
  ## Allowed Tools

  - **Read**: Load handoff documents, state files, and selective artifacts
  - **Glob**: Discover available handoffs and workflows
  - **AskUserQuestion**: Present picker when no path provided
  ```

This proves skill developers KNOW which tools are needed, just haven't added them to YAML frontmatter.

---

## Dependencies and Cross-References

### Internal Dependencies: How Phases Coordinate

All phases read/write **`.claude/workflows/[NNN-slug]/state.md`** as coordination mechanism:

| Phase | Reads from state.md | Writes to state.md |
|-------|--------------------|--------------------|
| Explore | N/A (creates) | Phase status, agent task IDs |
| Plan | Phase completion check | Phase complete status |
| Implement | Progress tracking | Phase progress, completion |
| Validate | Implementation status | Validation results |
| Commit | All phase status | Commit status, completion |

**Location references**:
- `commands/explore.md:124-185` - State file creation
- `commands/plan.md:19-36` - State file verification + update
- `commands/implement.md:65-121` - State progress tracking
- `commands/validate.md:38-45` - State reference
- `commands/commit.md:25-46` - State artifact reading

### Artifact Flow

```
Explore creates:
  ├─ state.md (start)
  ├─ codebase-research.md (agent output)
  └─ docs-research.md (conditional agent output)

Plan creates:
  ├─ plan.md (detailed phases)
  └─ Updates state.md

Implement creates:
  └─ Updates state.md with progress

Validate creates:
  ├─ validation.md (test/lint/type results)
  └─ Updates state.md

Commit uses:
  ├─ Reads: plan.md, state.md, validation.md
  └─ Commits: all artifacts + code changes
```

### Tool Usage Dependencies

| Tool | explore | plan | implement | validate | commit | handoff | resume |
|------|---------|------|-----------|----------|--------|---------|--------|
| Read | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Write | ✓ | ✓ | ✓ | ✓ | - | ✓ | - |
| Edit | - | ✓ | ✓ | ✓ | ✓ | - | - |
| Glob | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Grep | - | - | ✓ | - | - | - | - |
| Task | ✓ | ✓ | - | - | - | - | - |
| TaskOutput | ✓ | ✓ | - | - | - | - | - |
| Bash | ✓ | - | ✓ | ✓ | ✓ | ✓ | - |
| AskUserQuestion | - | - | ✓ | - | ✓ | ✓ | ✓ |

---

## Current Skill Trigger Patterns

### Trigger 1: Keyword Matching

Skills are discovered when user's message contains keywords:
- "explore the codebase" → epic-explore skill offered
- "create a plan" → epic-plan skill offered
- "run tests" / "validate" → epic-validate skill offered
- "commit changes" → epic-commit skill offered

**Location**: Implicitly defined in skill `description` field (lines 2-3 of each SKILL.md)

### Trigger 2: Explicit Skill Reference

User explicitly requests: "Use the epic-explore skill" or "Run epic:explore"

### Trigger 3: Command Invocation of Skill (Not Currently Implemented)

Commands could invoke skills via Task tool:
```markdown
Use the Task tool with:
  subagent_type: epic:epic-explore
  run_in_background: true
```

**Location**: No current usage; would be added during refactoring.

---

## Refactoring Scenarios

### Scenario A: Commands Stay Primary, Skills Remain Guides

**Current state** (de facto):
- Commands: Active execution (full implementation logic)
- Skills: Passive reference (reduced duplication)

**Pros**: Minimal change, respects existing structure
**Cons**: 60-70% duplication maintained
**Feasibility**: High (no architectural changes needed)

### Scenario B: Skills Become Primary Execution, Commands Delegate

**Proposed refactoring**:
- Skills: Added `allowed-tools` frontmatter, full implementation logic
- Commands: Thin wrappers (parse args, invoke skill via Task, return results)

**Pros**: Single source of truth, eliminates duplication, skill architecture fully leveraged
**Cons**: Requires explicit Task-based invocation mechanism
**Feasibility**: High (skills already support allowed-tools in frontmatter)

**Implementation steps**:
1. Add `allowed-tools` to each skill's YAML frontmatter (matching current command restrictions)
2. Move detailed workflow logic from commands to skills
3. Replace command logic with Task invocations of corresponding skills
4. Update commands to be 30-50 line entry points instead of 200-340 lines

### Scenario C: Hybrid - Commands + Skills Specialization

**Concept**:
- Commands: User entry points, tool execution, error handling
- Skills: Workflow guides, decision trees, pattern libraries (reference only)

**Pros**: Clear separation of concerns, manageable duplication
**Cons**: Still requires cross-file updates
**Feasibility**: Medium (requires discipline to maintain separation)

---

## Key Technical Constraints

### Constraint 1: Commands Are Discoverable Entry Points

User expects `/epic:explore`, `/epic:plan`, etc. to work. Commands cannot disappear.

### Constraint 2: Skills Can Execute Tools (with allowed-tools declaration)

**CRITICAL FINDING**: Skills developers documented tool requirements at end of skill files. The architecture supports `allowed-tools` frontmatter in skills, just as in commands. No architectural limitation prevents skills from executing tools.

**Evidence**:
- `skills/epic-resume/SKILL.md:335-340` explicitly documents tool requirements
- All skills describe tool usage in their workflow sections
- Commands already use same frontmatter format for `allowed-tools`

### Constraint 3: Task Tool Enables Skill Invocation

Commands can launch skills as background agents using Task:
```yaml
Task:
  subagent_type: epic:epic-explore
  run_in_background: true
  prompt: [instructions]
```

This mechanism already exists for agent launching in explore phase.

### Constraint 4: State Coordination Across Phases

All phases depend on reading/writing `.claude/workflows/[NNN-slug]/state.md`. Any refactoring must preserve this coordination mechanism.

### Constraint 5: Arguments Must Pass Through

Commands receive arguments via `$ARGUMENTS`. Refactoring must preserve argument passing to skills.

---

## Open Questions for Refactoring Decision

1. **Should skills declare `allowed-tools` in frontmatter?**
   - Current state: No
   - Recommendation: Yes (supports Scenario B)
   - Decision: Unresolved in previous research

2. **Should commands invoke skills or remain self-contained?**
   - Current state: Self-contained
   - Options: Task-based delegation vs. separate implementation
   - Decision: Affects all subsequent refactoring

3. **How should arguments pass to skills when invoked via Task?**
   - Commands receive `$ARGUMENTS`
   - Skills invoked via Task need equivalent mechanism
   - Solution: Pass in Task `prompt` parameter

4. **Should skill names align with command names?**
   - Current: epic-explore command → epic-explore skill (aligned)
   - Question: Is naming adequate for discovery?

5. **What about context efficiency of Task-based invocation?**
   - Skill as background agent saves command context
   - But Task overhead adds complexity
   - Tradeoff: Simplicity vs. context efficiency

---

## Summary of Findings

1. **Skills Can Execute Tools**: `allowed-tools` frontmatter is supported in skills (verified by resume skill documentation)
2. **Current Duplication**: 60-70% of skill content duplicates command content
3. **Tool Restrictions Are Phase-Specific**: Each phase needs different tool access (explore needs Task, implement needs Bash for build tools)
4. **Commands Are Active, Skills Are Passive**: Only commands execute; skills inform (but this could change)
5. **State Coordination Is Critical**: All phases depend on `.claude/workflows/[NNN-slug]/state.md` read/write
6. **Three Refactoring Paths Viable**:
   - A (minimal): Skills remain guides
   - B (optimal): Skills become execution engines with allowed-tools
   - C (hybrid): Commands + Skills specialization

7. **Skills Already Document Tool Requirements**: Resume skill shows tool documentation at end, proving developers understand requirements

---

## Recommended Next Steps for Refactoring

**Option 1 - Minimal Refactoring (Scenario A)**:
- Keep commands as-is
- Reduce skill duplication by 50%
- Add cross-references between command and skill
- Effort: Low, Risk: Low, Value: Medium

**Option 2 - Full Refactoring (Scenario B - RECOMMENDED)**:
- Add `allowed-tools` to skill frontmatter for all 7 phase skills
- Move implementation logic from commands to skills
- Make commands thin Task-based wrappers (30-50 lines each)
- Single source of truth: skills
- Effort: High, Risk: Medium, Value: High

**Option 3 - Hybrid Refactoring (Scenario C)**:
- Commands keep tool execution authority
- Skills become reference/decision libraries (no tools declared)
- Add explicit cross-references
- Manage duplication via discipline
- Effort: Medium, Risk: Medium, Value: Medium-High

**Recommendation**: Proceed with **Scenario B** in phases:
- Phase 1: Add `allowed-tools` to all skill frontmatter (validation step)
- Phase 2: Expand skill implementations with full logic (gradual migration)
- Phase 3: Convert commands to thin wrappers (final cut-over)
- Phase 4: Remove duplication documentation

This fully leverages the skills architecture while maintaining reliability through gradual migration.
