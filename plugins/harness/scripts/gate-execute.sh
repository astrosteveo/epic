#!/bin/bash
# Gate: Block /execute unless plan is approved
# Returns empty string = allowed, non-empty = blocked with message

# Allow if lightweight mode is active
if [[ -f ".harness/.lightweight" ]]; then
    exit 0
fi

# Find latest task directory
LATEST_TASK=$(ls -d .harness/[0-9]* 2>/dev/null | tail -1)

if [[ -z "$LATEST_TASK" ]]; then
    echo "BLOCKED: No task directory found."
    echo ""
    echo "Run /define → /research → /plan before executing."
    exit 1
fi

if [[ ! -f "$LATEST_TASK/plan.md" ]]; then
    echo "BLOCKED: plan.md not found in $LATEST_TASK"
    echo ""
    echo "Run /plan first to create an implementation plan."
    exit 1
fi

if grep -q "<!-- APPROVED -->" "$LATEST_TASK/plan.md"; then
    exit 0
fi

echo "BLOCKED: Plan not approved in $LATEST_TASK/plan.md"
echo ""
echo "The Execute phase requires user approval of the plan."
echo ""
echo "To approve, add this marker to plan.md:"
echo "  <!-- APPROVED -->"
echo ""
echo "Or have the user confirm: \"I approve this plan\""
exit 1
