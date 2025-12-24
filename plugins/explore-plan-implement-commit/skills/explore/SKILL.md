---
name: explore
description: The intelligent entrypoint for feature development. Detects intent, aligns understanding through Socratic dialogue, then documents the codebase with file:line references. Outputs codebase.md.
---

# Explore

## Overview

The smart starting point for any feature work. This skill analyzes and documents the existing codebase as objective truth, with precise `file:line` references for full traceability.

**Always produces:** `.workflow/NNN-feature-slug/codebase.md`

**Announce at start:** "I'm using the explore skill to document the codebase and understand what we're building."

## Core Principle: Truth-Documenting Only

**You are a truth-documenter, not a consultant.**

- **Does NOT** recommend changes or improvements
- **Does NOT** critique or evaluate code quality
- **Documents only** what exists, using `file:line` references
- **Outputs** an objective map of the codebase relevant to the feature

## Global Rule: Asking Questions

**ONE question at a time. Always.**

Use the AskUserQuestion tool pattern for all questions:

1. **Use multiple choice when possible** (2-4 options)
2. **Lead with your recommendation** - mark it clearly with "(Recommended)"
3. **Always include "Other"** - user can provide free text
4. **Single-select for mutually exclusive choices**
5. **Multi-select when choices can combine** (mark with "[Multi-select]")

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

- Starting any new feature work
- User says "explore", "understand", "look into"
- User describes something they want to build
- Invoked directly via `/explore`
- Before `research` skill (explore informs research scope)

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
| Clear intent + existing codebase | -> Phase 1 (Socratic) |
| Clear intent + greenfield | -> Phase 1 (Socratic) |
| Vague intent + existing codebase | -> Phase 1 (Socratic to clarify) |
| Vague intent + greenfield | -> Invoke `brainstorm` skill first |
| No intent ("what should I build?") | -> Invoke `brainstorm` skill first |

**If routing to brainstorm:**
> "It sounds like you're still figuring out what to build. Let me help with that first."
> [Invoke brainstorm skill, then return here with clear direction]

### Phase 1: Socratic Alignment

**Goal:** Ensure we understand exactly what the user wants. No assumptions.

**This happens for EVERY exploration** - the depth varies by clarity.

**For clear intent (quick handshake):**
```
Just to confirm I understand:
- You want to [restate what they said]
- The goal is [inferred goal]

Does this match your expectations?

**A) Yes, that's right** (Recommended)
   Let's proceed with exploration

**B) Close, but needs adjustment**
   I'll clarify what's different

**C) No, let me explain again**
   I'll restate what I'm looking for
```

**For less clear intent (deeper dialogue):**
Ask ONE question at a time using multiple choice:

**Example - Problem Question:**
```
What problem are we solving?

**A) User experience issue**
   Something is hard to use or confusing

**B) Missing functionality**
   A capability that doesn't exist yet

**C) Performance/efficiency**
   Something is too slow or resource-intensive

**D) Technical debt**
   Code needs improvement for maintainability

**E) Other**
   Tell me what problem you're facing
```

**Example - Scope Question:**
```
What's the scope for this feature?

**A) MVP / Minimal** (Recommended)
   Core functionality only, ship fast

**B) Standard**
   Complete feature with expected capabilities

**C) Comprehensive**
   Full-featured with edge cases handled

**D) Other**
   Tell me your scope thinking
```

**Example - Technology Choice:**
```
For the authentication flow, which approach?

**A) Simple username/password** (Recommended for MVPs)
   Traditional email/password login

**B) OAuth with Google/GitHub**
   Social login, less friction for users

**C) Magic link / passwordless**
   Email-based, no password to remember

**D) Other**
   Different approach in mind
```

**End Phase 1 with alignment confirmation:**
```
Here's what I understand we're building:

**Feature:** [Name]
**Goal:** [What it accomplishes]
**Scope:** [What's in/out]
**Constraints:** [Any limitations]

Does this capture it correctly?

**A) Yes, proceed with exploration** (Recommended)
   Start documenting the codebase

**B) Needs adjustment**
   Let me clarify something

**C) Start over**
   This isn't what I meant
```

**Do not proceed until user confirms alignment.**

### Phase 2: Codebase Documentation

**Goal:** Document what exists with `file:line` references.

**Remember: Document only. No recommendations. No critiques.**

**If existing codebase:**

1. **Project structure**
   - Document overall architecture
   - Map key directories and their purposes
   - Identify entry points and main flows
   - Use `file:line` references for all findings

2. **Relevant patterns**
   - How are similar things done here? (cite `file:line`)
   - Naming conventions observed (cite examples)
   - File organization patterns (cite examples)
   - Testing patterns in use (cite `file:line`)
   - Error handling patterns (cite `file:line`)

3. **Key files for this feature**
   - What we'll likely touch (with `file:line` context)
   - What we need to integrate with (with `file:line` context)
   - Recent changes in relevant areas (git log references)

**For each finding, cite precisely:**
```
The authentication middleware is defined at `src/middleware/auth.ts:15-45`.
It uses the JWT pattern established in `src/utils/jwt.ts:8`.
Error responses follow the format at `src/types/errors.ts:12-18`.
```

**If greenfield:**

1. **Technology decisions needed**
   - What frameworks/languages fit?
   - What's the user comfortable with?

2. **Project structure to establish**
   - Recommended architecture (will be validated in research)
   - Directory organization

3. **Starting point**
   - Minimal viable structure

**Use subagents for complex exploration** - Preserve your context by spawning exploration subagents for deep dives.

### Phase 3: Documentation

**Goal:** Create the codebase artifact.

**Determine the workflow folder:**
1. Check `.workflow/` for existing folders
2. Find next number (001, 002, etc.)
3. Create slug from feature name (lowercase, hyphens)
4. Create folder: `.workflow/NNN-feature-slug/`

**Write `.workflow/NNN-feature-slug/codebase.md`:**

```markdown
# Codebase Analysis: [Feature Name]

**Date:** YYYY-MM-DD
**Status:** Exploration complete, ready for research
**Feature:** [Name]
**Goal:** [What it accomplishes]

---

## Alignment Summary

**Feature:** [Name]
**Goal:** [What it accomplishes]
**Scope:** [What's in/out]
**Constraints:** [Any limitations]

---

## Project Structure

### Architecture Overview

[Description of overall architecture with file references]

### Directory Map

| Directory | Purpose | Key Files |
|-----------|---------|-----------|
| `src/components/` | UI components | `Button.tsx:1`, `Form.tsx:1` |
| `src/api/` | API layer | `client.ts:1`, `endpoints.ts:1` |

---

## Relevant Patterns

### [Pattern Name]

**Location:** `file/path.ext:line-range`

**How it works:**
[Objective description of the pattern]

**Examples in codebase:**
- `file1.ts:15-30` - [what this example shows]
- `file2.ts:42-58` - [what this example shows]

### [Pattern Name 2]

[Same structure]

---

## Files Relevant to This Feature

### Will Likely Modify

| File | Lines | Purpose | Relevance |
|------|-------|---------|-----------|
| `path/to/file.ts` | 1-50 | [what it does] | [why we'll touch it] |

### Will Integrate With

| File | Lines | Purpose | Integration Point |
|------|-------|---------|-------------------|
| `path/to/file.ts` | 15-20 | [what it does] | [how we'll integrate] |

---

## Entry Points and Flows

### [Flow Name]

**Entry:** `file.ts:line`
**Path:**
1. `file1.ts:10` - [what happens]
2. `file2.ts:25` - [what happens]
3. `file3.ts:40` - [what happens]

---

## Recent Changes

[From git log - relevant recent modifications to files we'll touch]

| Date | Commit | Files | Summary |
|------|--------|-------|---------|
| YYYY-MM-DD | abc123 | `file.ts` | [what changed] |

---

## Technologies in Use

| Technology | Version | Config Location |
|------------|---------|-----------------|
| React | 18.2.0 | `package.json:15` |
| TypeScript | 5.0.0 | `tsconfig.json:1` |

---

## Notes

[Any objective observations that don't fit above categories]
```

## Handoff

After writing codebase.md:

```
I've documented the codebase and saved it to `.workflow/NNN-feature-slug/codebase.md`.

**Summary:** [2-3 sentence objective summary of findings]

**Technologies identified:** [List from codebase]

What's next?

**A) Run `/research`** (Recommended)
   I'll gather validated best practices for these technologies

**B) Review the codebase analysis first**
   Let's look at what I documented before moving on

**C) Adjust scope**
   I want to change what we're building

**D) Other**
   Something else in mind
```

**IMPORTANT:** When user selects option A, invoke the `research` skill using the Skill tool. Do NOT proceed to implementation or trigger built-in plan mode.

## Key Principles

- **ONE question at a time** - Never batch questions
- **Multiple choice first** - Easier than open-ended
- **Always include "Other"** - User can provide free text
- **Lead with recommendation** - Mark it clearly with "(Recommended)"
- **Truth-documenting only** - No recommendations, no critiques
- **Always cite `file:line`** - Every finding needs a precise reference
- **Socratic first** - Align before documenting
- **Adapt depth to clarity** - Quick handshake for seniors, deeper for vague
- **Route to brainstorm when needed** - Don't force clarity that isn't there
- **Objective language** - Describe what is, not what should be

## Red Flags

**Never:**
- Ask multiple questions at once
- Present options without a recommendation
- Skip the "Other" option
- Recommend changes or improvements
- Critique code quality or patterns
- Suggest "better" ways to do things
- Skip Socratic alignment
- Proceed without user confirmation
- Use vague references (always `file:line`)

**Always:**
- One question at a time
- Use multiple choice format
- Include your recommendation
- Include "Other" for free text
- Wait for response before next question
- Document objectively what exists
- Use precise `file:line` references
- Confirm understanding before deep exploration
- Write codebase.md to `.workflow/NNN-slug/`
- Let user decide when to move to research
- Adapt to user's experience level
