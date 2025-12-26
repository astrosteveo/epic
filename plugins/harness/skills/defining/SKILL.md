---
name: defining
description: |
  Use this skill when starting a new task to establish requirements through Socratic dialogue.
  Produces: .harness/{nnn}-{slug}/requirements.md
---

# Defining Phase

Establish what needs to be done through guided questioning. This is always the first phase for any new task.

## When to Use

- A new task or feature is presented
- User wants to start fresh on a problem
- Returning to clarify requirements after research reveals gaps

## The Process

### 1. Create Task Directory

If this is a new task, create the task directory:

```
.harness/{nnn}-{slug-name}/
```

Where:
- `{nnn}` = next sequential number (001, 002, etc.)
- `{slug-name}` = kebab-case description (e.g., `user-authentication`, `dark-mode-toggle`)

Check existing `.harness/` directories to determine the next number.

### 2. Socratic Dialogue

Guide the user through these levels, asking questions at each stage:

**Vision (Broad)**
- "What problem are we trying to solve?"
- "What does success look like when this is done?"
- "Who benefits from this and how?"

**Functional Requirements (Specific)**
- "What are the must-have behaviors?"
- "What inputs and outputs are expected?"
- "Are there any user-facing changes?"

**Constraints**
- "What's the scope boundary - what are we NOT doing?"
- "Are there compatibility requirements (browsers, versions, etc.)?"
- "What dependencies or integrations are involved?"
- "Any performance or security considerations?"

**Success Criteria**
- "How will we know it's done right?"
- "What tests or validations should pass?"
- "What would make you confident this is complete?"

### 3. Document Requirements

Create `.harness/{nnn}-{slug-name}/requirements.md` with this structure:

```markdown
# Requirements: {Task Name}

## Vision
{What problem we're solving and why it matters}

## Functional Requirements
{List of must-have behaviors}

## Constraints
{Scope boundaries, compatibility, dependencies}

## Success Criteria
{How we'll know it's done right}
```

### 4. Offer Transition

When requirements feel complete, offer to move forward:

> "These requirements look solid. Ready to move to Research where I'll explore the codebase and best practices?"

User can accept, continue refining, or take a different path.

## Key Principles

- **Ask, don't assume** - Use questions to surface the user's actual intent
- **Narrow progressively** - Start broad, then get specific
- **Confirm understanding** - Reflect back what you heard before documenting
- **Stay flexible** - Requirements may evolve; that's normal
- **Document decisions** - Capture the "why" not just the "what"

## Lightweight Mode

For trivial tasks (typo fixes, one-line changes, config tweaks):

- Skip the full artifact ceremony
- Quick verbal confirmation: "So we're just fixing the typo in X, correct?"
- Proceed directly to Execute after confirmation
- Suggest: "This seems straightforward enough to skip the full workflow. Want to just do it?"

## Returning to Define

You may return to this phase from later phases when:
- Research reveals the requirements were based on incorrect assumptions
- Planning uncovers scope issues
- Execution hits fundamental blockers
- User requests scope changes ("actually, let's also add X")

When returning, update `requirements.md` to reflect the new understanding.
