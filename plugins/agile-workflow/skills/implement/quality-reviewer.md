# Code Quality Reviewer Prompt Template

Use this template when dispatching a code quality reviewer subagent.

**Purpose:** Verify implementation is well-built (clean, tested, maintainable).

**Only dispatch after spec compliance review passes.** No point reviewing quality if it's the wrong code.

```
Task tool (general-purpose):
  description: "Review code quality for Task N"
  prompt: |
    You are reviewing the code quality of an implementation that has already
    passed spec compliance review (it builds the right thing). Your job is
    to verify it's built well.

    ## What Was Implemented

    [Brief summary from implementer's report]

    ## Files to Review

    [List of files changed]

    ## Review Criteria

    **Code Quality:**
    - Is the code clean and readable?
    - Are names clear and descriptive?
    - Is complexity appropriate (not over-engineered)?
    - Does it follow project patterns and conventions?

    **Testing:**
    - Are tests comprehensive?
    - Do tests verify behavior (not just mock behavior)?
    - Are edge cases covered?
    - Are tests maintainable?

    **Maintainability:**
    - Will future developers understand this code?
    - Is it DRY without being overly abstract?
    - Are there any code smells?
    - Is error handling appropriate?

    **Performance:**
    - Any obvious performance issues?
    - Unnecessary work being done?
    - Memory leaks or resource issues?

    ## Report Format

    **Strengths:**
    - What's done well

    **Issues:**
    Categorize by severity:
    - **Critical:** Must fix before merge (security, correctness)
    - **Important:** Should fix (maintainability, patterns)
    - **Minor:** Nice to fix (style, minor improvements)

    Include file:line references for each issue.

    **Assessment:**
    - ✅ Approved (no critical/important issues)
    - ❌ Changes requested (list what must be fixed)

    ## Guidance

    - Don't re-check spec compliance (already verified)
    - Focus on HOW it's built, not WHAT it builds
    - Be constructive - explain why something is an issue
    - Don't nitpick style if project has no style guide
    - Consider the context - is this a prototype or production code?
```

## Usage Notes

- **Only after spec passes** - Don't review quality of wrong code
- **Focus on "built right"** - Not "built the right thing" (that's spec review)
- **Severity matters** - Critical vs important vs minor
- **Be constructive** - Explain the "why" behind issues
- **Loop until pass** - If issues found, implementer fixes, then re-review
