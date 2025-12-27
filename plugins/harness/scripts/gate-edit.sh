#!/bin/bash
# Gate: Block Edit/Write unless plan is approved or in lightweight mode
# Returns empty string = allowed, non-empty = blocked with message

FILE_PATH="$1"

# Debug: Log what we received (remove after debugging)
echo "DEBUG gate-edit.sh: FILE_PATH='$FILE_PATH'" >&2
echo "DEBUG gate-edit.sh: PWD='$(pwd)'" >&2
echo "DEBUG gate-edit.sh: All TOOL_* vars:" >&2
env | grep "^TOOL_" >&2 || echo "DEBUG: No TOOL_* environment variables found" >&2

# Allow edits to .harness/ artifacts (always allowed)
if [[ "$FILE_PATH" == *".harness/"* ]]; then
    echo "DEBUG gate-edit.sh: ALLOWING .harness/ file" >&2
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
