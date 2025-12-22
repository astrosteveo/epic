# Agile Workflow Plugin - Brainstorm

## What Works Well in Professional Human Software Development

### Planning & Discovery
- **PRDs/Specs first** - Writing down requirements before coding catches misunderstandings early
- **Spike/research phase** - Time-boxed exploration before committing to an approach
- **Breaking work into small deliverables** - Reduces risk, enables faster feedback
- **Definition of Done** - Clear acceptance criteria prevent scope creep

### Quality Practices
- **TDD** - Tests as executable specifications, prevents regressions
- **Code review** - Fresh eyes catch issues, spreads knowledge
- **Pair programming** - Real-time collaboration catches bugs early
- **Refactoring in small steps** - Keep code clean without big risky rewrites

### Process
- **Standups/check-ins** - Regular sync points prevent drift
- **Retrospectives** - Learning from what worked/didn't
- **Git branching/worktrees** - Isolation for experiments, clean history
- **CI/CD** - Automated verification on every change

---

## What Works Well with AI Agents

### Strengths
- **Tireless exploration** - Can read entire codebases without fatigue
- **Pattern matching** - Good at recognizing similar code/problems across files
- **Parallel research** - Can spawn multiple search agents simultaneously
- **Consistent execution** - Won't skip steps when given a checklist
- **No ego** - Accepts feedback and corrections without defensiveness

### Weaknesses to Account For
- **Context drift** - Can lose track of the big picture in long sessions
- **Overconfidence** - May proceed without verifying assumptions
- **Gold plating** - Tendency to over-engineer or add unnecessary features
- **Hallucination** - May invent APIs, assume file contents
- **No persistence** - Each session starts fresh without memory

---

## Meshing Them Together - Plugin Ideas

### 1. Structured Phases (Current Direction)
```
Research → Plan → Implement → Review
```
- Each phase has explicit entry/exit criteria
- Human approves transitions between phases
- Prevents AI from jumping straight to coding

### 2. Living PRD
- Plugin maintains a `PROJECT.md` or similar
- Updated as requirements evolve
- AI checks against PRD before implementing
- Prevents drift from original goals

### 3. Checkpoint System
- Regular "save points" during implementation
- AI summarizes progress and next steps
- Human can review/redirect before continuing
- Compensates for context drift

### 4. Verification Loops
- After implementing, AI must verify against criteria
- Run tests, check acceptance criteria
- Self-review before requesting human review
- Catches hallucinations early

### 5. Socratic Discovery (from description)
- AI asks clarifying questions before assuming
- "I notice X could be done via A or B - which fits better?"
- Reduces backtracking from wrong assumptions

### 6. Git Worktree Integration
- Each feature/experiment in isolated worktree
- Easy rollback if approach doesn't work
- Clean separation of concerns

### 7. Task Decomposition Assistant
- AI helps break PRD into implementation tasks
- Suggests order based on dependencies
- Estimates complexity (not time!) for planning

---

## Questions to Explore

- How granular should checkpoints be? Too many = friction, too few = drift
- How to handle multi-session projects? (memory/persistence)
- Should the plugin enforce phases or just guide?
- How to integrate with existing git workflows?
- What's the right balance of AI autonomy vs human approval?

---

## Potential Workflow

```
1. /start-project
   - User provides high-level goal
   - AI asks clarifying questions (Socratic)
   - Creates initial PRD draft
   - Human approves/edits PRD

2. /plan
   - AI breaks PRD into tasks
   - Identifies dependencies
   - Human approves task list

3. /implement [task]
   - AI works on specific task
   - Regular checkpoints
   - Must pass verification before "done"

4. /review
   - AI self-reviews changes
   - Prepares summary for human review
   - Human approves or requests changes

5. /retrospective
   - What worked?
   - What to improve?
   - Update process for next iteration
```

---

## Deep Dive: Checkpoint System

### Problems Checkpoints Solve

1. **Context drift** - After 50+ tool calls, AI loses sight of original goal
2. **Runaway implementation** - AI keeps going down wrong path without pause
3. **Invisible progress** - Human can't tell what's happening in long operations
4. **Difficult recovery** - When things go wrong, hard to know where to rollback
5. **Session boundaries** - When conversation ends, all context is lost
6. **Scope creep** - Without stopping points, AI may "improve" beyond the task

### What Triggers a Checkpoint?

**Option A: Time/effort based**
- After N tool calls (e.g., every 20 calls)
- After N minutes of work
- Problem: arbitrary, may interrupt mid-thought

**Option B: Milestone based**
- After completing a logical unit of work
- When transitioning between subtasks
- Before making "risky" changes (deletes, refactors)
- Problem: requires AI judgment on what's "logical"

**Option C: Hybrid**
- Milestones preferred, but forced checkpoint after max threshold
- "It's been 30 tool calls - pause and summarize even if mid-task"
- Best of both: natural breaks when possible, forced breaks as safety net

**Option D: Human-triggered**
- User can invoke `/checkpoint` anytime
- Good for: "I'm stepping away, save your progress"
- Complements automatic checkpoints

### What Goes In a Checkpoint?

```markdown
## Checkpoint: 2024-01-15 14:32

### Current Task
Implementing user authentication (Task 3 of 7)

### Progress
- [x] Created auth middleware
- [x] Added login endpoint
- [ ] Add logout endpoint (in progress)
- [ ] Add session management

### Key Decisions Made
- Using JWT instead of sessions (per PRD requirement)
- Storing tokens in httpOnly cookies for security

### Files Modified
- src/middleware/auth.ts (created)
- src/routes/auth.ts (created)
- src/index.ts (modified - added auth routes)

### Current State
- Tests passing: 12/12
- Build status: clean
- Last git commit: abc123 "Add login endpoint"

### Next Steps
1. Complete logout endpoint
2. Add token refresh logic
3. Write integration tests

### Open Questions
- Should refresh tokens be stored in DB or Redis?
- What's the desired token expiry time?

### How to Resume
"Continue implementing Task 3. Last completed: login endpoint.
Next: logout endpoint. See checkpoint for context."
```

### Where Do Checkpoints Live?

**Option A: In conversation (ephemeral)**
- Just output to chat
- Lost when session ends
- Simplest implementation

**Option B: Project file (persistent)**
- `.agile/checkpoints/2024-01-15-1432.md`
- Survives sessions
- Can be reviewed later
- Git-trackable

**Option C: CLAUDE.md / MEMORY.md (hybrid)**
- Single file updated with latest checkpoint
- Overwrites previous (keeps only recent)
- Claude Code reads this on session start

**Recommendation:** Option B with Option C summary
- Full checkpoints in `.agile/checkpoints/`
- Latest summary in `.agile/CURRENT.md`
- On new session, AI reads CURRENT.md to resume

### Git Integration

Checkpoints pair naturally with commits:

```
[Checkpoint triggered]
   ↓
1. Summarize progress
2. Run tests
3. If tests pass: git commit with checkpoint summary
4. Write checkpoint file
5. Ask human: continue, pause, or redirect?
```

This gives you:
- Atomic commits at logical boundaries
- Easy rollback via git (each checkpoint = commit)
- Clean history with meaningful messages

### Checkpoint Granularity Trade-offs

| Granularity | Pros | Cons |
|-------------|------|------|
| Fine (every 10 calls) | Frequent visibility, easy recovery | Interrupts flow, verbose history |
| Medium (every 25-30 calls) | Balance of visibility and flow | May still miss problems |
| Coarse (per subtask) | Natural boundaries, clean history | Long gaps without visibility |
| Adaptive | Adjusts based on risk/complexity | Harder to implement |

**Proposed default:** Medium (25-30 calls) with milestone override
- Force checkpoint at 30 calls max
- Also checkpoint on: subtask complete, before risky ops, on explicit request

### Interaction Model

```
AI: [working on implementation...]
AI: [25 tool calls reached]
AI:
    ═══════════════════════════════════════
    📍 CHECKPOINT - Authentication System
    ═══════════════════════════════════════

    Progress: Login endpoint complete (Task 3.1)
    Tests: 8 passing, 0 failing
    Files: 3 modified, 1 created

    Next: Implement logout endpoint (Task 3.2)

    → Continue | Pause | Show details | Redirect
    ═══════════════════════════════════════

User: [types "continue" or just presses enter]
AI: [resumes work...]
```

### Implementation Approaches

**Via System Prompt (simplest)**
- Plugin adds instructions: "After every 25 tool calls, pause and checkpoint"
- Pro: No code needed, just prompt engineering
- Con: AI may ignore/forget, no enforcement

**Via Hook (medium complexity)**
- `post_tool_call` hook counts calls, injects reminder
- When threshold hit, inject: "STOP. Output checkpoint now."
- Pro: Reliable triggering
- Con: Can't truly pause AI, just strongly suggest

**Via Skill Command (user-triggered)**
- `/checkpoint` skill that outputs template
- User invokes when they want a save point
- Pro: Full user control
- Con: Relies on user remembering to invoke

**Via State File (persistent)**
- Plugin tracks state in `.agile/state.json`
- Hook reads state, injects context on each call
- Checkpoint writes to state file
- Pro: Survives sessions
- Con: More complex, file I/O on every call

### Recovery Scenarios

**Scenario: AI went down wrong path**
```
User: /rollback checkpoint-3
AI: Rolling back to checkpoint-3...
    - Reverting to commit abc123
    - Loading checkpoint context
    - Ready to continue from: "Login endpoint complete"
```

**Scenario: New session, continuing work**
```
[User starts new Claude Code session]
AI: [reads .agile/CURRENT.md]
AI: I see you were working on the authentication system.
    Last checkpoint: Login endpoint complete
    Next planned: Logout endpoint

    Would you like to continue from here?
```

**Scenario: Human wants to redirect**
```
AI: 📍 CHECKPOINT - implemented login...
User: Actually, let's pause auth and fix that CSS bug first
AI: Understood. Saving checkpoint for auth work.
    Switching context to CSS bug.
    [Creates branch, stashes changes, starts new task]
```

### Open Questions for Checkpoint System

1. **Checkpoint bloat** - How many checkpoints before cleanup?
   - Auto-prune old checkpoints?
   - Keep only last N?
   - Archive to separate location?

2. **Merge conflicts** - Multiple sessions working on same project
   - Each session has own checkpoint stream?
   - How to reconcile divergent checkpoints?

3. **Verification rigor** - How much testing at checkpoint?
   - Just run existing tests?
   - Require tests to pass before checkpoint?
   - What if tests are slow?

4. **User fatigue** - If checkpoints are too frequent/verbose
   - Silent checkpoints (write file, don't output)?
   - Summary-only output, details in file?
   - Let user configure verbosity?

5. **Scope** - Should checkpoints track:
   - Just code changes?
   - Also conversations/decisions?
   - Research findings?
   - Failed approaches (for learning)?

---

### Critical Constraint: Context Window Economy

**Reality:** After ~60% context window usage, AI quality diminishes significantly.

Keep checkpoint info minimal in context. Write details to files, not conversation.

---

## Simpler Approach: Use What Exists

**Realization:** Don't build a checkpoint system. Git IS the checkpoint system.

### The Minimal Stack

1. **PRD** - The north star
   - What are we building and why?
   - Acceptance criteria
   - Out of scope (just as important)

2. **Plan** - Before each idea/task
   - Research → understand the problem
   - Design → how will we solve it?
   - Human approval before implementation

3. **Implementation Plan** - Detailed steps
   - Break into small, committable units
   - Each step = potential commit
   - Tests for each step

4. **Git** - The checkpoint system
   - Commits = checkpoints
   - Branches = isolation
   - History = audit trail
   - Rollback = git reset

### Why This Works

- **PRD prevents drift** - Always have the goal to check against
- **Planning prevents runaway** - Human approves before coding starts
- **Small commits = natural checkpoints** - No elaborate system needed
- **Git history = session memory** - Look at commits to see what happened

### What the Plugin Actually Needs

```
/new-project  → Create PRD through Socratic questioning
/plan         → Research + design before implementing
/implement    → Work through plan, commit often
```

That's it. The "checkpoint system" is just: **commit early, commit often, with good messages**.

---

## /discovery - The Required Entry Point

**Concept:** Every creative idea must start with discovery. No jumping straight to code.

### What Discovery Does

1. **Understand the problem** - What are you actually trying to solve?
2. **Explore the space** - What exists? What are the constraints?
3. **Surface assumptions** - What are we taking for granted?
4. **Define success** - How will we know when we're done?

### Lean Discovery Flow

```
User: /discovery I want to add user authentication

AI: Before we build anything, let me understand:

    1. What problem does auth solve for you?
       - Protecting routes? Personalizing content? Tracking users?

    2. What exists today?
       - Any current auth? Users table? Sessions?

    3. What are your constraints?
       - Must use specific provider? Self-hosted? Timeline?

User: [answers]

AI: Based on that, here's what I understand:
    - Goal: [restated]
    - Constraints: [listed]
    - Success looks like: [criteria]

    Does this capture it? [Y/n]

User: Y

AI: Discovery complete. Saved to .agile/discoveries/auth.md
    Next: /plan auth
```

### What Makes It Lean

**Lean infrastructure:**
- No multiple specialized agents
- No elaborate phase transitions
- No heavy state management
- Just conversation + markdown output

**But thorough discovery:**
- Deep Socratic questioning
- ~300 words per section (digestible chunks)
- Work through each area completely before moving on
- Human engagement at each step

### Socratic Method (à la superpowers)

The questioning IS the value. Don't rush it.

**Section 1: Problem Understanding (~300 words)**
```
AI: Let's start by understanding the problem deeply.

    What triggered this idea? Was there a specific moment
    where you thought "I need this"?

    Who experiences this problem? Just you, or others too?

    What happens today without this solution? What's the
    workaround, if any?

    How painful is this on a scale of 1-10? Is this a
    "nice to have" or a "blocking issue"?

User: [responds]

AI: [Reflects back, asks follow-up, ~300 words exploring deeper]
```

**Section 2: Context & Constraints (~300 words)**
```
AI: Now let's understand what we're working with.

    What does the current system look like? Walk me through
    the relevant parts.

    Are there technical constraints I should know about?
    (Language, framework, hosting, dependencies)

    What about non-technical constraints? Time, budget,
    who else needs to approve?

    Have you tried solving this before? What happened?

User: [responds]

AI: [Synthesizes, probes edge cases, ~300 words]
```

**Section 3: Success Definition (~300 words)**
```
AI: Let's get concrete about what success looks like.

    If this is done perfectly, what can you do that you
    couldn't do before?

    How will you know it's working? What will you see/feel?

    What's the minimum viable version? If we could only
    ship one thing, what would it be?

    What would make this a failure even if it "works"?

User: [responds]

AI: [Clarifies, proposes criteria, ~300 words]
```

**Section 4: Scope & Boundaries (~300 words)**
```
AI: Finally, let's draw the boundaries.

    What are you explicitly NOT trying to solve right now?

    What's tempting to include but should wait for later?

    Are there adjacent problems we should ignore for now?

    What would "gold plating" look like here - features
    that sound nice but aren't essential?

User: [responds]

AI: [Summarizes scope, confirms boundaries, ~300 words]
```

**Then: Synthesis**
```
AI: Based on our discovery, here's what I understand:

    [Consolidated discovery document]

    Does this capture it accurately?
```

### Discovery Output

```markdown
# Discovery: User Authentication

## Problem
Users can access all routes. Need to protect admin pages.

## Context
- No existing auth
- Using Express + PostgreSQL
- 2 user types: regular, admin

## Constraints
- Self-hosted (no Auth0/Firebase)
- Must support email/password
- Session-based preferred over JWT

## Success Criteria
- [ ] Users can register/login/logout
- [ ] Admin routes protected
- [ ] Sessions persist across browser restart

## Out of Scope
- Social login
- 2FA
- Password reset (phase 2)
```

~20 lines. Enough to guide planning, not enough to overwhelm.

### Why Required Entry Point?

Without discovery:
- AI assumes the problem
- Builds the wrong thing confidently
- User frustrated after wasted effort

With discovery:
- Shared understanding before any code
- Assumptions surfaced early
- Clear criteria to check against later

---

## Learnings from Superpowers

### Key Design Decisions

1. **One question at a time** - Never overwhelm with multiple questions
2. **Prefer multiple choice** - When possible, but open-ended is fine
3. **Lead with recommendation** - Propose 2-3 approaches, explain why you prefer one
4. **200-300 word chunks** - Present design in digestible sections
5. **Validate each section** - "Does this look right so far?" before moving on
6. **Conversational, not automated** - Discovery is dialogue, not codebase scanning

### Superpowers Flow

```
brainstorming (discovery)
    ↓
writing-plans (detailed tasks)
    ↓
using-git-worktrees (isolation)
    ↓
subagent-driven-development (execution + reviews)
```

### Artifacts Produced

1. **Design doc** → `docs/plans/YYYY-MM-DD-<topic>-design.md`
2. **Implementation plan** → `docs/plans/YYYY-MM-DD-<feature>.md`
3. **Git worktree** → Isolated branch with clean baseline

### Implementation (How Superpowers Does It)

- **Skills** are just markdown files with YAML frontmatter
- **SessionStart hook** triggers brainstorming before creative work
- **Subagent prompts** for implementer, spec-reviewer, code-quality-reviewer
- **Two-stage reviews**: Spec compliance first, then code quality

### What to Adopt

- One question at a time
- 200-300 word chunks with validation
- Lead with recommendation + alternatives
- Design doc as artifact
- Mandatory trigger before creative work
- Bite-sized tasks (2-5 min each, not 10)
- Complete code in plan (not "add validation")
- Two-stage review: spec compliance → code quality
- Spec reviewer doesn't trust implementer report (reads actual code)
- Implementer can ask questions before AND during work

### Superpowers Prompts - Key Details

**Implementer prompt includes:**
- Full task text (don't make subagent read plan file)
- Scene-setting context
- "Ask questions NOW before starting"
- Self-review checklist before reporting back
- "If unclear, ask - don't guess"

**Spec reviewer prompt includes:**
- "Do NOT trust the report"
- "Implementer finished suspiciously quickly"
- "Verify by reading code, not by trusting report"
- Check: missing requirements, extra work, misunderstandings

**Code quality reviewer:**
- Only runs AFTER spec compliance passes
- Uses standard code review template

### What to Simplify

- Skip git worktrees (user can decide)
- Combine into fewer skills
- Less ceremony around phase transitions
- Default to focused sessions (not 2-hour autonomous)

---

## Revised Plugin Design

### Single Entry Point: /discovery

Triggers automatically OR manually for any creative/implementation work.

**Phase 1: Problem Understanding**
- One question at a time
- Multiple choice when possible
- ~300 words, then validate

**Phase 2: Context Exploration**
- Check existing code/docs (quick scan)
- Surface constraints
- ~300 words, then validate

**Phase 3: Approach Selection**
- Propose 2-3 approaches
- Lead with recommendation + why
- ~300 words, then validate

**Phase 4: Success Criteria**
- Define done
- Define out of scope
- ~300 words, then validate

**Output: Design Doc**
```
docs/plans/YYYY-MM-DD-<topic>-design.md
```

### Then: /plan

Takes design doc, produces implementation plan:
- Bite-sized tasks (2-5 min each)
- Exact file paths
- Test → Implement → Verify cycle
- Each task = potential commit

### Then: Implement

Work through plan, commit often. No special tooling needed.

---

## Core Requirements

### 1. Scale Agnostic

Works for both:
- **Small**: "I want to implement an OAuth service"
- **Large**: "I want to create a Rimworld-like game"

Same process, different scope discovery.

### 2. Smallest Vertical Slice First

**NOT** trying to build complete MVP upfront.

Instead:
- What's the smallest thing we can build that proves the concept?
- What's the thinnest slice through all the layers?
- What can we demo/validate earliest?

**Example - Rimworld-like game:**
```
NOT: "Let's build the full colonist AI, economy, combat, building..."

YES: "Let's get one colonist walking to a clicked location on a
     tile map. That proves: rendering, input, pathfinding, entity
     management. Then we iterate."
```

**Example - OAuth service:**
```
NOT: "Let's build full OAuth with refresh tokens, scopes,
     revocation, admin panel..."

YES: "Let's get a single endpoint that issues a token and one
     protected endpoint that validates it. That proves the core
     flow. Then we iterate."
```

### 3. Two Audience Modes

**Experienced engineer:**
- "I want to build X" - knows what they want
- Discovery focuses on constraints, approach selection
- Less hand-holding on fundamentals

**Beginner:**
- "I have this idea but don't know all the components"
- Discovery helps decompose the problem
- Explains what pieces are needed and why
- More educational in approach

Detection: Ask early "How familiar are you with this domain?"
Or infer from how they describe the problem.

### 4. Iterative by Design

Each cycle:
```
Discovery → Plan → Implement → Verify → [Next slice]
```

After each slice:
- What did we learn?
- What's the next smallest valuable increment?
- Did our understanding change?

The plan isn't fixed upfront - it evolves as we build.

### 5. Manual Verification Checkpoints

**Critical:** Not everything can be tested with automated tests.

When implementation reaches a point needing human verification:

```
AI: ═══════════════════════════════════════════════════════
    🔍 VERIFICATION CHECKPOINT
    ═══════════════════════════════════════════════════════

    The colonist pathfinding is implemented. Before continuing,
    please verify manually:

    1. Run the game: `npm run dev`
    2. Click anywhere on the map
    3. Verify: Colonist walks to clicked location
    4. Verify: Colonist avoids obstacles (place some first)
    5. Verify: Path updates if you click elsewhere mid-walk

    Expected behavior:
    - Smooth movement (not teleporting)
    - Reasonable path (not walking through walls)
    - Responsive to new destinations

    What to report back:
    - Did it work as expected?
    - Any weird behavior?
    - Performance concerns?

    ═══════════════════════════════════════════════════════
    Reply with your observations when ready to continue.
    ═══════════════════════════════════════════════════════
```

### When to Trigger Verification

- UI/UX changes (needs human eyes)
- Game feel (needs human play)
- Performance (needs human perception)
- Integration points (needs real environment)
- Anything subjective ("does this feel right?")

### Verification vs Testing

| Automated Tests | Manual Verification |
|-----------------|---------------------|
| Logic correctness | UX/feel |
| Edge cases | Visual appearance |
| Regression prevention | Performance perception |
| API contracts | Integration in real env |
| Fast, repeatable | Subjective, exploratory |

Both are needed. The plugin should know when to say "run the tests" vs "try it yourself and tell me what you see."

---

## Implementation Architecture

### Session Philosophy

**Problem with long sessions:**
- 2-hour sessions = context bloat = degraded quality
- Constant need to dump knowledge or /new
- Hard to track where things went wrong
- User can't step away easily

**Solution: 10-minute focused sessions (default)**

Each implementation task:
- Scoped to ~10 minutes of work
- Fresh agent with clean context
- Complete one thing, verify, done
- Natural stopping points

### Orchestrator / Implementer Pattern

```
┌─────────────────────────────────────────────────────┐
│                   ORCHESTRATOR                       │
│  - Owns the plan                                    │
│  - Tracks progress                                  │
│  - Spawns implementers                              │
│  - Stays lean (doesn't do implementation work)      │
└─────────────────────────────────────────────────────┘
        │              │              │
        ▼              ▼              ▼
   ┌─────────┐   ┌─────────┐   ┌─────────┐
   │ Task 1  │   │ Task 2  │   │ Task 3  │
   │ (fresh) │   │ (fresh) │   │ (wait)  │
   └─────────┘   └─────────┘   └─────────┘
     parallel      parallel     depends on 1+2
```

**Orchestrator responsibilities:**
- Parse the implementation plan
- Determine task dependencies
- Launch implementer subagents
- Collect results
- Handle failures/retries
- Trigger verification checkpoints

**Implementer responsibilities:**
- Receive precise instructions (not "read the plan")
- Do the work
- Run tests
- Report back (success/failure + summary)
- Fix bugs if verifier catches issues
- Die (context released)

**Verifier responsibilities:**
- Review what implementer built
- Check against success criteria
- Catch bugs/issues implementer missed
- Report: pass / fail with specific issues
- If fail → implementer fixes before moving on

### Task Execution Loop (Two-Stage Review)

```
┌─────────────────────────────────────────────────────────────┐
│                      ORCHESTRATOR                            │
│  - Reads plan ONCE at start, extracts ALL tasks             │
│  - Creates TodoWrite with all tasks                          │
│  - Provides full task text to each subagent                  │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
              ┌────────────────────────┐
              │      IMPLEMENTER       │
              │  - Can ask questions   │
              │  - Implements + tests  │
              │  - Self-reviews        │
              │  - Commits             │
              └────────────────────────┘
                           │
                           ▼
              ┌────────────────────────┐
              │    SPEC REVIEWER       │
              │  - Reads ACTUAL code   │
              │  - Doesn't trust report│
              │  - Missing? Extra?     │
              └────────────────────────┘
                           │
                    ┌──────┴──────┐
                    ▼             ▼
                  PASS          FAIL
                    │             │
                    │             ▼
                    │      IMPLEMENTER fixes
                    │             │
                    │             ▼
                    │      SPEC REVIEWER re-checks
                    │             │
                    ▼             │
              ┌────────────────────────┐
              │  CODE QUALITY REVIEWER │
              │  (only after spec ✅)  │
              └────────────────────────┘
                           │
                    ┌──────┴──────┐
                    ▼             ▼
                  PASS          FAIL
                    │             │
                    │      IMPLEMENTER fixes
                    │             │
                    │      QUALITY re-checks
                    ▼             │
              ┌────────────────────────┐
              │     NEXT TASK or       │
              │  MANUAL VERIFICATION   │
              └────────────────────────┘
```

**Key insight:** Orchestrator provides FULL TASK TEXT to implementer. Implementer never reads the plan file - no overhead of "understanding the overall plan."

**Two-stage review:**
1. **Spec compliance** - Did you build what was asked? (nothing more, nothing less)
2. **Code quality** - Is it well-built? (only after spec passes)

**Spec reviewer is skeptical:**
- "Implementer finished suspiciously quickly"
- "Do NOT trust the report"
- Must verify by reading actual code

### Parallel Execution

If tasks don't depend on each other → run them in parallel

```
Plan:
  1. Create User model          ─┐
  2. Create auth middleware      ├─ parallel (independent)
  3. Add login endpoint         ─┘
  4. Add protected route        ← sequential (depends on 1-3)
```

Orchestrator figures this out from plan or explicit dependencies.

### Implementation Modes

**Default: Focused sessions (10 min)**
```
Orchestrator: "Task 1: Create User model"
              [spawns implementer]
              [implementer completes]
              "Task 1 complete. Tests passing.
               Ready for Task 2, or want to verify first?"
```

User stays in the loop. Natural pause points.

**Optional: Autonomous mode**
```
User: "Run it all, I'll be back in an hour"
Orchestrator: [spawns all possible parallel tasks]
              [waits, collects results]
              [spawns next wave]
              [continues until done or blocked]
              "Completed 7/10 tasks. Blocked on Task 8,
               needs your input on [question].
               Here's what was built: [summary]"
```

For users who want unattended coding.

### Why Fresh Agent Per Task

| Long session | Fresh agent per task |
|--------------|---------------------|
| Context bloats over time | Clean slate each time |
| Quality degrades | Consistent quality |
| Need /new periodically | No intervention needed |
| Hard to isolate failures | Failures are contained |
| Can't parallelize | Natural parallelization |

The orchestrator's context stays small (just plan + status).
Each implementer gets just what it needs for one task.

### Context Handoff

What does an implementer receive?

```markdown
## Task: Create User model

### Context
- Project: Express + PostgreSQL app
- Related files: src/models/ (empty), src/db/connection.ts
- Design decisions: Using Prisma ORM (from design doc)

### Specific task
Create User model with fields:
- id (uuid, primary key)
- email (unique)
- passwordHash
- createdAt, updatedAt

### Success criteria
- [ ] Model file created
- [ ] Migration generated
- [ ] Migration runs successfully
- [ ] Basic test passes

### What NOT to do
- Don't implement auth logic (separate task)
- Don't add fields beyond spec
- Don't modify other models
```

Focused. Everything needed. Nothing extra.

### Asking About Mode

During planning:
```
AI: The plan has 12 tasks. How would you like to proceed?

    A) Focused sessions (default)
       - I'll do one task at a time
       - You verify between tasks
       - ~10 min per task
       - Best for: learning, reviewing, complex work

    B) Autonomous mode
       - I'll run through all tasks
       - Parallel where possible
       - You verify at the end
       - Best for: routine work, time constraints

    C) Hybrid
       - Autonomous for straightforward tasks
       - Pause for complex/risky ones
       - You mark which tasks need review
```

---

## Why This Works (Design Philosophy)

Credit: obra/superpowers - Jesse Vincent

### The Skeptical Reviewer

"Implementer finished suspiciously quickly. Do NOT trust the report."

AI will confidently say "done!" when it's not. The spec reviewer's job is to NOT believe it. Read the actual code. Verify independently.

### Two Different Questions

1. **Spec compliance:** Did you build the right thing?
2. **Code quality:** Did you build it right?

These are SEPARATE concerns. Quality review before spec review is pointless - who cares if the code is clean if it's the wrong code?

### Don't Make Subagent Read the Plan

Every file read:
- Burns context window
- Risks misinterpretation
- Adds latency

Orchestrator reads ONCE, extracts, curates. Subagent receives exactly what it needs - no more, no less. Subagent is a focused worker, not a researcher.

### Fresh Context Per Task

Long sessions degrade. Context accumulates. Quality drops.

Fresh agent per task:
- Clean slate every time
- Consistent quality
- Natural parallelization
- Isolated failures

The orchestrator stays lean (just plan + progress). Workers are disposable.

### One Question at a Time

Don't overwhelm humans OR agents. Single-threaded dialogue. Explore one thing fully before moving on.

### Complete Code in Plans

Not "add validation logic" - actual code. The implementer shouldn't have to design; they execute. All design decisions made in planning.

---

## Notes

---
---

# FINAL DESIGN: Agile Workflow Plugin

## Philosophy

1. **Smallest vertical slice first** - Not MVP, just prove the concept works
2. **Fresh agent per task** - No context bloat, consistent quality
3. **Two-stage review** - Spec compliance first, then code quality
4. **Don't trust the implementer** - Verify by reading actual code
5. **One question at a time** - Socratic discovery, 200-300 word chunks
6. **Complete code in plans** - Implementer executes, doesn't design
7. **Organic stopping points** - ~10 min tasks, stop when there's something to verify

## Workflow

```
/discovery → Design Doc → /plan → Implementation Plan → /implement → Working Code
```

### Phase 1: Discovery

**Trigger:** Required before any creative/implementation work

**Process:**
1. Understand the problem (one question at a time)
2. Explore context & constraints
3. Propose 2-3 approaches (lead with recommendation)
4. Define success criteria & scope
5. Present design in 200-300 word chunks, validate each

**Output:** `docs/plans/YYYY-MM-DD-<topic>-design.md`

**Adapts to user:**
- Experienced: Focus on constraints, approach selection
- Beginner: Explain components, more educational

**Always asks:** "What's the smallest thing we can build that proves this works?"

### Phase 2: Plan

**Input:** Approved design doc

**Process:**
1. Break into focused tasks (~10 min each)
2. Each task = one action (write test → run → implement → run → commit)
3. Include complete code, exact file paths, exact commands
4. Identify dependencies between tasks
5. Mark which tasks need manual verification

**Output:** `docs/plans/YYYY-MM-DD-<topic>-plan.md`

**Plan structure:**
```markdown
# [Feature] Implementation Plan

**Goal:** One sentence
**Architecture:** 2-3 sentences
**Vertical Slice:** What this proves

---

### Task 1: [Name]

**Files:** Create/Modify/Test with exact paths
**Dependencies:** None | Task N
**Verification:** Automated | Manual (with instructions)

**Step 1:** Write failing test
[complete code]

**Step 2:** Run test, verify fails
[exact command + expected output]

**Step 3:** Implement
[complete code]

**Step 4:** Run test, verify passes
[exact command]

**Step 5:** Commit
[exact command]
```

### Phase 3: Implement

**Modes offered:**
- **A) Focused (default)** - One task at a time, verify between
- **B) Autonomous** - Run all, come back later
- **C) Hybrid** - Autonomous for easy, pause for complex

**Architecture:**

```
ORCHESTRATOR (lean - just plan + progress)
    │
    ├── Reads plan ONCE, extracts all tasks
    ├── Creates progress tracker
    ├── For each task:
    │       │
    │       ▼
    │   IMPLEMENTER (fresh agent)
    │       - Receives full task text + context
    │       - Can ask questions before/during
    │       - Implements, tests, self-reviews, commits
    │       │
    │       ▼
    │   SPEC REVIEWER (fresh agent)
    │       - "Do NOT trust the report"
    │       - Reads actual code
    │       - Missing requirements? Extra work?
    │       - ✅ Pass or ❌ Fail with specifics
    │       │
    │       ├── FAIL → Implementer fixes → Re-review
    │       │
    │       ▼
    │   CODE QUALITY REVIEWER (only after spec ✅)
    │       - Is it well-built?
    │       - ✅ Pass or ❌ Fail with specifics
    │       │
    │       ├── FAIL → Implementer fixes → Re-review
    │       │
    │       ▼
    │   MANUAL VERIFICATION (if task requires)
    │       - Clear instructions for human
    │       - What to test, expected behavior
    │       - Wait for human feedback
    │       │
    │       ▼
    │   Mark task complete, next task
    │
    ▼
SLICE COMPLETE → Next iteration or done
```

**Parallel execution:** If tasks have no dependencies, run in parallel

## Artifacts

| Phase | Output | Location |
|-------|--------|----------|
| Discovery | Design doc | `docs/plans/YYYY-MM-DD-<topic>-design.md` |
| Plan | Implementation plan | `docs/plans/YYYY-MM-DD-<topic>-plan.md` |
| Implement | Code + commits | Working directory |

## Manual Verification Checkpoints

When automated tests aren't enough:

```
═══════════════════════════════════════════════════════
🔍 VERIFICATION CHECKPOINT
═══════════════════════════════════════════════════════

Task 3 complete. Please verify manually:

1. Run: `npm run dev`
2. Do: [specific action]
3. Verify: [expected behavior]
4. Check: [what could go wrong]

Reply with observations when ready to continue.
═══════════════════════════════════════════════════════
```

**Triggers:** UI changes, game feel, performance, integrations, anything subjective

## Plugin Structure

```
plugins/agile-workflow/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   ├── discovery/
│   │   └── SKILL.md
│   └── plan/
│       └── SKILL.md
├── prompts/
│   ├── implementer.md
│   ├── spec-reviewer.md
│   └── quality-reviewer.md
└── docs/
    └── README.md
```

## Skill Definitions

### /discovery

```yaml
---
name: discovery
description: "Required before any creative work. Explores idea through Socratic dialogue, produces design doc."
---
```

**Behavior:**
- One question at a time
- Multiple choice when possible
- 200-300 word chunks, validate each
- Lead with recommendation + alternatives
- Output design doc
- Ask about smallest vertical slice

### /plan

```yaml
---
name: plan
description: "Takes design doc, produces bite-sized implementation plan with complete code."
---
```

**Behavior:**
- ~10 min tasks (no hour-long sessions)
- Complete code, exact paths
- TDD structure (test → fail → implement → pass → commit)
- Mark manual verification points (organic stopping)
- Identify dependencies
- Offer implementation mode choice

### /implement

```yaml
---
name: implement
description: "Executes plan with fresh agent per task, two-stage review."
---
```

**Behavior:**
- Orchestrator reads plan once
- Fresh implementer per task
- Spec review → Quality review
- Fix loops until pass
- Manual verification when needed
- Parallel when possible

## Differences from Superpowers

| Superpowers | This Plugin |
|-------------|-------------|
| Git worktrees required | Optional (user decides) |
| Multiple specialized skills | Fewer, combined skills |
| 2-hour autonomous default | ~10 min focused, organic stops |
| Heavy ceremony | Lean transitions |
| Same architecture | Same architecture |

**What we keep:**
- Socratic discovery
- Two-stage review
- Fresh agent per task
- Complete code in plans
- Skeptical reviewer
- One question at a time

**What we simplify:**
- Fewer moving parts
- Less mandatory structure
- Shorter default sessions
- User chooses their style