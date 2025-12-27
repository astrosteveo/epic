#!/bin/bash
# Gate: Dispatch skill invocations to the appropriate gate script
# This runs on PreToolUse for the Skill tool and routes to specific gates

# Hook input comes via stdin as JSON
# Read it once and extract the skill name from tool_input.skill
INPUT=$(cat)
SKILL_NAME=$(echo "$INPUT" | grep -o '"skill"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"\([^"]*\)"$/\1/')

case "$SKILL_NAME" in
    harness:researching)
        exec bash "$(dirname "$0")/gate-research.sh"
        ;;
    harness:planning)
        exec bash "$(dirname "$0")/gate-plan.sh"
        ;;
    harness:executing)
        exec bash "$(dirname "$0")/gate-execute.sh"
        ;;
    harness:verifying)
        exec bash "$(dirname "$0")/gate-verify.sh"
        ;;
    harness:defining|harness:using-harness)
        # These skills are always allowed
        exit 0
        ;;
    *)
        # Non-harness skills pass through
        exit 0
        ;;
esac
