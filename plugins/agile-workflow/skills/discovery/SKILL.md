---
name: discovery
description: "Required before any creative or implementation work. Explores ideas through Socratic dialogue, produces design doc with smallest vertical slice."
---

# Discovery

## Overview

Turn ideas into validated designs through collaborative Socratic dialogue. Every creative/implementation task must start here - no jumping straight to code.

## When to Use

Use this skill when:
- Starting any new feature or project
- User says "I want to build...", "I want to implement...", "I have an idea..."
- Before any creative work that requires planning

## The Process

### Phase 1: Problem Understanding

Ask questions **one at a time**. Never overwhelm with multiple questions.

Start with:
- "What triggered this idea? Was there a specific moment where you thought 'I need this'?"
- "Who experiences this problem? Just you, or others too?"
- "What happens today without this solution? What's the workaround?"
- "How painful is this - nice-to-have or blocking issue?"

After each answer, reflect back in ~200-300 words, then ask follow-up.

**Adapt to user expertise:**
- If they speak technically ("I need an OAuth flow with PKCE"), focus on constraints and approach
- If they speak conceptually ("I want users to log in"), explain components and educate

### Phase 2: Context Exploration

Understand what exists:
- "What does the current system look like? Walk me through the relevant parts."
- "Technical constraints? (Language, framework, hosting, dependencies)"
- "Non-technical constraints? (Time, budget, who else needs to approve)"
- "Have you tried solving this before? What happened?"

Quick scan of existing code/docs if relevant. Surface constraints.

~200-300 words, then validate: "Does this capture your situation?"

### Phase 3: Approach Selection

Propose 2-3 different approaches with trade-offs:
- Lead with your recommendation and explain why
- Be clear about trade-offs of each option
- Ask: "Which direction feels right?"

If user is unsure, prefer multiple choice questions to reduce cognitive load.

~200-300 words per approach, validate before moving on.

### Phase 4: Success Criteria & Scope

Get concrete:
- "If this is done perfectly, what can you do that you couldn't before?"
- "What's the minimum viable version? If we could only ship one thing, what would it be?"
- "What would make this a failure even if it 'works'?"

Then draw boundaries:
- "What are you explicitly NOT trying to solve right now?"
- "What's tempting to include but should wait for later?"
- "What would 'gold plating' look like here?"

### Phase 5: Smallest Vertical Slice

**Critical question:** "What's the smallest thing we can build that proves this works?"

This is NOT about building the full MVP. It's about:
- The thinnest slice through all the layers
- Something we can demo/validate earliest
- Proving the concept before investing more

**Examples:**
- Rimworld-like game → "One colonist walking to a clicked location on a tile map"
- OAuth service → "One endpoint that issues a token, one endpoint that validates it"

### Phase 6: Synthesis

Present the consolidated design in ~200-300 word chunks. Validate each section:
- "Does this look right so far?"

Cover: architecture, components, data flow, error handling, testing approach.

## Output

Save validated design to: `docs/plans/YYYY-MM-DD-<topic>-design.md`

Format:
```markdown
# [Topic] Design

**Goal:** One sentence

**Problem:** What we're solving

**Context:**
- Current state
- Technical constraints
- Non-technical constraints

**Approach:**
[Selected approach and why]

**Vertical Slice:**
[Smallest thing that proves this works]

**Success Criteria:**
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

**Out of Scope:**
- Item 1
- Item 2

**Architecture:**
[2-3 sentences or simple diagram]

**Next Step:** Run `/plan` to create implementation plan
```

## After Discovery

When design is validated:
1. Commit the design document
2. Ask: "Ready to create the implementation plan?"
3. If yes, guide to `/plan` skill

## Key Principles

- **One question at a time** - Don't overwhelm
- **Multiple choice when possible** - Easier to answer
- **200-300 word chunks** - Digestible, validate each
- **Lead with recommendation** - But offer alternatives
- **YAGNI ruthlessly** - Remove unnecessary features
- **Smallest vertical slice** - Prove the concept first
- **Adapt to expertise** - Less hand-holding for experts, more education for beginners

## Red Flags

**Never:**
- Skip discovery and jump to coding
- Ask multiple questions at once
- Present walls of text without validation
- Assume you know what the user wants
- Over-scope the first iteration
- Forget to ask about the smallest vertical slice
