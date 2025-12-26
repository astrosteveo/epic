#!/bin/bash
# Gate: Block /research unless requirements.md exists
# Returns empty string = allowed, non-empty = blocked with message

# Find latest task directory
LATEST_TASK=$(ls -d .harness/[0-9]* 2>/dev/null | tail -1)

if [[ -z "$LATEST_TASK" ]]; then
    echo "BLOCKED: No task directory found."
    echo ""
    echo "Run /define first to establish requirements before researching."
    exit 1
fi

if [[ -f "$LATEST_TASK/requirements.md" ]]; then
    exit 0
fi

echo "BLOCKED: requirements.md not found in $LATEST_TASK"
echo ""
echo "The Research phase requires defined requirements."
echo "Run /define first to establish what we're building."
exit 1
