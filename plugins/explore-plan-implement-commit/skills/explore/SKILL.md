---
name: explore
description: The intelligent entrypoint for feature development. Detects intent, aligns understanding through Socratic dialogue, then deep-dives into codebase exploration and external research. Outputs research.md.
---

# Explore

## Overview

The smart starting point for any feature work. This skill adapts to who's using it:
- Senior with clear requirements? Quick alignment, then deep research.
- Beginner with vague idea? Route to brainstorm, then research.
- Somewhere in between? Socratic process to clarify, then research.

**Always produces:** `.workflow/NNN-feature-slug/research.md`

**Announce at start:** "I'm using the explore skill to understand what we're building and research how to build it."

## When to Use

- Starting any new feature work
- User says "explore", "research", "understand", "look into"
- User describes something they want to build
- Invoked directly via `/explore`
- Before `design` skill (explore informs design decisions)

## The Process

### Phase 0: Intent Detection

**Goal:** Understand what we're working with.

Quickly assess:
1. **Clarity of intent** - Do they know what they want?
2. **Codebase context** - Existing project or greenfield?
3. **User experience level** - Signals from how they communicate

**Route accordingly:**

| Signal | Action |
|--------|--------|
| Clear intent + existing codebase | → Phase 1 (Socratic) |
| Clear intent + greenfield | → Phase 1 (Socratic) |
| Vague intent + existing codebase | → Phase 1 (Socratic to clarify) |
| Vague intent + greenfield | → Invoke `brainstorm` skill first |
| No intent ("what should I build?") | → Invoke `brainstorm` skill first |

**If routing to brainstorm:**
> "It sounds like you're still figuring out what to build. Let me help with that first."
> [Invoke brainstorm skill, then return here with clear direction]

### Phase 1: Socratic Alignment

**Goal:** Ensure we understand exactly what the user wants. No assumptions.

**This happens for EVERY exploration** - the depth varies by clarity.

**For clear intent (quick handshake):**
```
"Just to confirm I understand:
- You want to [restate what they said]
- The goal is [inferred goal]
- Any constraints I should know about?

Is that right, or am I missing something?"
```

**For less clear intent (deeper dialogue):**
Ask one question at a time:
- What problem are we solving?
- Who benefits from this?
- What does success look like?
- Are there constraints (time, tech, compatibility)?
- What's the scope - MVP or full feature?

**Multiple choice when possible:**
```
"For the authentication flow, are you thinking:
A) Simple username/password
B) OAuth with Google/GitHub
C) Magic link / passwordless
D) Something else?"
```

**End Phase 1 with alignment confirmation:**
```
"Here's what I understand we're building:

**Feature:** [Name]
**Goal:** [What it accomplishes]
**Scope:** [What's in/out]
**Constraints:** [Any limitations]

Does this match your expectations?"
```

**Do not proceed until user confirms alignment.**

### Phase 2: Codebase Exploration

**Goal:** Understand what exists and how it works.

**If existing codebase:**
```
1. Project structure
   - Overall architecture
   - Key directories and purposes
   - Entry points and main flows

2. Relevant patterns
   - How are similar things done here?
   - Naming conventions, file organization
   - Testing patterns, error handling

3. Key files for this feature
   - What we'll likely touch
   - What we need to integrate with
   - Recent changes in relevant areas (git log)
```

**If greenfield:**
```
1. Technology decisions needed
   - What frameworks/languages fit?
   - What's the user comfortable with?

2. Project structure to establish
   - Recommended architecture
   - Directory organization

3. Starting point
   - Minimal viable structure
```

**Use subagents for complex exploration** - Preserve your context by spawning exploration subagents for deep dives.

### Phase 3: External Research

**Goal:** Don't build on stale knowledge.

```
1. Current best practices
   - Search "<technology> best practices 2025"
   - Official documentation updates
   - Deprecations or new approaches

2. Similar implementations
   - How do others solve this?
   - Emerging patterns
   - Common pitfalls

3. Dependencies and tools
   - Better libraries available?
   - Version compatibility
   - Security considerations
```

**Always search** - Training data has a cutoff. Web search fills the gap.

### Phase 4: Synthesis & Documentation

**Goal:** Create the research artifact.

**Determine the workflow folder:**
1. Check `.workflow/` for existing folders
2. Find next number (001, 002, etc.)
3. Create slug from feature name (lowercase, hyphens)
4. Create folder: `.workflow/NNN-feature-slug/`

**Write `.workflow/NNN-feature-slug/research.md`:**

```markdown
# Research: [Feature Name]

**Date:** YYYY-MM-DD
**Status:** Research complete, ready for design

## Alignment Summary

**Feature:** [Name]
**Goal:** [What it accomplishes]
**Scope:** [What's in/out]
**Constraints:** [Any limitations]

## Codebase Analysis

### Relevant Architecture
- [Pattern/style in use]
- [Key architectural decisions affecting this feature]

### Files We'll Touch
| File | Purpose | Changes Needed |
|------|---------|----------------|
| path/to/file | [what it does] | [what we'll change] |

### Existing Patterns to Follow
- [Pattern 1]: [where used, how it works]
- [Pattern 2]: [where used, how it works]

### Integration Points
- [What we need to connect to]
- [APIs, services, components]

## External Research

### Current Best Practices
- [Finding 1] - Source: [link]
- [Finding 2] - Source: [link]

### Recommended Approach
[Based on research, what approach should we take?]

### Potential Pitfalls
- [Pitfall 1]: [how to avoid]
- [Pitfall 2]: [how to avoid]

## Open Questions

- [ ] [Question that needs answering before design]
- [ ] [Decision that needs making]

## Sources
- [Link 1]
- [Link 2]
```

## Handoff

After writing research.md:

> "I've completed the research and saved it to `.workflow/NNN-feature-slug/research.md`.
>
> **Summary:** [2-3 sentence summary of findings]
>
> Ready to move to design? I'll use the design skill to work out the architecture and technical approach."

**Transition to:** `design` skill (if user confirms)

## Key Principles

- **Always Socratic first** - Align before researching
- **Adapt depth to clarity** - Quick handshake for seniors, deeper for vague
- **Route to brainstorm when needed** - Don't force clarity that isn't there
- **Search externally** - Never assume training data is current
- **Document everything** - research.md is the artifact
- **One question at a time** - Don't overwhelm

## Red Flags

**Never:**
- Skip Socratic alignment ("I know what they want")
- Skip external research ("I already know this")
- Jump to implementation ("I see what to do")
- Proceed without user confirmation of alignment
- Assume experience level without signals

**Always:**
- Confirm understanding before deep research
- Search for current best practices
- Write research.md to `.workflow/NNN-slug/`
- Let user decide when to move to design
- Adapt to user's experience level
