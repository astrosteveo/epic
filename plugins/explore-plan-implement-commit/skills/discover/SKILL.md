---
name: discover
description: Codebase mapping and external research. Documents what exists with file:line refs. Gathers validated knowledge from authoritative sources.
---

# Discover

## Overview

Two modes of information gathering: **codebase mapping** (document what exists) and **research** (gather validated external knowledge).

## Mode 1: Codebase Mapping

### Purpose

Document the existing codebase objectively. You are a camera, not a critic.

### Principles

- **No opinions** - Document what is, not what should be
- **No recommendations** - That's for design phase
- **File:line references** - Everything traceable
- **Complete coverage** - Architecture, patterns, constraints

### Process

1. Identify scope (what part of codebase is relevant)
2. Map architecture and structure
3. Document patterns and conventions
4. Note integration points
5. List constraints and limitations

### Output: `codebase.md`

```markdown
# Codebase Analysis: [Feature Name]

**Date:** YYYY-MM-DD
**Scope:** [What was analyzed]

## Architecture Overview

[High-level structure with file:line references]

## Relevant Patterns

### [Pattern Name]

[Documentation with file:line references]

## Integration Points

[Where new code will connect]

## Constraints

[Limitations discovered]
```

### Commit

After creating `codebase.md`:
```
explore: document codebase for [feature-name]
```

---

## Mode 2: Research

### Purpose

Gather validated knowledge from authoritative sources. Trust nothing from memory.

### Principles

- **Epistemic humility** - Assume you know nothing
- **Authoritative sources** - Official docs, specs, RFCs
- **Verify everything** - No stale training data
- **Document sources** - Every claim has attribution
- **Flag uncertainty** - Honest about gaps

### Process

1. Identify what needs researching (from codebase.md)
2. Fetch official documentation
3. Verify claims against authoritative sources
4. Cross-reference when possible
5. Document with full attribution

### Output: `research.md`

```markdown
# Research: [Feature Name]

**Date:** YYYY-MM-DD
**Technologies:** [List]

## Best Practices

### [Technology/Pattern]

**Source:** [URL]
**Retrieved:** YYYY-MM-DD

[Findings]

## Security Considerations

**Source:** [URL]

[Findings]

## Performance Guidance

**Source:** [URL]

[Findings]

## Sources

| Source | URL | Retrieved | Notes |
|--------|-----|-----------|-------|
```

### Commit

After creating `research.md`:
```
explore: research [technology/pattern] best practices
```

---

## What This Skill Does NOT Do

- Make recommendations (design phase)
- Critique existing code (you're a camera)
- Speculate or assume (verify everything)
- Use outdated training data (fetch current docs)
