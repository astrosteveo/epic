---
type: research
topic: codebase
feature: 005-unit-testing-claude-plugins
description: "Understand plugin structure, components, and testable units to design appropriate testing patterns"
created: 2025-12-14
status: complete

stats:
  files_analyzed: 47
  core_components: 5
  templates: 6
  agents: 4
  skills: 7

key_files:
  - path: ".claude-plugin/plugin.json"
    lines: "1-9"
    purpose: "Plugin manifest defining entry points and metadata"
  - path: "commands/*.md"
    lines: "varies"
    purpose: "Slash command definitions (7 total: explore, plan, implement, validate, commit, handoff, resume)"
  - path: "skills/epic-*/SKILL.md"
    lines: "varies"
    purpose: "Skill implementations with metadata frontmatter and workflow logic (7 skills)"
  - path: "agents/*.md"
    lines: "varies"
    purpose: "Subagent definitions with prompts and tool allowlists (4 agents)"
  - path: "templates/*.md"
    lines: "varies"
    purpose: "Artifact templates used by skills to structure output (6 templates)"
  - path: "skills/*/references/*.md"
    lines: "varies"
    purpose: "Skill-specific template references (8 reference templates)"
---

# Codebase Analysis: Unit Testing Claude Plugins

## Goal

Understand the plugin codebase structure, identify testable components, and document testing patterns that could apply to Claude Code plugins built on this workflow system.

## Summary

This is a Claude Code marketplace plugin implementing the "Frequent Intentional Compaction" (Explore-Plan-Implement) workflow. The plugin is structured into five layers: manifest (plugin.json), commands (slash command wrappers), skills (workflow phase logic), agents (research subagents), and templates (artifact structures). There are currently no test files in the codebase. The plugin is designed to be configuration-driven (markdown + YAML) rather than code-based, presenting unique testing challenges and opportunities.

## Plugin Architecture

### Layer 1: Plugin Manifest

**File**: `.claude-plugin/plugin.json:1-9`

```json
{
  "name": "epic",
  "version": "1.0.0",
  "description": "Structured workflow plugin: explore, plan, implement, validate, commit with artifact documentation",
  "author": { "name": "astrosteveo" },
  "keywords": ["workflow", "planning", "documentation", "checkpointing"]
}
```

The manifest is minimal — it registers the plugin name, version, and metadata. The plugin likely registers commands and skills through additional configuration not visible in this manifest alone. This is the entry point for the plugin system.

### Layer 2: Commands (Slash Command Entry Points)

**Directory**: `commands/`

**Files**: 7 command definitions (each 5-10 lines)

| Command | File | Purpose | Invokes |
|---------|------|---------|---------|
| `/epic:explore` | `commands/explore.md:1-6` | Research codebase and external docs | `epic:epic-explore` skill |
| `/epic:plan` | `commands/plan.md:1-5` | Create phased implementation plan | `epic:epic-plan` skill |
| `/epic:implement` | `commands/implement.md:1-6` | Execute implementation plan phase-by-phase | `epic:epic-implement` skill |
| `/epic:validate` | `commands/validate.md:1-6` | Run comprehensive project validation | `epic:epic-validate` skill |
| `/epic:commit` | `commands/commit.md:1-5` | Create documented commits | `epic:epic-commit` skill |
| `/epic:handoff` | `commands/handoff.md:1-5` | Create session handoff documents | `epic:epic-handoff` skill |
| `/epic:resume` | `commands/resume.md:1-5` | Resume from previous session | `epic:epic-resume` skill |

**Command Format** (all commands follow this structure):

```markdown
---
description: [brief description]
argument-hint: [optional arguments]
---

Invoke the `epic:[skill-name]` skill with: $ARGUMENTS
```

Commands are thin wrappers that parse arguments and delegate to skills. Each command has:
- YAML frontmatter with metadata
- Simple invocation logic that passes `$ARGUMENTS` to corresponding skill

### Layer 3: Skills (Core Workflow Logic)

**Directory**: `skills/`

**7 Skills** - One for each workflow phase, plus helper skills:

#### Skill Structure (all skills follow same pattern)

Each skill has:
1. **SKILL.md** - Main skill definition (80-200 lines)
2. **references/** - Markdown templates specific to that skill (1-3 templates)

#### Skill Metadata (YAML Frontmatter)

All skills defined in `SKILL.md` with this structure:

```yaml
---
name: epic-[phase]
description: [description]
allowed-tools:
  - [Tool names and constraints]
---

# [Skill Title]

[Workflow steps, logic, patterns]
```

#### Individual Skills:

**1. epic-explore** (`skills/epic-explore/SKILL.md:1-100+`)
- **Purpose**: Launch research agents to understand codebase and external docs
- **Allowed Tools**: Read, Write, Glob, Task, Bash(ls, mkdir, date)
- **Workflow**: Parse feature → determine research scope → create workflow directory → launch agents → wait for completion → update state
- **References**:
  - `skills/epic-explore/references/codebase-template.md` - Template for codebase research output
  - `skills/epic-explore/references/docs-template.md` - Template for docs research output
  - `skills/epic-explore/references/state-template.md` - Template for workflow state.md

**2. epic-plan** (`skills/epic-plan/SKILL.md:1-100+`)
- **Purpose**: Create phased implementation plans from research artifacts
- **Allowed Tools**: Read, Write, Edit, Glob, Grep, Task, TaskOutput
- **Workflow**: Locate workflow → verify Explore complete → load research → design phases → write plan → validate with agent → update state
- **References**:
  - `skills/epic-plan/references/plan-template.md` - Template for implementation plans with phase structure

**3. epic-implement** (`skills/epic-implement/SKILL.md:1-100+`)
- **Purpose**: Execute approved plan phase-by-phase with verification
- **Allowed Tools**: Read, Write, Edit, Glob, Grep, Bash(npm, npx, cargo, go, python, pytest, make, git status/diff), Task, TaskOutput, AskUserQuestion
- **Workflow**: Locate workflow → load plan → determine starting phase → for each phase: announce → make changes → verify → report → update state
- **References**:
  - `skills/epic-implement/references/progress-template.md` - Template for tracking implementation progress

**4. epic-validate** (`skills/epic-validate/SKILL.md:1-100+`)
- **Purpose**: Run comprehensive project validation (tests, lint, types, build)
- **Allowed Tools**: Read, Write, Edit, Glob, Bash(npm, npx, cargo, go, python, pytest, ruff, mypy, make, tsc)
- **Workflow**: Detect project type → run validation suite → capture results → write validation.md → report pass/fail
- **References**:
  - `skills/epic-validate/references/validation-template.md` - Template for validation results

**5. epic-commit** (`skills/epic-commit/SKILL.md:1-100+`)
- **Purpose**: Create well-documented commits using workflow artifacts
- **Allowed Tools**: Read, Glob, Edit, Bash(git:status, diff, add, commit, log, show), AskUserQuestion
- **Workflow**: Locate workflow → gather artifacts → analyze git state → pre-commit validation → draft commit → confirm with user → create commit
- **References**:
  - `skills/epic-commit/references/commit-template.md` - Template for commit messages

**6. epic-handoff** (`skills/epic-handoff/SKILL.md:1-100+`)
- **Purpose**: Create structured handoff documents for session transfer
- **Allowed Tools**: Read, Write, Glob, Bash(git:status, log, rev-parse, branch), AskUserQuestion
- **Workflow**: Locate workflow → gather context (git + artifacts) → generate timestamped path → create handoff document → update state
- **References**:
  - `skills/epic-handoff/references/handoff-template.md` - Template for handoff documents

**7. epic-resume** (`skills/epic-resume/SKILL.md:1-100+`)
- **Purpose**: Resume work from previous session via handoff or workflow state
- **Allowed Tools**: Read, Glob, AskUserQuestion
- **Workflow**: Parse argument → discover options → load selected item → determine phase → selectively load artifacts → present summary
- **Decision tree**: If path provided → validate → load | else discover options → present picker → load

### Layer 4: Agents (Research Subagents)

**Directory**: `agents/`

**4 Agent Definitions**:

#### 1. codebase-explorer (`agents/codebase-explorer.md:1-200+`)
- **Type**: Always launched by explore skill
- **Model**: haiku
- **Allowed Tools**: Glob, Grep, Read, Bash(ls, wc, file)
- **Purpose**: Document codebase structure, patterns, and implementation details
- **Behavior**: Facts-only approach (documents what IS, not what SHOULD BE)
- **Efficiency Rules**:
  - Grep first (output_mode: files_with_matches)
  - Glob second (narrow by path)
  - Read third (use offset/limit, never entire files)
  - Minimize tool calls (target: <25 for complex topics)
- **Output Format**: Structured markdown with file:line references

#### 2. docs-researcher (`agents/docs-researcher.md`)
- **Type**: Conditionally launched alongside codebase-explorer
- **Purpose**: Fetch and research external documentation
- **Triggers**: Feature mentions library/framework, involves security, requires new dependency, involves migration/upgrade
- **Output Format**: Markdown documentation summary

#### 3. plan-validator (`agents/plan-validator.md`)
- **Type**: Launched after plan written by epic-plan skill
- **Purpose**: Validate implementation plans for completeness and feasibility
- **Checks**: Research-based decisions, specific paths with line numbers, verifiable phases, complete rollback plan
- **Output**: Validation report or approval

#### 4. implementation-validator (`agents/implementation-validator.md`)
- **Type**: Launched during implementation verification
- **Purpose**: Verify code changes align with approved plan
- **Checks**: Files match plan, changes are at specified lines, completeness

### Layer 5: Artifact Templates

**Directory**: `templates/` + `skills/*/references/`

**6 Main Templates** (in templates/):

1. `templates/state.md` - Workflow state tracking (YAML frontmatter + markdown sections)
2. `templates/codebase.md` - Codebase research output structure
3. `templates/docs.md` - External documentation research structure
4. `templates/implementation-plan.md` - Implementation plan with phases and verification
5. `templates/handoff.md` - Session handoff document structure
6. `templates/validation-results.md` - Validation results summary

**8 Skill-Specific Reference Templates** (in skills/*/references/):

| Template | Skill | Purpose |
|----------|-------|---------|
| `skills/epic-explore/references/codebase-template.md` | epic-explore | Codebase analysis output format |
| `skills/epic-explore/references/docs-template.md` | epic-explore | Documentation research output format |
| `skills/epic-explore/references/state-template.md` | epic-explore | Initial workflow state format |
| `skills/epic-plan/references/plan-template.md` | epic-plan | Implementation plan format with phase structure |
| `skills/epic-implement/references/progress-template.md` | epic-implement | Progress tracking during implementation |
| `skills/epic-validate/references/validation-template.md` | epic-validate | Validation results format |
| `skills/epic-commit/references/commit-template.md` | epic-commit | Commit message format with workflow artifacts |
| `skills/epic-handoff/references/handoff-template.md` | epic-handoff | Handoff document format |

**Template Format Pattern**: All templates use YAML frontmatter + markdown sections with placeholders like `{{VARIABLE}}`

### File Organization

```
/home/astrosteveo/workspace/epic/
├── .claude-plugin/
│   └── plugin.json                          # Manifest
├── commands/                                 # 7 command files
│   ├── explore.md
│   ├── plan.md
│   ├── implement.md
│   ├── validate.md
│   ├── commit.md
│   ├── handoff.md
│   └── resume.md
├── skills/                                   # 7 skills with references
│   ├── epic-explore/
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── codebase-template.md
│   │       ├── docs-template.md
│   │       └── state-template.md
│   ├── epic-plan/
│   │   ├── SKILL.md
│   │   └── references/
│   │       └── plan-template.md
│   ├── epic-implement/
│   │   ├── SKILL.md
│   │   └── references/
│   │       └── progress-template.md
│   ├── epic-validate/
│   │   ├── SKILL.md
│   │   └── references/
│   │       └── validation-template.md
│   ├── epic-commit/
│   │   ├── SKILL.md
│   │   └── references/
│   │       └── commit-template.md
│   ├── epic-handoff/
│   │   ├── SKILL.md
│   │   └── references/
│   │       └── handoff-template.md
│   └── epic-resume/
│       └── SKILL.md
├── agents/                                   # 4 agent definitions
│   ├── codebase-explorer.md
│   ├── docs-researcher.md
│   ├── plan-validator.md
│   └── implementation-validator.md
├── templates/                                # 6 master templates
│   ├── state.md
│   ├── codebase.md
│   ├── docs.md
│   ├── implementation-plan.md
│   ├── handoff.md
│   └── validation-results.md
├── CLAUDE.md                                 # Plugin instructions & architecture guide
└── README.md                                 # User documentation
```

## Dependencies

### Internal Dependencies

**Commands → Skills**: All 7 commands delegate to corresponding skills:
- `/epic:explore` → `epic:epic-explore`
- `/epic:plan` → `epic:epic-plan`
- `/epic:implement` → `epic:epic-implement`
- `/epic:validate` → `epic:epic-validate`
- `/epic:commit` → `epic:epic-commit`
- `/epic:handoff` → `epic:epic-handoff`
- `/epic:resume` → `epic:epic-resume`

**Skills → Templates**: Each skill references and populates templates:
- `epic-explore` → uses codebase-template.md, docs-template.md, state-template.md
- `epic-plan` → uses plan-template.md
- `epic-implement` → uses progress-template.md
- `epic-validate` → uses validation-template.md
- `epic-commit` → uses commit-template.md
- `epic-handoff` → uses handoff-template.md

**Skills → Agents**: Some skills invoke agents:
- `epic-explore` invokes codebase-explorer (always) and docs-researcher (conditional)
- `epic-plan` invokes plan-validator (for validation)
- `epic-implement` invokes implementation-validator (optional)

**Cross-skill Dependencies**:
- `epic-plan` depends on `epic-explore` completion (reads codebase-research.md and docs-research.md)
- `epic-implement` depends on `epic-plan` completion (reads plan.md)
- `epic-validate` can run after `epic-implement` (verifies implementation)
- `epic-commit` depends on completion of previous phases (reads artifacts from workflow directory)
- `epic-handoff` reads artifacts from workflow directory
- `epic-resume` reads workflow state or handoff documents

### External Dependencies

The codebase does NOT depend on external npm packages or libraries. It uses only:
- Claude Code built-in tools (Read, Write, Edit, Glob, Grep, Bash, Task, AskUserQuestion)
- Bash commands for build tools detection (npm, cargo, go, python, pytest, make, etc.)

## Workflow Artifacts (Runtime Structure)

The plugin creates structured artifacts at runtime:

```
.claude/workflows/NNN-[feature-slug]/
├── state.md                      # Current workflow state (created by epic-explore)
├── codebase-research.md          # Research findings (created by codebase-explorer agent)
├── docs-research.md              # External docs (created by docs-researcher agent, optional)
├── plan.md                        # Implementation plan (created by epic-plan)
└── validation.md                 # Validation results (created by epic-validate)

.claude/handoffs/[feature-slug]/
└── YYYY-MM-DD_HH-MM-SS_[description].md    # Handoff documents (created by epic-handoff)
```

Each artifact follows a template structure with YAML frontmatter and markdown sections.

## Test File Structure

**Current State**: NO test files exist in the codebase. No npm package.json, pytest.ini, Makefile, or test directories found.

This plugin is distributed as markdown configuration files, not as compiled or installable code.

## Testable Units Identified

### 1. Command Entry Points (Thin Wrappers)

**What to test**:
- Argument parsing (command-line flags like `--phase N`, `--continue`, `--fix`, `--skip-tests`)
- Correct skill delegation with arguments passed through
- Fallback behavior (default arguments)

**Test Examples**:
- `/epic:explore "add authentication"` → should invoke epic-explore skill with correct prompt
- `/epic:implement --phase 2` → should invoke epic-implement with phase=2
- `/epic:validate --fix --skip-tests` → should pass both flags to epic-validate

**Challenges**: Commands are simple YAML + markdown wrappers. Testing would require mocking the Skill tool.

### 2. Skill Logic Validation

**What to test**:
- Workflow state machine (explore → plan → implement → validate → commit)
- Prerequisite checking (e.g., Can't plan before exploring)
- File I/O (reading/writing artifacts, templates)
- Agent invocation and result handling
- Error handling and recovery

**Test Examples**:
- Attempting `epic:plan` without completing `epic:explore` should fail with clear message
- `epic:implement --phase 5` when plan has only 3 phases should handle gracefully
- `epic-validate` should detect project type (Node.js/Rust/Go/Python) correctly
- Skills should create artifacts in correct directory structure

**Challenges**: Skills invoke many tools (Read, Write, Bash, etc.). Testing requires:
- Mock filesystem
- Mock tool responses
- State machine validation

### 3. Artifact Structure Validation

**What to test**:
- YAML frontmatter validity (valid structure, required fields present)
- Markdown sections match template expectations
- Variable substitution in templates ({{VARIABLE}} → actual values)
- File:line references validity (when codebase is present)
- Cross-artifact consistency (state.md references plan.md at correct path)

**Test Examples**:
- state.md should have valid YAML frontmatter with required fields: feature, description, created, workflow, agents
- plan.md should have phases with structure: Changes table, Implementation Details, Verification sections
- codebase-research.md should have file:line references matching actual codebase files (if present)

**Challenges**: Artifact validation is partially structural (YAML/markdown parsing) and partially semantic (do references point to real files?).

### 4. Agent Prompt & Behavior

**What to test**:
- codebase-explorer agent prompt clarity
- docs-researcher decision logic (when to launch)
- Agent tool allowlist correctness (does agent have tools it needs?)
- Output format consistency (agent produces markdown matching template)

**Test Examples**:
- codebase-explorer prompt should contain clear instructions about file:line references
- docs-researcher should only be launched when feature mentions external libraries
- Agent output should match template structure from references/
- Tools listed in agent frontmatter should match what agent actually uses

**Challenges**: Agents are prompts, not code. Behavior testing would require running actual agents or mocking agent responses.

### 5. Template Structure & Placeholders

**What to test**:
- All template files have valid YAML frontmatter
- Placeholders like {{VARIABLE}} are consistent across templates
- Markdown structure is valid
- Template examples are syntactically correct

**Test Examples**:
- All .md files have YAML frontmatter with `---` delimiters
- Placeholder names are consistent ({{FEATURE}} vs {{SLUG}} vs {{feature-slug}})
- Phase structure in plan-template.md has all required sections
- state.md frontmatter has correct field names (not feature_name vs feature)

**Challenges**: Templates are static files. Testing is mostly structural validation.

## Data Flow

### Full Workflow Flow

```
User Input: /epic:explore "add authentication"
    ↓
Command: commands/explore.md
    ↓
Skill: epic-explore
    ├─ Parse feature description
    ├─ Determine research scope
    ├─ Create .claude/workflows/001-add-authentication/
    ├─ Launch agents (in background):
    │  ├─ codebase-explorer → produces codebase-research.md
    │  └─ docs-researcher (conditional) → produces docs-research.md
    ├─ Wait for agent completion
    ├─ Update state.md
    └─ Present summary

Artifacts Created:
    ├─ .claude/workflows/001-add-authentication/state.md (from state-template.md)
    ├─ .claude/workflows/001-add-authentication/codebase-research.md (from codebase-template.md)
    └─ .claude/workflows/001-add-authentication/docs-research.md (from docs-template.md, optional)

User Input: /epic:plan
    ↓
Command: commands/plan.md
    ↓
Skill: epic-plan
    ├─ Locate .claude/workflows/001-add-authentication/state.md
    ├─ Verify Explore phase complete
    ├─ Load codebase-research.md and docs-research.md
    ├─ Design atomic, verifiable phases
    ├─ Write plan.md (from plan-template.md)
    ├─ Invoke plan-validator agent (optional)
    ├─ Update state.md
    └─ Present plan for review

Artifacts Created/Updated:
    ├─ .claude/workflows/001-add-authentication/plan.md
    └─ .claude/workflows/001-add-authentication/state.md (updated)

[Continue with implement → validate → commit → handoff → resume]
```

### State Machine

```
                     ┌─────────────┐
                     │   START     │
                     └──────┬──────┘
                            │
                    /epic:explore
                            │
                     ┌──────▼──────┐
         ┌──────────►│   EXPLORE   │
         │           │  (research) │
         │           └──────┬──────┘
         │                  │
         │          /epic:plan (requires explore complete)
         │                  │
         │           ┌──────▼──────┐
         │           │    PLAN     │◄────┐
         │           │ (design)    │     │ Can cycle back for refinement
         │           └──────┬──────┘─────┘
         │                  │
         │         /epic:implement (requires plan complete)
         │                  │
         │           ┌──────▼─────────┐
         │           │  IMPLEMENT     │
         │           │ (phase-by-phase)
         │           └──────┬─────────┘
         │                  │
         │         /epic:validate (after implementation)
         │                  │
         │           ┌──────▼──────┐
         │           │  VALIDATE   │
         │           │(tests/lint) │
         │           └──────┬──────┘
         │                  │
         │          /epic:commit (after validation)
         │                  │
         │           ┌──────▼──────┐
         │           │   COMMIT    │
         │           │  (git)      │
         │           └──────┬──────┘
         │                  │
         │         /epic:handoff (at any point)
         │                  │
         │           ┌──────▼──────┐
         └───────────│   HANDOFF   │
                     │(session end)│
                     └──────┬──────┘
                            │
                   /epic:resume (next session)
                            │
                      [resume at any phase]
```

## Patterns Observed

### 1. YAML Frontmatter Pattern
All artifact files and definitions use YAML frontmatter to store metadata:
- **Frontmatter Location**: Between `---` delimiters at file start
- **Common Fields**: `type`, `feature`, `created`, `status`, `description`
- **Purpose**: Machine-readable metadata for discovery, filtering, sorting

### 2. Tool Allowlist Pattern
All skill and agent definitions have `allowed-tools` sections:
- **Purpose**: Explicit declaration of what tools a skill/agent can use
- **Format**: Array of tool names with optional constraints (e.g., `Bash(npm:*, git:status)`)
- **Benefit**: Security, clarity about dependencies, testability

### 3. Template with Placeholders Pattern
All templates use `{{VARIABLE}}` placeholders:
- **Purpose**: Skills populate templates with actual values
- **Common Placeholders**: `{{SLUG}}`, `{{FEATURE}}`, `{{GOAL_DESCRIPTION}}`, `{{DATE}}`
- **Consistency Issue**: Some templates use `{{feature}}` (lowercase), others `{{FEATURE}}` (uppercase)

### 4. File:Line Reference Pattern
Codebase research and documentation uses `file:line` references:
- **Format**: `path/to/file.ts:45-67` for ranges, `path/to/file.ts:45` for single lines
- **Purpose**: Precise code location documentation enabling bidirectional tracing
- **Used in**: codebase-research.md, plan.md (file changes), handoff.md (recent changes)

### 5. Hierarchical Task Status Pattern
Workflow state uses hierarchical status tracking:
- **Levels**: Feature → Phase → Agent/Task
- **Status Values**: `pending`, `in_progress`, `complete`
- **Purpose**: Track which parts of workflow are done, what's next

### 6. Background Agent Pattern
Skills invoke research agents using background execution:
- **Mechanism**: Task tool with `run_in_background: true`
- **Purpose**: Main context stays clean while agents research in background
- **Wait Pattern**: Use TaskOutput to wait for agent completion (blocking)

### 7. Artifact Discovery Pattern
Skills discover workflow/handoff documents using Glob:
- **Workflow Discovery**: `Glob("**/state.md")` to find active workflows
- **Handoff Discovery**: `Glob(".claude/handoffs/**/*.md")` to find all handoffs
- **Sorting**: Sort by date for "most recent" selection

### 8. Conditional Launch Pattern
epic-explore conditionally launches docs-researcher:
- **Decision Rule**: Launch when feature mentions library/framework, security, migration, etc.
- **Default**: Always launch codebase-explorer, optionally launch docs-researcher
- **User Override**: Skill asks user if unclear

## Integration Points

### Command ↔ Skill
- **Location**: `commands/[name].md` → calls `epic:epic-[name]` skill
- **Mechanism**: Passes `$ARGUMENTS` directly to skill
- **Purpose**: Commands are thin entry points; skills contain logic

### Skill ↔ Template
- **Location**: Skill reads from `references/[template-name].md`
- **Mechanism**: Read template file, substitute {{VARIABLES}}, Write to artifact location
- **Pattern**: Each skill knows its template path, reads it, populates it, writes to workflow directory

### Skill ↔ Agent
- **Location**: Skill invokes agent via Task tool
- **Mechanism**: Task with `subagent_type: epic:[agent-name]` and `run_in_background: true`
- **Wait**: Skill calls TaskOutput to wait for agent result (blocking with `block: true`)
- **Data Transfer**: Agent writes artifact file directly to workflow directory

### Skill ↔ Workflow State
- **Location**: State file at `.claude/workflows/[NNN-slug]/state.md`
- **Mechanism**: Each phase reads state.md, updates it with progress, writes back
- **Pattern**: YAML frontmatter tracks phase status, markdown sections track tasks/deviations

### Agent ↔ Artifact
- **Location**: Agent writes directly to workflow directory using Write tool
- **Pattern**: Agent has artifact path in prompt, writes to `.claude/workflows/[slug]/[artifact-name].md`
- **Template**: Agent output follows template structure from `references/[template-name].md`

### Handoff ↔ Workflow
- **Location**: Handoff documents reference workflow by slug and path
- **Pattern**: Handoff has section "Artifacts" listing workflow directory contents
- **Resume**: epic-resume reads handoff, extracts workflow path, resumes from state in that workflow

## Open Questions

1. **Plugin Registration**: How are commands and skills registered in the plugin system? The plugin.json is minimal. Are there other registration files?

2. **Test Framework**: What test framework/runner would be appropriate for markdown-based configuration files? (Structural validation? Behavior simulation? Integration testing?)

3. **Agent Validation**: How should agent behavior be tested? The agents are prompt-based and invoke other agents (codebase-explorer uses Grep/Glob/Read, which can't be fully mocked without a test codebase).

4. **Artifact Evolution**: Are artifacts ever modified after creation, or are they write-once? (state.md appears to be updated multiple times across phases, suggesting read-modify-write patterns)

5. **Error Handling**: How should skills handle errors from tools (e.g., Read fails on missing file, Bash fails on command error)? Current documentation shows happy path but not error cases.

6. **Template Consistency**: Should placeholder names be standardized? Some use {{FEATURE}}, others {{feature}}, some {{SLUG}}, some {{slug}}.

7. **Extensibility**: Can users add custom commands/skills? Is the plugin designed for that, or is it a fixed set of 7 commands?

8. **Package Build**: The handoff mentions `.skill` package files as build artifacts. How are skills packaged? What does `skill-creator` do?

## Constraints & Considerations

### Plugin Constraints
- **No JavaScript/Python Code**: Plugin is pure markdown configuration with embedded YAML. No compiled code to test.
- **Tool Dependency**: All skills depend on Claude Code tool execution (Read, Write, Bash, etc.). Testing requires tool mocking or simulation.
- **Background Agents**: Complex async patterns with agent invocation. State consistency across async boundaries could be fragile.
- **Markdown Parsing**: No validation that markdown frontmatter is valid YAML until runtime.

### Workflow Constraints
- **Sequential Phases**: Workflow assumes strict phase ordering (explore → plan → implement). Skipping phases not supported.
- **File System Assumptions**: Artifacts assume specific directory structure (`.claude/workflows/NNN-slug/`). No handling for conflicting directory names.
- **Git Assumptions**: Some skills assume git repository exists (epic-commit, epic-handoff). No fallback for non-git projects.
- **Agent Availability**: workflow depends on background agent execution. If agents fail, entire workflow stalls.

### Testing Constraints
- **No Test Fixtures**: No example workflows, artifacts, or codebases available to test against.
- **Tool Mocking**: Testing skills requires mocking all tools (Read, Write, Bash, Task, TaskOutput, etc.).
- **Behavior Complexity**: Workflow logic is distributed across multiple skills and agents. End-to-end testing would be complex.
- **External Dependencies**: Validation skill detects npm/cargo/go/python projects and runs their test frameworks. Hard to test without having all build tools available.

## Summary of Testable Units

| Unit | Type | Complexity | Test Approach |
|------|------|-----------|---|
| Command argument parsing | Structure | Low | Parse YAML frontmatter, validate field names |
| Skill invocation delegation | Integration | Medium | Mock Skill tool, verify correct skill + args |
| Artifact YAML structure | Structure | Low | Parse frontmatter, validate required fields |
| Artifact markdown sections | Structure | Low | Verify expected sections present |
| Template placeholder substitution | Logic | Low | Load template, verify {{}} syntax, test substitution |
| Workflow state machine | Logic | High | Mock artifact I/O, test phase transitions |
| Phase prerequisite checking | Logic | Medium | Test "can't plan before explore" scenarios |
| Agent invocation | Integration | High | Mock Task tool, verify agent parameters |
| Project type detection | Logic | Medium | Test detection logic for npm/cargo/go/python |
| Artifact discovery (Glob) | Integration | Medium | Mock Glob tool, test sorting/filtering |
| Git command execution | Integration | Medium | Mock Bash tool, verify git commands |
| Error handling | Logic | Medium | Test error paths (missing files, tool failures) |

## Key Artifacts and Thresholds

### File Format Standards
- **Command files**: 5-10 lines, YAML frontmatter + simple invocation
- **Skill files**: 80-200+ lines, YAML frontmatter + detailed workflow steps
- **Agent files**: 100-200 lines, YAML frontmatter + system prompt/instructions
- **Template files**: 50-100 lines, YAML frontmatter + markdown sections with placeholders
- **Workflow artifacts**: 30-150 lines (varies by artifact type)
- **Handoff documents**: 50-100 lines, compact format targeting <200 lines

### Naming Conventions
- **Commands**: kebab-case, match skill names (explore.md → epic:epic-explore)
- **Skills**: `epic-[phase]` pattern (epic-explore, epic-plan, epic-implement, epic-validate, epic-commit, epic-handoff, epic-resume)
- **Templates**: descriptive names with -template suffix (state-template.md, plan-template.md)
- **Artifacts**: [artifact-type]-[feature-slug] (codebase-research.md, plan.md, state.md, validation.md)
- **Handoffs**: YYYY-MM-DD_HH-MM-SS_[description].md format

### Information Density
- **Commands**: 100% overhead (no logic, pure delegation)
- **Skills**: 20% structure (frontmatter) + 80% logic (workflow steps)
- **Agents**: 10% structure + 90% prompt/instructions
- **Templates**: 20% structure (frontmatter) + 80% markdown sections
