# Claude Code Workflow

A simple workflow for using Claude Code effectively.

## Brainstorming

### Core Workflow Phases

1. **Define** - Establish what needs to be done
   - Start broad: What's the vision? What problem are we solving?
   - Narrow down: What are the functional requirements?
   - Identify constraints: Scope, compatibility, dependencies
   - Establish success criteria: How will we know it's done right?
   - **Artifact produced:**
     - `.harness/{nnn}-{slug-name}/requirements.md` - Vision, requirements, constraints, success criteria

2. **Research** - Informed discovery with clear direction
   - Explore the codebase structure and patterns
   - **Mine git history:** Commits are an audit trail - understand how code evolved, who worked on what, why changes were made (git log, git blame, git show, etc.)
   - Research best practices, library/framework APIs, docs
   - Identify technical dependencies and implications
   - **Testing focus:** Identify existing test frameworks/libraries; TDD is the default approach
   - **Artifacts produced:**
     - `.harness/{nnn}-{slug-name}/codebase.md` - Unopinionated facts about the codebase (no judgments, just what exists), including git history mapped to `file:line` with commit hashes for traceability
     - `.harness/{nnn}-{slug-name}/research.md` - External research findings (best practices, API docs, etc.)
   - **Output:** Present different approaches (as few or as many as appropriate), marking one as recommended
   - If user rejects all approaches: Don't get stuck - use Socratic method to understand the objection, then iterate or loop back to Define/Research as needed

3. **Plan** - Collaborative design through Socratic dialogue
   - Engage user section-by-section: "Does this sound right to you?"
   - Iterate until full agreement on approach
   - **Artifacts produced:**
     - `.harness/{nnn}-{slug-name}/design.md` - High-level design decisions
     - `.harness/{nnn}-{slug-name}/plan.md` - Detailed implementation steps

4. **Execute** - Implement the changes
   - **TDD by default:** Write tests first, then implementation
   - Follow the plan step-by-step, updating progress as you go
   - When TDD isn't possible (legacy code, exploratory work, etc.), document why and add tests after
   - Make incremental changes, commit logical units of work

5. **Verify** - Rigorous validation before completion (peer review gate)
   - Run the entire test suite, not just new tests
   - Validate against `requirements.md` - were all success criteria met?
   - Validate against `plan.md` - were all steps completed?
   - Ensure tests use real harnesses with actual integrations/implementations
   - Tests must pass because the wiring is correct, not just superficially
   - Review like a peer reviewer before a PR merge
   - **Not complete until BOTH:** tests pass AND implementation satisfies user
   - If tests pass but user spots issues → loop back to Execute or Plan as needed

### Key Principles

- **Socratic method throughout** - Always use guided questioning to reach understanding and agreement (broad vision → functional requirements → constraints → specifics)
- **Git as audit trail** - Commits tell the story of the project; leverage git history to understand context, evolution, and intent behind changes
- Start by reading existing code before making changes
- Use TodoWrite to track progress on multi-step tasks
- Make incremental changes and verify as you go

### Workflow Triggers

When should each phase kick in?

- **Define**: Always first - when a new task is presented
- **Research**: After clarifying intent, to gather technical context and best practices
- **Plan**: For any non-trivial implementation (3+ steps or multiple files)
- **Execute**: After plan approval or for simple, well-defined tasks
- **Verify**: After any code changes, before marking complete

### Phase Loops & Artifact Updates

Workflows aren't always linear. When new information emerges, loop back and update artifacts to keep them accurate.

**Research reveals something that changes requirements:**
- Pause research, return to Define phase
- Use Socratic dialogue to discuss implications with user
- Update `requirements.md` with new understanding
- Resume Research

**Planning uncovers technical blockers or alternative approaches:**
- Pause planning, return to Research if more info needed
- Or return to Define if it affects requirements/constraints
- Update `codebase.md` or `research.md` with new findings
- Revise the approaches if the landscape has changed

**Execution hits unexpected issues:**
- Stop and assess: Is this a plan issue or a new discovery?
- If plan issue → return to Plan, update `plan.md` and `design.md`
- If new discovery → may need to loop back to Research or even Define
- Document what changed and why in the relevant artifacts

**Key rule:** Artifacts must always reflect current understanding. Out-of-date docs are worse than no docs - they mislead future work.

### Automation vs. User Control

Human in the loop for all decision points - it's their idea, their requirements.

| Phase | User Role | Claude Role |
|-------|-----------|-------------|
| **Define** | Drives requirements | Shapes & guides through Socratic questioning |
| **Research** | Reviews output | Executes autonomously, surfaces findings |
| **Plan** | Approves each section | Proposes, iterates based on feedback |
| **Execute** | Can interrupt | Implements autonomously per approved plan |
| **Verify** | Final approval | Runs checks, reports results |

Claude can help shape requirements and provide direction when the user wants guidance or agrees with recommendations.

### Phase Transitions

**Hybrid approach:** Claude infers and offers, user can also initiate explicitly.

- Claude recognizes when to transition and offers: "Ready to move to Research?"
- User can accept, decline, or redirect
- Slash commands available for explicit control:
  - `/define` - Start or return to Define phase
  - `/research` - Start or return to Research phase
  - `/plan` - Start or return to Plan phase
  - `/execute` - Start execution
  - `/verify` - Run verification

User always has control to skip, revisit, or override Claude's suggestions.

### Plan Detail Levels

**`design.md`** - High-level architecture
- Component relationships and data flow
- Key interfaces and boundaries
- Mermaid diagrams to illustrate flow
- Answers: "What are we building and how do the pieces fit together?"

**`plan.md`** - Granular implementation steps
- Step-by-step tasks with specific files to create/modify
- Order of operations
- Each step = 1-3 logical commits worth of work
- Answers: "What exactly do I do first, second, third?"

**Scope control:** If a step grows too large, break it into multiple feature specs rather than executing something too big in scope.

**Deferral:** During planning, Claude can recommend deferring items that:
- Are out of scope for the current task
- Would add significant complexity
- Are nice-to-have but not essential
- Depend on future work

Deferred items are added to `.harness/backlog.md` - a project-level backlog for tech debt and deferred items across all tasks. This keeps them visible and actionable for future sprints.

**Backlog hygiene:**
- Periodically review backlog with user (suggest during natural breaks)
- Mark stale items that are no longer relevant
- Prioritize items when starting new work cycles
- Consider integrating with external issue trackers for larger projects

**Discovered bugs (unrelated to current task):**
- Note it, call it out to user: "Found an unrelated bug in X"
- Log to `.harness/backlog.md` with details
- Continue with current task - don't get sidetracked

**Refactoring opportunities (unrelated to current task):**
- Note it as an improvement opportunity
- Log to `.harness/backlog.md` with context on what could be better
- Keep moving - helps track code quality even outside your immediate scope

### Task Identification & Context Switching

**Unique identifiers everywhere** to prevent duplicate/ambiguous context:

- Task directories: `.harness/{nnn}-{slug-name}/` (e.g., `001-user-auth/`, `002-dark-mode/`)
- Artifacts live inside directories: `requirements.md`, `design.md`, `plan.md`, etc.
- Plan steps have task-prefixed IDs: `001-1`, `001-2`, `001-3` (for cross-task references)

**Switching between tasks:**
- Each task's state is fully contained in its directory
- To switch: read the target task's artifacts to restore context
- Active task can be tracked in `.harness/active-task.md` or inferred from conversation

**Concurrent tasks:**
- User can pause Task A, work on Task B, return to Task A
- Artifacts preserve state; no confusion about which context applies
- Cross-task references use full paths (e.g., "see `001-user-auth/design.md`")

### Interruptions & Scope Changes

**Scope additions** ("actually, let's also add X"):
- Loop back to Define, update `requirements.md`
- Assess impact: Does this change the design? The plan?
- Ripple through Research/Plan as needed before resuming Execute

**Pivot or stop** ("I need to work on something else"):
- Checkpoint current state in artifacts
- Mark where we left off in `plan.md` (e.g., "Completed through step 3")
- Commit any work-in-progress to a branch if appropriate

**Resume after break**:
- Read artifacts to restore context
- Confirm with user: "Last time we completed X, ready to continue with Y?"

**External blockers** (dependency issues, API changes, etc.):
- Treat like execution issues - stop, assess, loop back to appropriate phase
- Update artifacts to reflect the blocker and any workarounds

**Task dependencies** (Task B needs Task A done first):
- Note dependency in `requirements.md`: "Blocked by: 001-user-auth"
- Track in `.harness/backlog.md` with `[BLOCKED]` tag so it's not lost
- When blocker is resolved, pick up the dependent task

### Failure Recovery & Rollback

When things go wrong:

**Execution fails or introduces regressions:**
- Stop immediately, don't compound the problem
- Use `git diff` and `git log` to understand what changed
- Revert problematic commits if needed (`git revert`)
- Update `plan.md` to note what failed and why
- Loop back to Plan or Research to find alternative approach

**Broken test suite before starting:**
- Note it as a blocker
- Either fix tests first (separate task) or proceed with caution
- Document known test issues in `codebase.md`

**Corrupted or conflicting artifacts:**
- Git history is the source of truth
- Regenerate artifacts from current code state if needed
- When in doubt, start fresh with a new task directory

### Lightweight Mode (Trivial Tasks)

For simple, low-risk changes (typo fixes, config tweaks, one-line changes):

- Skip most artifacts - no need for full ceremony
- Minimal flow: quick Define (verbal) → Execute → Verify
- Claude recognizes trivial tasks and suggests lightweight mode
- User can always request full workflow if preferred

### Spikes (Exploratory Work)

When you can't define requirements without exploring first:

- Claude recognizes when a spike is needed: "We don't know enough to define this yet - let's explore first"
- Create a spike task: `.harness/{nnn}-spike-{topic}/`
- Spike is lightweight: quick prototype, API exploration, feasibility check
- **Spike artifacts:**
  - `spike-findings.md` - What was learned, what's feasible, recommendations
- Spike output feeds into a proper Define phase for the real task
- Spike code is throwaway - learnings matter, not the prototype itself

---

*This is a living document for workflow brainstorming.*
