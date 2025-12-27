#!/bin/bash
# Gate: Block /verify unless execution has started
# Returns empty string = allowed, non-empty = blocked with message

# Find latest task directory
LATEST_TASK=$(ls -d .harness/[0-9]* 2>/dev/null | tail -1)

if [[ -z "$LATEST_TASK" ]]; then
    echo "BLOCKED: No task directory found. Nothing to verify - no task in progress." >&2
    exit 2
fi

if [[ ! -f "$LATEST_TASK/plan.md" ]]; then
    echo "BLOCKED: No plan.md found in $LATEST_TASK. Run /harness:plan and /harness:execute before verifying." >&2
    exit 2
fi

# Check if any steps are marked complete
if grep -q "✅" "$LATEST_TASK/plan.md" || grep -q "Complete" "$LATEST_TASK/plan.md"; then
    exit 0
fi

# Check for recent commits (execution happened)
RECENT_COMMITS=$(git log --oneline -5 2>/dev/null | head -1)
if [[ -n "$RECENT_COMMITS" ]]; then
    exit 0
fi

echo "BLOCKED: No execution progress found. The Verify phase validates completed work. Run /harness:execute first to implement the plan." >&2
exit 2
