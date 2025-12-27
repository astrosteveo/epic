#!/bin/bash
# Gate: Block /research unless requirements.md exists
# Returns empty string = allowed, non-empty = blocked with message

# Find latest task directory
LATEST_TASK=$(ls -d .harness/[0-9]* 2>/dev/null | tail -1)

if [[ -z "$LATEST_TASK" ]]; then
    echo "BLOCKED: No task directory found. Run /harness:define first to establish requirements before researching." >&2
    exit 2
fi

if [[ -f "$LATEST_TASK/requirements.md" ]]; then
    exit 0
fi

echo "BLOCKED: requirements.md not found in $LATEST_TASK. The Research phase requires defined requirements. Run /harness:define first." >&2
exit 2
