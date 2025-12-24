---
description: Invoke the orchestrator subagent for planning, reviews, and workflow coordination
argument-hint: [task or question]
---

Use the orchestrator subagent.

**Task:** $ARGUMENTS

If no task was provided above (or if the task shows literally "$ARGUMENTS"), use AskUserQuestion to ask the user what they'd like to do:
- **Plan** - Create an implementation plan from a design
- **Review code** - Review code for quality and best practices
- **Review tests** - Validate test authenticity and coverage
- **Validate plan** - Check that implementation follows the plan
