---
name: brainstorm
description: Use when the user needs creative help discovering what to build. Pure ideation - no code, no codebase research yet. Helps turn vague ideas into concrete directions.
---

# Brainstorm

## Overview

Help users discover what they want to build through creative ideation and Socratic dialogue. This skill is for the "I want to make something cool but I don't know what" moments.

**This is pure ideation.** No codebase exploration. No implementation details. Just ideas.

**Announce at start:** "Let's brainstorm together. I'll help you discover what you want to build."

## Global Rule: Asking Questions

**ONE question at a time. Always.**

Use the AskUserQuestion tool pattern for all questions:

1. **Use multiple choice when possible** (2-4 options)
2. **Lead with your recommendation** - mark it clearly
3. **Always include "Other"** - user can provide free text
4. **Single-select for mutually exclusive choices**
5. **Multi-select when choices can combine**

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

- User has no clear direction ("I want to build something")
- User wants to explore possibilities before committing
- User is stuck and needs creative inspiration
- Invoked directly via `/brainstorm`
- Called by `explore` skill when it detects greenfield + no clear intent

## The Process

### Phase 1: Understand the Person

**Goal:** Know who you're helping.

Ask these questions ONE AT A TIME using multiple choice:

**Question 1: Experience Level**
```
First, what's your experience level with building software?

**A) Beginner** (Recommended starting point)
   New to coding or just learning the basics

**B) Intermediate**
   Comfortable with one language, built a few projects

**C) Experienced**
   Built multiple projects, familiar with various technologies

**D) Other**
   Tell me more about your background
```

**Question 2: Motivation**
```
What draws you to building something right now?

**A) Learning a new skill** (Recommended for growth)
   Want to level up technically

**B) Solving a personal problem**
   Something annoys you that you want to fix

**C) Portfolio project**
   Need something to show potential employers

**D) Just for fun**
   Want to build something cool

**E) Other**
   Tell me what's motivating you
```

**Question 3: Domain Interest**
```
What area interests you most?

**A) Web applications**
   Websites, dashboards, online tools

**B) Automation/Tools**
   Scripts, CLI tools, productivity helpers

**C) Data/Analytics**
   Visualizations, data processing, insights

**D) Games/Creative**
   Games, generative art, interactive experiences

**E) Other**
   Tell me what domain excites you
```

### Phase 2: Generate Directions

**Goal:** Surface 3-5 possible directions.

Based on what you learned, propose directions using this format:

```
Based on what you've shared, here are some directions we could take:

**A) [Project Name]** (Recommended)
   [2-3 sentences: what it is, why it fits them, what they'd learn]

**B) [Project Name]**
   [2-3 sentences: what it is, why it fits them, what they'd learn]

**C) [Project Name]**
   [2-3 sentences: what it is, why it fits them, what they'd learn]

**D) [Project Name]**
   [2-3 sentences: what it is, why it fits them, what they'd learn]

**E) Other**
   None of these resonate? Tell me what direction you're thinking.

Which one speaks to you?
```

### Phase 3: Refine the Chosen Direction

**Goal:** Shape the idea into something concrete.

Once they pick a direction, ask clarifying questions ONE AT A TIME:

**Scope Question:**
```
How big are you thinking for this project?

**A) MVP / Weekend Project** (Recommended)
   Core feature only, get it working fast

**B) Medium Project**
   A few features, maybe a week or two of work

**C) Full Application**
   Complete feature set, longer-term project

**D) Other**
   Tell me your timeline/scope thinking
```

**Target User Question:**
```
Who's this for?

**A) Just yourself** (Recommended for first projects)
   Personal tool, you're the only user

**B) Friends/Family**
   Small group of known users

**C) Public users**
   Anyone on the internet

**D) Other**
   Different audience in mind
```

**End with a summary:**
```
Here's what we've landed on:

**Project:** [Name]
**Core idea:** [1-2 sentences]
**Target user:** [Who benefits]
**Key features:** [3-5 bullet points]
**Scope:** [MVP definition]

Does this capture what you want to build?

**A) Yes, let's move forward** (Recommended)
   Ready to explore how to build this

**B) Needs tweaking**
   Close but I want to adjust something

**C) Start over**
   This isn't quite right, let's brainstorm again
```

## Handoff

Once the idea is solid, offer next step:

```
Great, we have a clear direction!

**A) Start exploring** (Recommended)
   I'll document the codebase and research best practices

**B) Refine the idea more**
   Let's keep brainstorming before moving on

**C) I'll think about it**
   Take time to consider before committing
```

**Transition to:** `explore` skill (if user confirms)

**Full workflow:** brainstorm → explore → research → design → plan → implement → commit

## Key Principles

- **ONE question at a time** - Never batch questions
- **Multiple choice first** - Easier than open-ended
- **Always include "Other"** - User can always provide free text
- **Lead with recommendation** - Mark it clearly with "(Recommended)"
- **Stay in ideation** - No implementation details yet
- **Adapt to skill level** - Beginner vs senior get different treatment
- **YAGNI mindset** - Keep scope tight, features minimal

## Red Flags

**Never:**
- Ask multiple questions at once
- Present options without a recommendation
- Skip the "Other" option
- Jump into codebase exploration (that's `explore`)
- Discuss implementation details (that's `design`/`plan`)
- Write any code
- Assume skill level without asking
- Propose only one option

**Always:**
- One question at a time
- Use multiple choice format
- Include your recommendation
- Include "Other" for free text
- Wait for response before next question
- Adapt to user's experience level
- End with clear summary of the idea
- Let user decide when to move forward
