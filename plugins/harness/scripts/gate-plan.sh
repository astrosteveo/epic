#!/bin/bash
# Gate: Block /plan unless research artifacts exist
# Returns empty string = allowed, non-empty = blocked with message

# Find latest task directory
LATEST_TASK=$(ls -d .harness/[0-9]* 2>/dev/null | tail -1)

if [[ -z "$LATEST_TASK" ]]; then
    echo "BLOCKED: No task directory found."
    echo ""
    echo "Run /define first, then /research before planning."
    exit 1
fi

if [[ ! -f "$LATEST_TASK/requirements.md" ]]; then
    echo "BLOCKED: requirements.md not found in $LATEST_TASK"
    echo ""
    echo "Run /define first to establish requirements."
    exit 1
fi

if [[ -f "$LATEST_TASK/codebase.md" ]] || [[ -f "$LATEST_TASK/research.md" ]]; then
    exit 0
fi

echo "BLOCKED: No research artifacts found in $LATEST_TASK"
echo ""
echo "The Plan phase requires research to inform the design."
echo "Run /research first to explore the codebase and best practices."
echo ""
echo "Current state:"
echo "  ✓ requirements.md exists"
echo "  ✗ codebase.md missing"
echo "  ✗ research.md missing"
exit 1
