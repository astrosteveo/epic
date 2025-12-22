# Spec Compliance Reviewer Prompt Template

Use this template when dispatching a spec compliance reviewer subagent.

**Purpose:** Verify implementer built what was requested (nothing more, nothing less).

```
Task tool (general-purpose):
  description: "Review spec compliance for Task N"
  prompt: |
    You are reviewing whether an implementation matches its specification.

    ## What Was Requested

    [FULL TEXT of task requirements from plan]

    ## What Implementer Claims They Built

    [From implementer's report]

    ## CRITICAL: Do Not Trust the Report

    The implementer finished suspiciously quickly. Their report may be incomplete,
    inaccurate, or optimistic. You MUST verify everything independently.

    **DO NOT:**
    - Take their word for what they implemented
    - Trust their claims about completeness
    - Accept their interpretation of requirements
    - Assume their self-review was thorough

    **DO:**
    - Read the actual code they wrote
    - Compare actual implementation to requirements line by line
    - Check for missing pieces they claimed to implement
    - Look for extra features they didn't mention

    ## Your Job

    Read the implementation code and verify:

    **Missing requirements:**
    - Did they implement everything that was requested?
    - Are there requirements they skipped or missed?
    - Did they claim something works but didn't actually implement it?

    **Extra/unneeded work:**
    - Did they build things that weren't requested?
    - Did they over-engineer or add unnecessary features?
    - Did they add "nice to haves" that weren't in spec?

    **Misunderstandings:**
    - Did they interpret requirements differently than intended?
    - Did they solve the wrong problem?
    - Did they implement the right feature but wrong way?

    **Verify by reading code, not by trusting report.**

    ## Files to Review

    [List of files the implementer said they changed]

    ## Report Format

    Report one of:

    ✅ **Spec compliant**
    - All requirements implemented correctly
    - Nothing extra added
    - No misunderstandings

    ❌ **Issues found:**
    - Missing: [specific requirement, file:line reference]
    - Extra: [what was added that wasn't requested]
    - Misunderstanding: [what was interpreted wrong]

    Be specific. Include file:line references for every issue.
```

## Usage Notes

- **Skepticism is the point** - The reviewer exists because implementers make mistakes
- **Read actual code** - Don't trust the report, verify independently
- **Check both directions** - Missing requirements AND extra work
- **Specific feedback** - File:line references for every issue
- **Loop until pass** - If issues found, implementer fixes, then re-review
