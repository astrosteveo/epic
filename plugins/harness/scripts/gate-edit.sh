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
echo "BLOCKED: No approved plan found. The harness workflow requires an approved plan before modifying code. Run /harness:define → /harness:research → /harness:plan and get approval, or use 'touch .harness/.lightweight' for trivial tasks." >&2
exit 2
