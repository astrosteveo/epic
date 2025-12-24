---
description: Invoke the discoverer subagent for codebase exploration and external research
argument-hint: [task or question]
---

Use the discoverer subagent.

**Task:** $ARGUMENTS

## Routing Logic

**If a task was provided above:**
- Analyze the task to determine if it's exploration (codebase analysis) or research (external knowledge)
- If clearly research-focused (mentions "best practices", "documentation", "how does X technology work"): Use the `research` skill
- Otherwise: Default to the `explore` skill

**If no task was provided (or shows literally "$ARGUMENTS"):**
- Default to the `explore` skill immediately
- The explore skill has its own intent detection (Phase 0) that will:
  - Route to `brainstorm` if intent is too vague
  - Ask clarifying questions if needed
  - Proceed directly if intent is clear

**Do NOT prompt the user to choose between explore and research.** The explore skill is the intelligent entrypoint that handles routing internally.
