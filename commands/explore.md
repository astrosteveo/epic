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

# Explore Phase

Execute the **Explore** phase of the Frequent Intentional Compaction workflow.

Launch parallel research agents to understand the codebase and gather external best practices before planning any changes.

## Input

**Feature to explore:** $ARGUMENTS

If no feature description provided, ask user what they want to explore.

## Process

### 1. Initialize Artifact Directory

Determine the next sequence number:
```bash
ls .claude/workflows/ 2>/dev/null | grep -E '^[0-9]{3}-' | sort | tail -1
```

Generate a kebab-case slug from the feature description:
- "add user authentication" → `add-user-authentication`
- "fix payment bug" → `fix-payment-bug`

Create directory structure:
```bash
mkdir -p .claude/workflows/[NNN]-[slug]/research
mkdir -p .claude/workflows/[NNN]-[slug]/plans
mkdir -p .claude/workflows/[NNN]-[slug]/implementation
mkdir -p .claude/workflows/[NNN]-[slug]/validation
```

### 2. Launch Background Research Agents

Launch **BOTH** agents in a **single message** with two Task tool calls, both with `run_in_background: true`:

#### Agent 1: codebase-explorer

```
Task tool parameters:
  subagent_type: explore-plan-implement:codebase-explorer
  run_in_background: true
  prompt: |
    Explore this codebase to understand: [feature description]

    Document your findings to: .claude/workflows/[NNN-slug]/research/codebase.md

    Focus on:
    - Relevant files with file:line references
    - Code flow and data flow
    - Existing patterns to follow
    - Dependencies and constraints
    - Integration points

    Use template structure from: ${CLAUDE_PLUGIN_ROOT}/templates/codebase.md
```

#### Agent 2: docs-researcher

```
Task tool parameters:
  subagent_type: explore-plan-implement:docs-researcher
  run_in_background: true
  prompt: |
    Research external documentation and best practices for: [feature description]

    Document your findings to: .claude/workflows/[NNN-slug]/research/docs.md

    Focus on:
    - Official documentation for relevant libraries
    - Current versions and breaking changes
    - Security best practices
    - Performance considerations
    - Authoritative code examples

    Use template structure from: ${CLAUDE_PLUGIN_ROOT}/templates/docs.md
```

**Critical:**
- Both agents MUST be launched in parallel (single message, two tool calls)
- Both MUST use `run_in_background: true` to keep main context clean
- Note the task IDs returned for later retrieval

### 3. Create State File

After launching agents, create the workflow state tracker:

```markdown
# Workflow State

**Feature**: [feature description]
**Slug**: [NNN-slug]
**Directory**: .claude/workflows/[NNN-slug]
**Current Phase**: explore
**Last Updated**: [ISO date]

## Background Agents

| Agent | Task ID | Status |
|-------|---------|--------|
| codebase-explorer | [task-id-1] | running |
| docs-researcher | [task-id-2] | running |

## Phase Status

| Phase | Status | Artifact |
|-------|--------|----------|
| Explore | in_progress | research/*.md |
| Plan | pending | plans/implementation-plan.md |
| Implement | pending | implementation/progress.md |
| Validate | pending | validation/results.md |
| Commit | pending | git commit |
```

Write to: `.claude/workflows/[NNN-slug]/state.md`

### 4. Retrieve Background Agent Results

Use `TaskOutput` to collect results from both background agents:

```
TaskOutput tool parameters:
  task_id: [codebase-explorer task ID from step 2]
  block: true  # Wait for completion
  timeout: 300000  # 5 minute timeout
```

```
TaskOutput tool parameters:
  task_id: [docs-researcher task ID from step 2]
  block: true
  timeout: 300000
```

**Note:** You can call both TaskOutput tools in parallel to wait for both agents simultaneously.

After both agents complete, verify artifacts exist:
- `.claude/workflows/[NNN-slug]/research/codebase.md`
- `.claude/workflows/[NNN-slug]/research/docs.md`

Update `state.md`: Set Explore status to "complete".

### 5. Present Summary

Provide a brief summary to the user:

```
## Explore Phase Complete

**Feature**: [description]
**Artifacts**: .claude/workflows/[NNN-slug]/

### Codebase Findings
- [X] relevant files identified
- Key patterns: [list]
- Integration points: [list]

### External Research
- [X] documentation sources reviewed
- Recommended approach: [summary]
- Key considerations: [list]

### Open Questions
- [Any questions requiring human input]

---

**Next Step**: Review the research artifacts, then run `/plan`

⚠️ Review research before planning - errors here cascade to 1000s of bad lines of code.
```

## Output Format

### Success
```
✓ Explore Phase Complete

Feature: [description]
Directory: .claude/workflows/[NNN-slug]/

Research Artifacts:
- codebase.md ([X] files documented)
- docs.md ([Y] sources cited)

**Context**: ~[X]K / 200K tokens ([Y]%)

Next: Review artifacts, then run `/plan`
```

### Blocked
```
⚠️ Explore Phase Incomplete

Issue: [specific problem]
- Agent failed: [which one]
- Missing: [what's missing]

Resolution: [specific action]
```

## Context Efficiency

This command delegates heavy exploration to **background subagents** to keep the main context clean and allow parallel work.

**DO:**
- Launch agents with `run_in_background: true`
- Use `TaskOutput` with `block: true` to wait for results
- Let agents do the searching and reading
- Keep summaries concise
- Focus on actionable findings

**DON'T:**
- Read large files in main context
- Duplicate agent work
- Include raw search results
- Forget to track task IDs for retrieval

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

## Important

1. **Background agents** - Launch both with `run_in_background: true` in a single message
2. **Task ID tracking** - Record task IDs in state.md for retrieval with TaskOutput
3. **Facts only** - Research documents contain observations, not suggestions
4. **file:line references** - All code locations must be precisely referenced
5. **State tracking** - state.md enables fresh session resumption (includes task IDs)
6. **Human review** - Remind user this is the highest-leverage review point
