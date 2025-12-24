---
name: research
description: Use after explore to gather validated external knowledge. Operates with epistemic humility - assumes nothing, validates everything. Outputs research.md.
---

# Research

## Overview

Gather validated external knowledge to inform the design. This skill takes the codebase analysis from `explore` and researches best practices, patterns, and current documentation for the technologies involved.

**Input:** `.workflow/NNN-feature-slug/codebase.md`
**Output:** `.workflow/NNN-feature-slug/research.md`

**Announce at start:** "I'm using the research skill to gather validated best practices and current documentation."

## Core Principle: Epistemic Humility

**Assume you know nothing.** All knowledge must be validated.

- **Must fetch/verify** all information from authoritative sources
- **Never rely** on training knowledge that could be outdated
- **Document sources** for every claim
- **No speculation** - only validated truths

**Exception:** Truly immutable standards that never change (e.g., Java's `com.sun.net.httpserver` package API, HTTP status codes, SQL syntax) may be referenced without re-fetching.

## Global Rule: Asking Questions

**ONE question at a time. Always.**

When you need user input (e.g., to resolve conflicting guidance or fill gaps), use the AskUserQuestion tool pattern:

1. **Use multiple choice when possible** (2-4 options)
2. **Lead with your recommendation** - mark it clearly with "(Recommended)"
3. **Always include "Other"** - user can provide free text
4. **Single-select for mutually exclusive choices**

**Format:**

```
[Brief context for the question]

**A) [Option Name]** (Recommended)
   [1-2 sentence description of what this means]

**B) [Option Name]**
   [1-2 sentence description]

**C) [Option Name]**
   [1-2 sentence description]

**D) Other**
   [Tell me what you're thinking]
```

**Wait for response before asking next question.**

## When to Use

- After `explore` skill completes
- User says "research", "best practices", "how should this be done"
- Invoked directly via `/research`
- Before `design-writer` skill (research informs architecture decisions)

## The Process

### Phase 1: Load Context

**Goal:** Understand what we're building and what needs researching.

1. Read `.workflow/NNN-feature-slug/codebase.md`
2. Identify technologies and patterns in use
3. Determine what external knowledge is needed

```
"Based on the codebase analysis, I need to research:

**Technologies:** [List from codebase.md]
**Key areas to research:**
- [Area 1]: [Why we need current info]
- [Area 2]: [Why we need current info]

I'll fetch current documentation and best practices for each. This may take a moment."
```

### Phase 2: Fetch and Validate

**Goal:** Gather verified information from authoritative sources.

**For each technology/pattern:**

1. **Fetch official documentation**
   - Use WebSearch to find current docs
   - Use WebFetch to retrieve content
   - Verify the source is authoritative

2. **Validate claims**
   - Cross-reference multiple sources when possible
   - Check publication dates
   - Identify deprecated patterns

3. **Document sources**
   - Record URLs
   - Note retrieval date
   - Flag any uncertainty

**Research areas:**

```
1. Current best practices
   - Official documentation
   - Framework/library guides
   - Style guides and conventions

2. Integration patterns
   - How technologies work together
   - Common pitfalls documented
   - Recommended approaches

3. Security considerations
   - OWASP guidelines (if applicable)
   - Framework security docs
   - Known vulnerabilities

4. Performance guidance
   - Official performance docs
   - Benchmarking recommendations
   - Optimization patterns
```

**For each finding, verify:**
- Is this from an authoritative source?
- Is this current (check dates)?
- Does this apply to our version/context?

### Phase 3: Synthesis

**Goal:** Organize findings into actionable guidance.

**Do NOT:**
- Speculate beyond what sources say
- Fill gaps with assumptions
- Recommend without source backing

**Do:**
- Synthesize findings clearly
- Note conflicts between sources
- Flag areas with insufficient information

```
"I've completed the research. Key findings:

**Validated best practices:**
- [Practice 1] - Source: [link]
- [Practice 2] - Source: [link]

**Areas with uncertainty:**
- [Area]: [Why we need more info or user input]

Ready to document these findings?"
```

### Phase 4: Documentation

**Goal:** Create research.md with full source attribution.

**Write `.workflow/NNN-feature-slug/research.md`:**

```markdown
# Research: [Feature Name]

**Date:** YYYY-MM-DD
**Status:** Research complete, ready for design
**Codebase Analysis:** [Link to codebase.md]

## Research Summary

**Technologies researched:**
- [Tech 1] - [version if applicable]
- [Tech 2] - [version if applicable]

**Key findings:**
- [Finding 1]
- [Finding 2]

---

## Best Practices

### [Technology/Pattern 1]

**Source:** [Official documentation URL]
**Retrieved:** YYYY-MM-DD

**Current recommendations:**
- [Recommendation 1]
- [Recommendation 2]

**Deprecated patterns to avoid:**
- [Pattern]: [Why deprecated]

### [Technology/Pattern 2]

**Source:** [URL]
**Retrieved:** YYYY-MM-DD

[Same structure]

---

## Integration Patterns

### [Integration Area]

**Source:** [URL]
**Retrieved:** YYYY-MM-DD

**Recommended approach:**
[Description with source backing]

**Common pitfalls:**
- [Pitfall 1]: [How to avoid] - Source: [URL]

---

## Security Considerations

**Sources:**
- [Security doc URL]
- [OWASP reference if applicable]

**Requirements:**
- [Security requirement 1]
- [Security requirement 2]

---

## Gaps and Uncertainties

**Areas requiring user input:**
- [Area]: [What we couldn't determine from sources]

**Conflicting guidance:**
- [Topic]: [Source A says X, Source B says Y]

---

## Sources

| Source | URL | Retrieved | Notes |
|--------|-----|-----------|-------|
| [Name] | [URL] | YYYY-MM-DD | [Relevance] |
| [Name] | [URL] | YYYY-MM-DD | [Relevance] |
```

## Handoff

After writing research.md:

```
I've completed the research and saved it to `.workflow/NNN-feature-slug/research.md`.

**Key findings:**
- [Most important finding 1]
- [Most important finding 2]

**Gaps to address:** [Any areas needing user input, or "None"]

What's next?

**A) Run `/design-writer`** (Recommended)
   I'll architect the solution based on these findings

**B) Review the research first**
   Let's look at what I found before moving on

**C) Research more areas**
   There's something else I should look into

**D) Other**
   Something else in mind
```

**If there are gaps requiring user input, ask about them first (one at a time):**

```
The research found conflicting guidance on [topic]:

**A) [Approach from Source A]** (Recommended)
   [Why this is recommended based on our context]

**B) [Approach from Source B]**
   [Trade-offs of this approach]

**C) [Approach from Source C]**
   [Trade-offs of this approach]

**D) Other**
   Different approach in mind

Which approach fits your needs?
```

**IMPORTANT:** When user selects option A, invoke the `design-writer` skill using the Skill tool. Do NOT proceed to implementation or trigger built-in plan mode.

## Key Principles

- **ONE question at a time** - Never batch questions
- **Multiple choice first** - Easier than open-ended
- **Always include "Other"** - User can provide free text
- **Lead with recommendation** - Mark it clearly with "(Recommended)"
- **Epistemic humility** - Assume you know nothing
- **Validate everything** - Fetch from authoritative sources
- **Document sources** - Every claim needs attribution
- **No speculation** - Only state what sources confirm
- **Flag uncertainty** - Be honest about gaps
- **Current information** - Training data may be stale

## Red Flags

**Never:**
- Ask multiple questions at once
- Present options without a recommendation
- Skip the "Other" option
- State facts without sources
- Rely on training knowledge for rapidly-changing topics
- Guess at best practices
- Skip source verification
- Assume documentation hasn't changed

**Always:**
- One question at a time
- Use multiple choice format for user input
- Include your recommendation
- Include "Other" for free text
- Wait for response before next question
- Fetch current documentation
- Verify source authority
- Document retrieval dates
- Note version-specific guidance
- Flag areas of uncertainty
- Cross-reference when possible
