---
name: brainstorm
description: Use when the user needs creative help discovering what to build. Pure ideation - no code, no codebase research yet. Helps turn vague ideas into concrete directions.
---

# Brainstorm

## Overview

Help users discover what they want to build through creative ideation and Socratic dialogue. This skill is for the "I want to make something cool but I don't know what" moments.

**This is pure ideation.** No codebase exploration. No implementation details. Just ideas.

**Announce at start:** "Let's brainstorm together. I'll help you discover what you want to build."

## When to Use

- User has no clear direction ("I want to build something")
- User wants to explore possibilities before committing
- User is stuck and needs creative inspiration
- Invoked directly via `/brainstorm`
- Called by `explore` skill when it detects greenfield + no clear intent

## The Process

### Phase 1: Understand the Person

**Goal:** Know who you're helping.

Ask about (one question at a time):
- What gets them excited about building things?
- What problems do they encounter in daily life?
- What skills are they trying to develop?
- What's their experience level? (shapes complexity of suggestions)

**Adapt your approach:**
- Beginner → simpler project ideas, more guidance
- Experienced → more ambitious ideas, less hand-holding

### Phase 2: Generate Directions

**Goal:** Surface 3-5 possible directions.

Based on what you learned:
1. Propose 3-5 distinct project directions
2. Each should be:
   - Concrete enough to imagine
   - Flexible enough to shape
   - Aligned with their interests/skills
3. Present as quick sketches, not detailed specs
4. Include your recommendation and why

**Format:**
```
Here are some directions we could explore:

**1. [Project Name]** (Recommended)
[2-3 sentences: what it is, why it fits them]

**2. [Project Name]**
[2-3 sentences: what it is, why it fits them]

**3. [Project Name]**
[2-3 sentences: what it is, why it fits them]

Which resonates? Or should we explore a different angle?
```

### Phase 3: Refine the Chosen Direction

**Goal:** Shape the idea into something concrete.

Once they pick a direction:
1. Ask clarifying questions (one at a time)
2. Explore scope: MVP vs full vision
3. Identify the core value proposition
4. Surface potential challenges early
5. Get to a clear "what we're building" statement

**End with a summary:**
```
Here's what we've landed on:

**Project:** [Name]
**Core idea:** [1-2 sentences]
**Target user:** [Who benefits]
**Key features:** [3-5 bullet points]
**Scope:** [MVP definition]

Does this capture what you want to build?
```

## Handoff

Once the idea is solid, offer next step:

> "Great, we have a clear direction. Ready to explore the codebase and research how to build this? I'll use the explore skill to understand what we're working with and research current best practices."

**Transition to:** `explore` skill (if user confirms)

## Key Principles

- **One question at a time** - Don't overwhelm
- **Lead with recommendations** - Have opinions, share them
- **Stay in ideation** - No implementation details yet
- **Adapt to skill level** - Beginner vs senior get different treatment
- **Multiple choice when possible** - Easier to answer than open-ended
- **YAGNI mindset** - Keep scope tight, features minimal

## Red Flags

**Never:**
- Jump into codebase exploration (that's `explore`)
- Discuss implementation details (that's `design`/`plan`)
- Write any code
- Assume skill level without asking
- Propose only one option

**Always:**
- Offer multiple directions
- Include your recommendation
- Adapt to user's experience level
- End with clear summary of the idea
- Let user decide when to move forward
