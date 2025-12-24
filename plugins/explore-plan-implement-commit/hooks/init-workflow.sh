#!/bin/bash

cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "You have the explore-plan-implement-commit workflow plugin installed. When the user asks to build a feature, implement functionality, fix a bug, or do any development work (requests like 'I want to add...', 'Build me a...', 'Create a...', 'Implement...', 'Fix...'), you MUST invoke the 'workflow' skill using the Skill tool. This workflow handles: intent detection, codebase exploration, research, design, planning, and implementation with quality gates. Do not use default behavior for development requests - use the workflow skill."
  }
}
EOF

exit 0
