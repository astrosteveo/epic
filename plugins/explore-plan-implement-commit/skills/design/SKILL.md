---
name: design
description: Use after explore to design the architecture and technical approach. Takes research findings and creates a concrete technical design. Outputs design.md.
---

# Design

## Overview

Transform research into architecture. This skill takes the findings from `explore` and works with the user to create a concrete technical design.

**Input:** `.workflow/NNN-feature-slug/research.md`
**Output:** `.workflow/NNN-feature-slug/design.md`

**Announce at start:** "I'm using the design skill to work out the architecture for this feature."

## When to Use

- After `explore` skill completes
- User says "design", "architect", "how should we build this"
- Invoked directly via `/design`
- Before `plan` skill (design informs implementation steps)

## Core Rule: One Question at a Time

**Never ask multiple questions in one message.**

Bad:
> "What database should we use? Also, do you prefer REST or GraphQL? And should we add caching?"

Good:
> "For the data layer, I'm thinking PostgreSQL based on your existing setup. Does that work, or do you have a different preference?"

[Wait for answer, then ask next question]

## The Process

### Phase 1: Load Context

**Goal:** Ground the design in research.

1. Read `.workflow/NNN-feature-slug/research.md`
2. Summarize key constraints and findings
3. Identify decisions that need to be made

```
"Based on the research, here's what we're working with:

**Building:** [Feature name]
**Key constraint:** [Most important limitation]
**Existing patterns:** [What we should follow]

I have a few design decisions to work through with you. Let's start with [first decision]."
```

### Phase 2: Architectural Decisions

**Goal:** Make key technical choices collaboratively.

**For each decision point:**
1. Present 2-3 options with tradeoffs
2. Lead with your recommendation
3. Ask ONE question
4. Wait for response
5. Move to next decision

**Format:**
```
"For [component/aspect], I see a few approaches:

**Option A: [Name]** (Recommended)
- Pro: [benefit]
- Con: [drawback]
- Fits because: [why it matches their context]

**Option B: [Name]**
- Pro: [benefit]
- Con: [drawback]

**Option C: [Name]**
- Pro: [benefit]
- Con: [drawback]

I'd go with Option A because [reasoning]. Does that work for you?"
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
1. Present the design in small sections (200-300 words)
2. Check understanding after each section
3. Be ready to revise based on feedback

**Format:**
```
"Let me walk through the [component] design:

**[Component Name]**

Purpose: [What it does]

Structure:
- [Element 1]: [responsibility]
- [Element 2]: [responsibility]

Interactions:
- Receives: [input from where]
- Produces: [output to where]

Does this structure make sense so far?"
```

[Wait for confirmation before next component]

### Phase 4: Design Document

**Goal:** Capture decisions in design.md.

**Write `.workflow/NNN-feature-slug/design.md`:**

```markdown
# Design: [Feature Name]

**Date:** YYYY-MM-DD
**Status:** Design complete, ready for planning
**Research:** [Link to research.md]

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

## Key Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| [Decision 1] | [What we chose] | [Why] |
| [Decision 2] | [What we chose] | [Why] |

## Error Handling

[How errors flow through the system]

## Testing Strategy

- **Unit tests:** [What we'll unit test]
- **Integration tests:** [What we'll integration test]
- **Edge cases:** [Key edge cases to cover]

## Open Items

- [ ] [Anything still to be decided during planning/implementation]

## Non-Goals

[What we're explicitly NOT doing in this iteration]
```

## Handoff

After writing design.md:

> "I've completed the design and saved it to `.workflow/NNN-feature-slug/design.md`.
>
> **Architecture summary:** [1-2 sentences]
> **Key decisions:** [Bullet the main choices made]
>
> Ready to create the implementation plan? I'll use the plan skill to break this into concrete steps."

**Transition to:** `plan` skill (if user confirms)

## Key Principles

- **One question at a time** - Never batch questions
- **Lead with recommendations** - Have opinions, share them
- **Present in small chunks** - 200-300 words, then check
- **Options with tradeoffs** - Always 2-3 choices, never just one
- **Ground in research** - Reference research.md findings
- **YAGNI ruthlessly** - Design only what's needed now

## Red Flags

**Never:**
- Ask multiple questions at once
- Present design without options
- Skip loading research context
- Design beyond current scope
- Proceed without confirmation on key decisions

**Always:**
- Reference research.md
- Present 2-3 options with tradeoffs
- Lead with your recommendation
- Break design into reviewable chunks
- Wait for confirmation before proceeding
- Write design.md to `.workflow/NNN-slug/`
