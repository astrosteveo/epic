---
description: Invoke the discoverer subagent for codebase exploration and external research
argument-hint: [task or question]
---

Use the discoverer subagent.

**Task:** $ARGUMENTS

If no task was provided above (or if the task shows literally "$ARGUMENTS"), use AskUserQuestion to ask the user what they'd like to do:
- **Explore codebase** - Analyze architecture, patterns, and conventions in the current codebase
- **Research** - Gather external knowledge about technologies, best practices, or integrations
