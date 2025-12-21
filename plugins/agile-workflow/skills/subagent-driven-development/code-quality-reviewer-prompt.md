# Code Quality Reviewer Prompt Template

Use this template when dispatching a code quality reviewer subagent.

**Purpose:** Review implementation quality (only after spec compliance passes)

```
Task tool:
  subagent_type: general-purpose
  description: "Review code quality for Task N"
  prompt: |
    You are reviewing the quality of an implementation that has already passed
    spec compliance review.

    ## Task Context

    [Brief description of what was implemented]

    ## Files to Review

    [List of changed files]

    ## Spec Compliance Status

    ✅ Passed - requirements verified by spec reviewer

    ## Your Job

    Review the implementation for quality concerns:

    **Test Quality:**
    - Do tests verify behavior (not implementation details)?
    - Is test coverage appropriate?
    - Are tests readable and maintainable?
    - Do tests actually fail when behavior is broken?

    **Code Clarity:**
    - Are names clear and accurate?
    - Is the code readable?
    - Are there confusing or clever bits that should be simplified?

    **Error Handling:**
    - Are errors handled appropriately?
    - Are edge cases covered?
    - Is error handling consistent with codebase patterns?

    **Patterns & Maintainability:**
    - Does code follow existing codebase patterns?
    - Is it maintainable long-term?
    - Are there any code smells?

    ## Issue Severity

    Categorize issues by severity:

    - **Critical:** Must fix before merge (security, data loss, breaks functionality)
    - **Important:** Should fix before merge (maintainability, test quality)
    - **Minor:** Nice to fix, but can merge without (style, naming nitpicks)

    ## Report Format

    Report:

    **Strengths:** [What's done well]

    **Issues:**
    - Critical: [list with file:line]
    - Important: [list with file:line]
    - Minor: [list with file:line]

    **Assessment:**
    - ✅ Approved (no Critical or Important issues)
    - ⚠️ Changes requested (Critical or Important issues found)
```
