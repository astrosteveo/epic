---
description: Invoke the coder subagent for TDD implementation work
argument-hint: [task template from orchestrator]
---

Use the coder subagent.

**Task:** $ARGUMENTS

If no task was provided above (or if the task shows literally "$ARGUMENTS"), explain that the coder subagent expects a structured task template from the orchestrator, then ask if the user wants to:
- Provide a task description manually
- Run /plan first to generate proper task templates
