# Context Engineering for Coding Agents

## The Fundamental Principle

LLMs are stateless functions. The **only** lever you have to affect output quality is the content of the context window.

```
Context Window Contents
├── System prompt
├── CLAUDE.md
├── Conversation history
├── File contents read
├── Tool results
└── Current user message
         │
         ▼
    [LLM Function]
         │
         ▼
    Next Action/Response
```

## Optimize For

1. **Correctness** - Is the information accurate?
2. **Completeness** - Does it contain what's needed?
3. **Low Noise** - Is irrelevant content minimized?

The worst outcomes, in order:
1. Incorrect information → wrong decisions
2. Missing information → incomplete solutions
3. Too much noise → degraded quality

## Context Utilization Sweet Spot

Keep utilization at **40-60%** of the context window.

Why not higher?
- Model performance degrades as context fills
- Less room for working through the problem
- Higher chance of relevant info getting "lost"

## What Eats Context

| Source | Impact | Mitigation |
|--------|--------|------------|
| File searches (grep/glob) | High | Use subagents |
| Reading large files | High | Read specific sections |
| Full test output | Very High | Summarize to failures only |
| Build logs | Very High | Extract errors only |
| JSON API responses | High | Extract relevant fields |
| Conversation history | Accumulating | Compact periodically |

## Compaction Strategies

### When to Compact

- Context > 60% utilized
- Switching between distinct tasks
- Session ending with work in progress
- Major phase complete

### What to Compact To

Good compaction output:
```markdown
## Goal
Add rate limiting to API endpoints

## Approach
Token bucket algorithm with Redis

## Files Identified
- src/middleware/rateLimit.ts:45-67 (create)
- src/routes/api.ts (add middleware)

## Completed
- [x] Researched patterns
- [x] Found Redis singleton

## Current Status
Implementing bucket logic, test failing

## Next Steps
1. Fix refill edge case
2. Add integration tests
```

### Using Subagents for Context Isolation

Subagents use separate context windows. The pattern:

```
Main Context                    Subagent Context
(stays clean)                   (disposable)
     │                                │
     │── "Find auth files" ──────────▶│
     │                                │── grep "auth"
     │                                │── glob **/*.ts
     │                                │── read files
     │                                │
     │◀── Compact summary ────────────│
     │    • auth/login.ts:23          │
     │    • auth/session.ts:45        │
     │                                ▼
     │                         [Context discarded]
     │
[Continues with clean context + summary]
```

## Subagent Output Format

What you want from subagents:
- Structured list with `file:line` references
- Brief descriptions
- How components connect
- NO suggestions, NO critique, just facts

What to avoid:
- "I found 47 files, here they all are..."
- "The system could be improved by..."
- Raw tool output

## The Formula

```
Output Quality = f(Correctness, Completeness, 1/Noise)
```

Every decision about what to include in context should optimize this function.
