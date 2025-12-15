# Documentation Research Template

Template for external documentation research with YAML frontmatter.

## Template

```markdown
---
type: research
topic: documentation
feature: {{SLUG}}
description: "{{GOAL_DESCRIPTION}}"
created: {{DATE}}
status: complete

technologies: []
  # - name: "React"
  #   version: "19.0.0"
  #   docs_url: "https://react.dev"

sources_consulted: 0
---

# Documentation Research: {{FEATURE}}

## Goal

{{GOAL_DESCRIPTION}}

## Documentation Reviewed

| Source | Version | Key Findings |
|--------|---------|--------------|
| Official Docs | x.y.z | Summary |

## Best Practices

### Practice 1: [Name]
- **Source**: URL or reference
- **Recommendation**: What to do
- **Rationale**: Why

### Practice 2: [Name]
- **Source**: URL or reference
- **Recommendation**: What to do
- **Rationale**: Why

## Library/Framework Versions

| Library | Current | Latest | Breaking Changes |
|---------|---------|--------|------------------|
| name | x.y.z | a.b.c | Yes/No - details |

## Code Examples

### Example 1: [Description]
```language
// Source: URL
code here
```

## Security Considerations

- Consideration 1
- Consideration 2

## Performance Considerations

- Consideration 1
- Consideration 2

## Recommendations Summary

1. Recommendation with rationale
2. Recommendation with rationale
```

## Frontmatter Fields

| Field | Description |
|-------|-------------|
| `type` | Always "research" |
| `topic` | Always "documentation" |
| `technologies[]` | Array of researched technologies with versions |
| `sources_consulted` | Count of documentation sources reviewed |
