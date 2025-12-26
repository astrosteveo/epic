---
name: clarify
description: "Use for socratic discovery to produce clear specifications. Asks one question at a time to narrow down requirements."
---

# Clarify

Socratic discovery process that transforms vague ideas into clear, actionable specifications through iterative questioning.

## Core Principle

**ONE question at a time.** Never overwhelm with multiple questions. Each question builds on previous answers to progressively narrow scope.

## Process

### 1. Acknowledge the Request
Briefly restate what you heard to show understanding:
"So you want to build a user authentication system..."

### 2. Assess Scope
Determine if the request is:
- **Specific enough**: Can be designed and implemented directly
- **Too broad**: Needs to be broken into a backlog

### 3. If Too Broad → Backlog Mode
"This is a significant undertaking. I'd recommend we create a roadmap first to break this into manageable pieces. Would you like to do that?"

If yes:
- Create `.harness/backlog.md` with prioritized items
- Ask which item to start with
- Continue clarification on selected item

### 4. Iterative Questioning

Ask questions in this general order, adapting based on context:

**Functional Requirements**
- "What should happen when [trigger]?"
- "Who will be using this?"
- "What's the expected input/output?"

**Boundaries**
- "What should this NOT do?"
- "Are there any constraints I should know about?"
- "What's out of scope for now?"

**Existing Context**
- "Is there existing code this needs to integrate with?"
- "Are there patterns in the codebase I should follow?"

**Success Criteria**
- "How will we know this is working correctly?"
- "What would a successful outcome look like?"

**Edge Cases**
- "What should happen if [edge case]?"
- "How should errors be handled?"

### 5. Synthesis

When confident you have enough information:

"Let me summarize what I understand:

**Goal**: {what we're building}
**Scope**: {what's included}
**Out of Scope**: {what's not included}
**Key Requirements**:
- {requirement 1}
- {requirement 2}
- {requirement 3}

**Success Criteria**:
- {criterion 1}
- {criterion 2}

Does this capture your intent? Ready to proceed to design?"

### 6. Confirmation Gate

Wait for explicit user confirmation before proceeding. If they have corrections:
- Incorporate feedback
- Re-summarize
- Ask for confirmation again

## Output

Create `.harness/NNN-{slug}/spec.md`:

```markdown
# Specification: {Feature Name}

## Overview
{Brief description of what we're building}

## Goals
- {goal 1}
- {goal 2}

## Requirements
### Functional
- {functional requirement 1}
- {functional requirement 2}

### Non-Functional
- {non-functional requirement 1}

## Out of Scope
- {exclusion 1}
- {exclusion 2}

## Success Criteria
- [ ] {criterion 1}
- [ ] {criterion 2}

## Open Questions (if any)
- {question that might arise during design}

## Notes
{Any additional context from the conversation}
```

## Git

After creating spec:
```bash
git add .harness/NNN-{slug}/spec.md
git commit -m "docs(NNN): define specification for {feature}"
```

## Anti-Patterns

**Don't:**
- Ask multiple questions at once
- Assume requirements not stated
- Skip confirmation before proceeding
- Proceed when user seems uncertain
- Add scope beyond what user requested

**Do:**
- Listen more than talk
- Reflect back what you hear
- Ask clarifying follow-ups
- Accept "I don't know yet" as valid
- Keep scope minimal and focused
