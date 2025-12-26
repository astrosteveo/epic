#!/bin/bash
# Gate: Block /verify unless execution has started
# Returns empty string = allowed, non-empty = blocked with message

# Find latest task directory
LATEST_TASK=$(ls -d .harness/[0-9]* 2>/dev/null | tail -1)

if [[ -z "$LATEST_TASK" ]]; then
    echo "BLOCKED: No task directory found."
    echo ""
    echo "Nothing to verify - no task in progress."
    exit 1
fi

if [[ ! -f "$LATEST_TASK/plan.md" ]]; then
    echo "BLOCKED: No plan.md found in $LATEST_TASK"
    echo ""
    echo "Run /plan and /execute before verifying."
    exit 1
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

echo "BLOCKED: No execution progress found"
echo ""
echo "The Verify phase validates completed work."
echo "Run /execute first to implement the plan."
exit 1
