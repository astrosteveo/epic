---
name: constitution
description: "Use to create or update CLAUDE.md project conventions. Invoked standalone or as gate check before features."
---

# Constitution

Guides creation and maintenance of the project's CLAUDE.md - the source of truth for conventions, standards, and non-negotiables.

## Purpose

CLAUDE.md defines how the project should be developed. Getting this right prevents 80% of the problems AI agents cause by establishing clear expectations upfront.

## When Invoked

### As Gate Check (from /workflow)
- Check if CLAUDE.md exists
- If missing, guide user through creation
- If exists, confirm it's still accurate or needs updates

### Standalone
- User explicitly wants to create/update conventions
- Project standards have changed
- Adding new non-negotiables after learning from mistakes

## Discovery Process

Ask ONE question at a time to build the constitution:

### 1. Project Context
"What type of project is this? (e.g., web app, CLI tool, library, game, API service)"

### 2. Language & Framework
"What language and frameworks are you using?"

### 3. Testing Approach
"How should tests be written?"
- Testing framework (Jest, Pytest, Go testing, etc.)
- Coverage expectations
- Test file locations/naming conventions

### 4. Code Style
"Are there specific coding conventions to follow?"
- Linting rules
- Formatting (Prettier, Black, gofmt, etc.)
- Naming conventions
- File organization

### 5. Non-Negotiables
"What are absolute rules that must never be broken?"
Examples:
- "Never commit secrets"
- "All public functions must have docstrings"
- "No any types in TypeScript"
- "All API endpoints must have rate limiting"

### 6. Git Conventions
"How should commits and branches be structured?"
- Commit message format
- Branch naming
- PR requirements

### 7. Additional Context
"Anything else I should know about this project?"
- Deployment considerations
- Performance requirements
- Security requirements
- Dependencies to avoid

## Output Format

Create/update `CLAUDE.md` in project root:

```markdown
# Project Constitution

## Overview
{Brief project description}

## Tech Stack
- Language: {language}
- Framework: {framework}
- Testing: {test framework}

## Code Style
{Style guidelines}

## Testing Requirements
{Testing expectations}

## Git Conventions
- Commit format: {format}
- Branch naming: {pattern}

## Non-Negotiables
- {rule 1}
- {rule 2}
- {rule 3}

## Additional Context
{Any other relevant information}
```

## Updating Existing Constitution

When CLAUDE.md exists:
1. Read current contents
2. Ask: "I see you have an existing CLAUDE.md. Would you like to review and update it, or is it still accurate?"
3. If updating, walk through sections that need changes
4. Preserve sections that don't need changes

## Commit

After creating/updating:
```bash
git add CLAUDE.md
git commit -m "docs: establish project constitution"
# or "docs: update project constitution"
```

## Validation

Before finalizing, summarize back to user:
"Here's what I understand about your project conventions: [summary]. Does this capture everything?"

Only proceed when user confirms.
