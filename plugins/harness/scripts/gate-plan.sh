#!/bin/bash
# Gate: Block /plan unless research artifacts exist
# Returns empty string = allowed, non-empty = blocked with message

# Find latest task directory
LATEST_TASK=$(ls -d .harness/[0-9]* 2>/dev/null | tail -1)

if [[ -z "$LATEST_TASK" ]]; then
    echo "BLOCKED: No task directory found. Run /harness:define first, then /harness:research before planning." >&2
    exit 2
fi

if [[ ! -f "$LATEST_TASK/requirements.md" ]]; then
    echo "BLOCKED: requirements.md not found in $LATEST_TASK. Run /harness:define first to establish requirements." >&2
    exit 2
fi

if [[ -f "$LATEST_TASK/codebase.md" ]] || [[ -f "$LATEST_TASK/research.md" ]]; then
    exit 0
fi

echo "BLOCKED: No research artifacts found in $LATEST_TASK. The Plan phase requires research to inform the design. Run /harness:research first to explore the codebase." >&2
exit 2
