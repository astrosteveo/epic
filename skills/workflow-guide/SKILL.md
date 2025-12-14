# Frequent Intentional Compaction Workflow

This skill provides guidance on the explore-plan-implement workflow for effective AI-assisted development in complex codebases.

## When to Use This Skill

Load this skill when the user asks about:
- "How does the explore-plan-implement workflow work?"
- "When should I use /explore vs just coding?"
- "What is frequent intentional compaction?"
- "How do I work effectively with AI in large codebases?"
- "Why isn't my AI coding working in this codebase?"

## The Core Problem

AI coding tools struggle with complex, brownfield codebases. The Stanford study found:
- AI-generated code often gets reworked shortly after being committed
- AI works well for greenfield/simple tasks but is often counter-productive for brownfield/complex work

The solution is **context engineering** - deliberately managing what information the AI has access to.

## The Workflow

```
/explore → /plan → /implement → /validate → /commit
```

### Phase 1: Explore

**Purpose**: Build understanding through structured research before making any changes.

**What it does**:
- Launches parallel subagents for codebase exploration and external research
- Produces structured documents with `file:line` references
- Documents FACTS only - no suggestions or premature solutions

**When to use**:
- Working in unfamiliar codebase areas
- Complex features touching multiple files
- When you need to understand existing patterns first

**Human review focus**: HIGH - errors in research cascade to 1000s of bad lines of code

### Phase 2: Plan

**Purpose**: Design the implementation approach with verification steps.

**What it does**:
- Reads research artifacts (NOT training data assumptions)
- Creates phased plan with specific file changes
- Includes automated and manual verification per phase

**Key principle**: The plan requires human approval before implementation begins.

**Human review focus**: HIGH - errors in planning cascade to 100s of bad lines of code

### Phase 3: Implement

**Purpose**: Execute the approved plan phase by phase.

**What it does**:
- Follows the plan exactly
- Runs verification after each phase
- STOPS if reality diverges from plan
- Updates progress tracking

**Key principle**: If the plan doesn't match reality, stop and communicate rather than improvise.

**Human review focus**: MEDIUM - errors are localized to specific code

### Phase 4: Validate

**Purpose**: Run comprehensive project validation.

**What it does**:
- Auto-detects project type (Node/Rust/Python/Go)
- Runs tests, linting, type checking, build
- Produces validation report

### Phase 5: Commit

**Purpose**: Create well-documented commit with artifact references.

**What it does**:
- Gathers all artifacts for context
- Creates conventional commit with artifact links
- Requires user confirmation

## Context Management

Keep context utilization at **40-60%**. Higher utilization degrades output quality.

**What eats context** (avoid in main session):
- Excessive grep/glob/read operations
- Full test/build output
- Large JSON blobs

**Solution**: Use subagents for exploration. They use separate context windows and return only summarized findings.

## The Leverage Hierarchy

```
Error in Research → 1000s of bad lines of code
Error in Plan     → 100s of bad lines of code
Error in Code     → ~1 bad line of code
```

Focus human attention on **Research > Plan > Code**.

This is the opposite of traditional code review where 100% of attention goes to final code. With this workflow, most review effort should be on research and plan artifacts.

## Artifact Structure

All workflow artifacts go in `docs/NNN-feature-slug/`:

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

These artifacts:
- Serve as documentation for the change
- Enable team mental alignment without reading all code
- Support resuming work after context compaction
- Get committed with the code for traceability

## When NOT to Use This Workflow

Skip the full workflow for:
- Single-line fixes
- Trivial changes where the approach is obvious
- Areas you're deeply familiar with

Use the full workflow for:
- Complex multi-file changes
- Unfamiliar codebase areas
- Features requiring external research
- Work that needs team review/alignment

## References

- [VISION.md](${CLAUDE_PLUGIN_ROOT}/.claude/rules/VISION.md) - Full methodology background
- [Templates](${CLAUDE_PLUGIN_ROOT}/templates/) - Artifact templates
