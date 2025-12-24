---
name: design
description: Use after research to design the architecture and technical approach. Synthesizes codebase analysis and research findings into a concrete technical design. Outputs design.md.
---

# Design

## Overview

Transform discovery into architecture. This skill takes the codebase analysis from `explore` and the validated research from `research`, then works with the user to create a concrete technical design.

**Input:**
- `.workflow/NNN-feature-slug/codebase.md`
- `.workflow/NNN-feature-slug/research.md`

**Output:**
- `.workflow/NNN-feature-slug/design.md`
- `.workflow/NNN-feature-slug/contracts.md` (optional)

**Announce at start:** "I'm using the design skill to architect this feature based on our codebase analysis and research findings."

## When to Use

- After `research` skill completes
- User says "design", "architect", "how should we build this"
- Invoked directly via `/design`
- Before `plan` skill (design informs implementation steps)

## Global Rule: Asking Questions

**ONE question at a time. Always.**

Use the AskUserQuestion tool pattern for all questions:

1. **Use multiple choice when possible** (2-4 options)
2. **Lead with your recommendation** - mark it clearly with "(Recommended)"
3. **Always include "Other"** - user can provide free text
4. **Single-select for mutually exclusive choices**
5. **Ground options in evidence** - cite codebase.md and research.md

**Format:**

```
[Brief context grounded in evidence]

**A) [Option Name]** (Recommended)
   Aligns with: [codebase pattern at file:line]
   Supported by: [research finding with source]

**B) [Option Name]**
   [Trade-offs of this approach]

**C) [Option Name]**
   [Trade-offs of this approach]

**D) Other**
   Different approach in mind
```

**Wait for response before asking next question.**

**Bad:**
> "What database should we use? Also, do you prefer REST or GraphQL? And should we add caching?"

**Good:**
> Single question with options, recommendation, and "Other"

## The Process

### Phase 1: Load Context

**Goal:** Ground the design in both codebase reality and validated research.

1. Read `.workflow/NNN-feature-slug/codebase.md`
2. Read `.workflow/NNN-feature-slug/research.md`
3. Synthesize key constraints from codebase
4. Synthesize validated best practices from research
5. Identify decisions that need to be made

```
"Based on the exploration and research:

**Building:** [Feature name]
**Codebase constraints:**
- [Pattern we must follow - cite codebase.md]
- [Integration point - cite codebase.md]

**Research findings:**
- [Best practice - cite research.md source]
- [Recommended approach - cite research.md source]

I have a few design decisions to work through with you. Let's start with [first decision]."
```

### Phase 2: Architectural Decisions

**Goal:** Make key technical choices collaboratively, grounded in evidence.

**For each decision point:**
1. Present 2-4 options with tradeoffs
2. Reference codebase patterns and research findings
3. Lead with your recommendation
4. Always include "Other" option
5. Ask ONE question
6. Wait for response
7. Move to next decision

**Example - Data Layer Decision:**
```
For the data layer, based on the research and existing patterns:

**A) PostgreSQL** (Recommended)
   Aligns with: existing setup at `src/db/connection.ts:5`
   Supported by: research.md recommends for this scale
   Trade-off: More complex than SQLite for simple cases

**B) SQLite**
   Simpler setup, good for prototypes
   Trade-off: Less suitable for concurrent access

**C) MongoDB**
   Flexible schema, good for rapid iteration
   Trade-off: Diverges from existing SQL patterns

**D) Other**
   Different database in mind

Which approach works for this feature?
```

**Example - API Design Decision:**
```
For the API design, based on research findings:

**A) REST with OpenAPI spec** (Recommended)
   Aligns with: existing API patterns at `src/api/routes.ts:1`
   Supported by: research.md source [link]
   Trade-off: More verbose than GraphQL

**B) GraphQL**
   Flexible queries, single endpoint
   Trade-off: New pattern not in current codebase

**C) tRPC**
   Type-safe, great DX
   Trade-off: Requires TypeScript on both ends

**D) Other**
   Different approach in mind

Which fits this feature best?
```

**Common decision areas:**
- Data model / storage
- API design / interfaces
- Component structure
- Error handling approach
- Testing strategy
- Integration points

### Phase 3: Component Design

**Goal:** Define what we're building in concrete terms.

For each major component:
1. Reference existing patterns from codebase.md
2. Apply best practices from research.md
3. Present the design in small sections (200-300 words)
4. Check understanding after each section
5. Be ready to revise based on feedback

**Format:**
```
"Let me walk through the [component] design:

**[Component Name]**

Purpose: [What it does]

Structure (following pattern from `existing/file.ts:15`):
- [Element 1]: [responsibility]
- [Element 2]: [responsibility]

Interactions:
- Receives: [input from where]
- Produces: [output to where]

This follows the [pattern name] we found in the codebase and aligns with [research finding].

Does this structure make sense so far?"
```

[Wait for confirmation before next component]

### Phase 4: Contracts (Optional)

**Goal:** Define interfaces between components.

If the feature involves API contracts, data models, or component interfaces:

**Write `.workflow/NNN-feature-slug/contracts.md`:**

```markdown
# Contracts: [Feature Name]

**Date:** YYYY-MM-DD
**Design:** [Link to design.md]

## API Contracts

### [Endpoint/Interface Name]

**Method:** POST /api/resource
**Purpose:** [What it does]

**Request:**
```json
{
  "field": "type - description"
}
```

**Response:**
```json
{
  "field": "type - description"
}
```

**Errors:**
| Code | Meaning | Response |
|------|---------|----------|
| 400 | Invalid input | `{"error": "..."}` |
| 401 | Unauthorized | `{"error": "..."}` |

---

## Data Models

### [Model Name]

```typescript
interface ModelName {
  id: string;
  field: Type; // description
}
```

**Validation rules:**
- field: [constraints]

---

## Component Interfaces

### [Component Name]

```typescript
interface ComponentProps {
  prop: Type; // description
}
```
```

### Phase 5: Design Document

**Goal:** Capture decisions in design.md.

**Write `.workflow/NNN-feature-slug/design.md`:**

```markdown
# Design: [Feature Name]

**Date:** YYYY-MM-DD
**Status:** Design complete, ready for planning
**Codebase Analysis:** [Link to codebase.md]
**Research:** [Link to research.md]
**Contracts:** [Link to contracts.md if created]

## Overview

[2-3 sentences: what we're building and the approach]

## Architecture

### High-Level Structure

```
[ASCII diagram or description of how components fit together]
```

### Components

#### [Component 1]

**Purpose:** [What it does]

**Follows pattern from:** `codebase/file.ts:line`

**Interface:**
```
[API/interface definition - pseudocode or actual syntax]
```

**Responsibilities:**
- [Responsibility 1]
- [Responsibility 2]

**Dependencies:**
- [What it needs]

#### [Component 2]
[Same structure]

## Data Model

[If applicable]

```
[Schema or data structure definition]
```

**Based on:** [Research finding with source]

## Key Decisions

| Decision | Choice | Rationale | Evidence |
|----------|--------|-----------|----------|
| [Decision 1] | [What we chose] | [Why] | codebase.md / research.md |
| [Decision 2] | [What we chose] | [Why] | codebase.md / research.md |

## Error Handling

[How errors flow through the system]

**Follows pattern from:** `existing/error-handler.ts:line`

## Testing Strategy

- **Unit tests:** [What we'll unit test]
- **Integration tests:** [What we'll integration test]
- **Edge cases:** [Key edge cases to cover]

**Based on:** [Testing patterns from codebase.md and research.md]

## Open Items

- [ ] [Anything still to be decided during planning/implementation]

## Non-Goals

[What we're explicitly NOT doing in this iteration]
```

## Handoff

After writing design.md (and contracts.md if applicable):

```
I've completed the design and saved it to `.workflow/NNN-feature-slug/design.md`.

**Architecture summary:** [1-2 sentences]
**Key decisions:** [Bullet the main choices made]
**Evidence-based:** Grounded in codebase patterns and validated research

What's next?

**A) Proceed to planning** (Recommended)
   I'll break this into concrete implementation steps

**B) Review the design first**
   Let's look at what I documented before moving on

**C) Adjust the design**
   I want to change something before proceeding

**D) Other**
   Something else in mind
```

**Transition to:** `plan` skill (if user confirms)

## Key Principles

- **ONE question at a time** - Never batch questions
- **Multiple choice first** - Easier than open-ended
- **Always include "Other"** - User can provide free text
- **Lead with recommendation** - Mark it clearly with "(Recommended)"
- **Ground in evidence** - Reference codebase.md and research.md
- **Present in small chunks** - 200-300 words, then check
- **Options with tradeoffs** - Always 2-4 choices plus "Other"
- **YAGNI ruthlessly** - Design only what's needed now

## Red Flags

**Never:**
- Ask multiple questions at once
- Present options without a recommendation
- Skip the "Other" option
- Present design without referencing evidence
- Skip loading codebase and research context
- Design beyond current scope
- Proceed without confirmation on key decisions
- Ignore existing patterns without justification

**Always:**
- One question at a time
- Use multiple choice format
- Include your recommendation
- Include "Other" for free text
- Wait for response before next question
- Reference both codebase.md and research.md
- Cite specific file:line from codebase analysis
- Cite sources from research findings
- Present 2-4 options with tradeoffs
- Break design into reviewable chunks
- Write design.md (and contracts.md if needed) to `.workflow/NNN-slug/`
