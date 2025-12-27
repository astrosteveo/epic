---
name: executing
description: "Use ONLY after plan.md is approved. Implements changes following the approved plan with TDD. Follows steps, tracks progress, commits atomically."
---

# Executing Phase

Implement the changes following the approved plan. TDD by default.

## When to Use

- After plan is approved
- For simple, well-defined tasks that skip planning
- Returning to continue implementation after interruption

## Subagent Dispatch

**IMPORTANT: Use subagents for all execution work.**

The main agent orchestrates execution by dispatching subagents for:
1. **Baseline review** - Understanding current state before changes
2. **Each implementation step** - Following the detailed plan
3. **Parallel execution** - Independent steps run simultaneously

This keeps main context low while subagents do the implementation work.

## The Process

### 1. Read the Plan

Start by reading:
- `plan.md` - The steps to follow
- `design.md` - Architecture context
- `requirements.md` - Success criteria to keep in mind

Check for any "Completed through step X" markers if resuming.

### 2. Baseline Review

**Before making any changes, dispatch a subagent to review current state:**

```
You are reviewing the current codebase state before implementing changes.

Context:
- Read .harness/{nnn}-{slug}/requirements.md for what we're building
- Read .harness/{nnn}-{slug}/design.md for the planned architecture
- Read .harness/{nnn}-{slug}/plan.md for the implementation steps

Your Task:
1. Review the files listed in the plan that will be modified
2. Document the current state: existing patterns, dependencies, test coverage
3. Identify any potential conflicts or integration points
4. Create a baseline understanding that will inform implementation

Produce a brief summary of current state and any concerns.
```

This baseline helps subagents implementing steps understand what they're working with.

### 3. Dispatch Subagents for Implementation

**Use subagents to execute plan steps efficiently:**

**Identify Parallelizable Steps**
- Review plan.md and identify independent steps (no dependencies between them)
- Steps that can run in parallel: touching different files, independent features
- Steps that must be sequential: build on each other's code, shared files

**Dispatch Strategy**
- **Sequential dependencies**: Use Task tool, wait for completion, then next step
- **Independent steps**: Dispatch multiple Task tools in parallel (single message, multiple tool calls)
- **Background execution**: Use `run_in_background=true` for long-running steps

**Subagent Prompt Format**
Each subagent receives the exact implementation details from the plan:
```
You are implementing Step {nnn}-{X} from an approved plan.

Context:
- Read .harness/{nnn}-{slug}/requirements.md for success criteria
- Read .harness/{nnn}-{slug}/design.md for architecture
- Read .harness/{nnn}-{slug}/plan.md Step {nnn}-{X} for full details
- This step is part of a larger plan

Your Task (from plan.md Step {nnn}-{X}):

**Dependencies:** {from plan}

**Files to create/modify:**
{exact list from plan}

**TDD Approach:**
{exact TDD guidance from plan}

**Implementation Details:**
{exact implementation details from plan - include:
 - Function signatures
 - Data structures
 - Algorithm approach
 - Edge cases to handle}

**Commit message:** {exact commit message from plan}

Follow TDD:
1. Write failing test first (as specified above)
2. Implement minimal code to pass (as specified above)
3. Run tests to verify
4. Commit with the exact message above

When complete, update plan.md to mark step as ✅ Complete with commit hash.
```

**The plan should be detailed enough that you can copy-paste step details directly into the subagent prompt.**

**Example: Parallel Dispatch**
```
Steps 3, 4, 5 are independent (different files, no shared state)
→ Dispatch all 3 in parallel using single message with 3 Task tool calls
→ Monitor progress, handle any failures
```

**Example: Sequential Execution**
```
Step 6 depends on Step 5's output
→ Wait for Step 5 completion
→ Then dispatch Step 6
```

### 4. Follow TDD by Default

For each step:

**Write the Test First**
1. Write a failing test that defines the expected behavior
2. Run the test - watch it fail
3. Confirm it fails for the right reason

**Implement Minimal Code**
4. Write just enough code to make the test pass
5. Run the test - watch it pass
6. Refactor if needed while keeping tests green

**Commit Atomically**
7. Commit with the message from plan.md
8. Update plan.md to mark step complete

### 5. When TDD Isn't Possible

Document exceptions and add tests after:

**Valid Exceptions**
- Legacy code without test infrastructure
- Exploratory/spike work
- UI changes that need visual verification
- Third-party integration with no test doubles

**When Skipping TDD**
- Document why in the commit or plan.md
- Add tests after implementation when possible
- Note any untested areas for verification phase

### 6. Track Progress

Update `plan.md` as you complete steps:
```markdown
## Step {nnn}-1: {Description}
**Status:** ✅ Complete (commit: abc1234)
```

If you need to pause:
```markdown
## Progress Note
Completed through step {nnn}-3. Next: step {nnn}-4.
```

### 7. Handle Issues

**Plan Issue (step doesn't work as written)**
- Stop execution
- Return to Plan phase
- Update `plan.md` with what failed and revised approach
- Resume execution after plan update

**New Discovery (unexpected technical issue)**
- Stop and assess scope
- May need to loop back to Research or even Define
- Document what changed in relevant artifacts
- Don't compound problems by pushing forward

**Regressions Introduced**
- Stop immediately
- Use `git diff` and `git log` to understand what changed
- Revert problematic commits if needed
- Update plan with what failed

### 8. Incremental Commits

**Commit Discipline**
- Each step = 1-3 logical commits
- Commits should be revertible units
- Use conventional commit messages from plan.md
- Don't bundle unrelated changes

**Commit Message Format**
```
{type}({scope}): {description}

{optional body with context}
```

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`

### 9. Offer Transition

When all steps are complete:

> "All plan steps are complete. Ready to move to Verify where we'll run the full test suite and validate against requirements?"

## Key Principles

- **Dispatch subagents** - Use Task tool to parallelize independent steps
- **TDD first** - Tests define behavior before implementation
- **Follow the plan** - Don't improvise beyond what's approved
- **Fail fast** - Stop at issues, don't compound them
- **Commit atomically** - Each commit is a logical, revertible unit
- **Track progress** - Keep plan.md updated for resumability
- **Stay focused** - Execute the plan, don't expand scope

## Returning to Execute

You may return to this phase when:
- Verify phase finds issues that need fixing
- Plan was updated after discovering issues
- Resuming after interruption

Check plan.md for progress markers before continuing.
