#!/bin/bash

cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "You have the Harness workflow plugin installed. This plugin provides structured development workflows.

AVAILABLE SKILLS:
- /workflow - Full orchestrated development flow (Constitution → Clarify → Design → Plan → Implement → Review → Commit)
- /constitution - Create or update CLAUDE.md project conventions
- /clarify - Socratic discovery to produce clear specifications
- /design - Create architecture and technical design
- /plan - Break design into actionable tasks
- /implement - TDD implementation (RED → GREEN → REFACTOR)
- /review - Verify implementation against design/plan
- /commit - Final check, push branch, create PR

WHEN TO USE:
- When user wants to build a feature, fix a bug, or refactor code → use /workflow
- When user wants to establish project conventions → use /constitution
- When user asks to resume work → check .harness/ directory for existing workflow state
- Individual skills can be invoked standalone when user needs just that phase

ARTIFACTS:
- .harness/NNN-{feature-slug}/ - Feature-specific artifacts (spec.md, design.md, plan.md, state.json)
- .harness/backlog.md - Roadmap for large-scope projects
- CLAUDE.md - Project constitution (conventions, standards, non-negotiables)

PRINCIPLES:
- One question at a time during clarification
- Dynamic scaling: simple features get light process, complex features get full rigor
- TDD by default where applicable
- Light verification after each task, thorough review before shipping
- Git as audit trail with incremental commits"
  }
}
EOF
exit 0
