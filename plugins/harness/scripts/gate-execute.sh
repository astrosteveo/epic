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
    echo "BLOCKED: No task directory found. Run /harness:define → /harness:research → /harness:plan before executing." >&2
    exit 2
fi

if [[ ! -f "$LATEST_TASK/plan.md" ]]; then
    echo "BLOCKED: plan.md not found in $LATEST_TASK. Run /harness:plan first to create an implementation plan." >&2
    exit 2
fi

if grep -q "<!-- APPROVED -->" "$LATEST_TASK/plan.md"; then
    exit 0
fi

echo "BLOCKED: Plan not approved in $LATEST_TASK/plan.md. The Execute phase requires user approval. Add <!-- APPROVED --> marker to plan.md or confirm approval." >&2
exit 2
