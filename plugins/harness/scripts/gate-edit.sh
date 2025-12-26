#!/bin/bash
# Gate: Block Edit/Write unless plan is approved or in lightweight mode
# Returns empty string = allowed, non-empty = blocked with message

FILE_PATH="$1"

# Allow edits to .harness/ artifacts (always allowed)
if [[ "$FILE_PATH" == *".harness/"* ]]; then
    exit 0
fi

# Allow if lightweight mode is active
if [[ -f ".harness/.lightweight" ]]; then
    exit 0
fi

# Check for approved plan in any task directory
APPROVED_PLAN=$(find .harness -maxdepth 2 -name "plan.md" -exec grep -l "<!-- APPROVED -->" {} \; 2>/dev/null | head -1)

if [[ -n "$APPROVED_PLAN" ]]; then
    exit 0
fi

# Block with message
echo "BLOCKED: No approved plan found."
echo ""
echo "The harness workflow requires an approved plan before modifying code."
echo ""
echo "Current state:"
if [[ -d ".harness" ]]; then
    LATEST_TASK=$(ls -d .harness/[0-9]* 2>/dev/null | tail -1)
    if [[ -n "$LATEST_TASK" ]]; then
        echo "  Active task: $LATEST_TASK"
        [[ -f "$LATEST_TASK/requirements.md" ]] && echo "  ✓ requirements.md exists" || echo "  ✗ requirements.md missing - run /define"
        [[ -f "$LATEST_TASK/codebase.md" || -f "$LATEST_TASK/research.md" ]] && echo "  ✓ research artifacts exist" || echo "  ✗ research artifacts missing - run /research"
        [[ -f "$LATEST_TASK/plan.md" ]] && echo "  ✓ plan.md exists (needs approval)" || echo "  ✗ plan.md missing - run /plan"
        if [[ -f "$LATEST_TASK/plan.md" ]]; then
            grep -q "<!-- APPROVED -->" "$LATEST_TASK/plan.md" && echo "  ✓ plan approved" || echo "  ✗ plan not approved - add <!-- APPROVED --> marker"
        fi
    else
        echo "  No task directory found - run /define to start"
    fi
else
    echo "  No .harness directory - run /define to start"
fi
echo ""
echo "To bypass for trivial tasks: touch .harness/.lightweight"
exit 1
