# Feature Implementation Workflow

## Overview

This workflow guides Claude through a structured approach to implementing user-requested features. The process adapts based on the clarity of the user's initial request, ranging from open-ended brainstorming to targeted implementation.

---

## Phase 0: Intent Assessment

When a user makes a request, Claude first assesses its clarity to determine the entry point.

**Clear Request Example:**
> "I want to add FastAPI as the backend REST framework that integrates with my React frontend."

This request has a specific technology stack and clear goal. Claude proceeds directly to **Exploration**, asking targeted questions about constraints, architecture, and integrations rather than technology selection.

**Vague Request Example:**
> "I want to make a web app."

This request lacks direction. Claude enters **Brainstorming** to establish clarity before proceeding.

---

## Phase 1: Brainstorming (Conditional)

*Only triggered when the initial request is vague or incomplete.*

Claude uses the Socratic method to progressively narrow scope:
- Starts with broad, open-ended questions
- Iteratively refines based on responses
- Continues until a clear direction emerges

There is no fixed number of questions—the phase concludes when sufficient clarity exists to proceed with Exploration.

---

## Phase 2: Exploration

The **Discoverer** subagent (using the **Explore** skill) analyzes the codebase to document:
- Existing architecture and patterns
- Documentation and conventions
- Constraints that may affect the implementation

**Critical:** During exploration, the Discoverer is a truth-documenter only. It does NOT recommend changes, critique code quality, or suggest improvements. It documents what exists with `file:line` references for full traceability.

Claude then enters an intensive Socratic dialogue, with questions tailored to the user's apparent experience level:

| User Signal | Question Focus |
|-------------|----------------|
| Specific tech choices (e.g., FastAPI + React) | Constraints, deployment, integrations, existing architecture |
| General direction only | Technology options, trade-offs, requirements gathering |

**Output:** `.workflow/NNN-feature-slug/codebase.md` — An objective map of the existing codebase with `file:line` references, documenting architecture, patterns, conventions, and relevant context for the feature being implemented.

---

## Phase 3: Research

The **Discoverer** subagent (using the **Research** skill) conducts targeted research on best practices for the chosen technologies, including:
- Authentication methods
- Data fetching strategies
- Deployment considerations
- Integration patterns between technologies

**Critical:** During research, the Discoverer operates with epistemic humility—it assumes it knows nothing. All information **must be validated** by fetching from authoritative sources (official documentation, specs, RFCs). No shortcuts. No reliance on potentially outdated training knowledge. The only exception is truly immutable standards that never change (e.g., Java's `com.sun.net.httpserver` package API).

**Output:** `.workflow/NNN-feature-slug/research.md` — Validated best practices, patterns, and external knowledge gathered to inform the design. All claims are sourced and verified.

---

## Phase 4: Design

Claude uses the **Design** skill to architect the solution, synthesizing findings from Exploration and Research.

If ambiguities remain, Claude continues clarifying questions until confident in the approach. Once the user approves:

**Outputs:**
- `.workflow/NNN-feature-slug/design.md` — Architecture and technical approach, using Mermaid diagrams where appropriate
- `.workflow/NNN-feature-slug/contracts.md` (optional) — API contracts, interfaces, data models, and endpoint specifications

The design should be robust, scalable, and follow best practices for all technologies involved.

---

## Phase 5: Planning

Claude uses the **Plan** skill to decompose the approved design into actionable implementation tasks.

**Output:** `.workflow/NNN-feature-slug/plan.md` — A detailed implementation blueprint that serves as the execution guide.

---

## Phase 6: Implementation

### 6.1 Execution Mode Selection

Claude presents the user with implementation options:

| Mode | Description |
|------|-------------|
| **Autonomous** | Subagents execute the entire plan sequentially, with minimal user intervention |
| **Batched** | Tasks executed in batches of 2–3, with user review between batches |

Both modes use the Orchestrator to deploy subagents for execution.

### 6.2 Subagent Architecture

Three subagents handle the entire workflow. Skills provide the specialized logic; subagents provide execution context.

| Subagent | Role | Skills Used |
|----------|------|-------------|
| **Orchestrator** | Coordinates workflow, plans tasks, performs all review functions, manages issues | Plan, Review (test/code/plan modes) |
| **Discoverer** | All information gathering (codebase + external) | Explore, Research, WebFetch |
| **Coder** | All implementation work | Implement, TDD patterns |

The **Orchestrator** manages execution by:
1. Providing subagents with structured templates containing:
   - Specific files to create or modify
   - Expected outputs
   - Constraints and guidelines
   - Relevant context from design and plan

   *This eliminates wasteful codebase exploration—that context was gathered during Phase 2.*

2. Performing all verification:
   - **Test review:** Validates tests are real validations, not stubs or mocks
   - **Code review:** Ensures quality, best practices, and design alignment
   - **Plan validation:** Confirms each task follows the implementation plan

#### Discoverer Principles

The Discoverer operates in two modes with distinct principles:

**Explore Mode (truth-documenting):**
- **Does NOT** recommend changes or improvements
- **Does NOT** critique or evaluate code quality
- **Documents only** what exists, using `file:line` references for traceability

**Research Mode (epistemic humility):**
- Assumes it knows nothing—all knowledge must be validated
- **Must fetch/verify** all information from authoritative sources (documentation, specs, RFCs)
- Takes no shortcuts; does not rely on potentially outdated training knowledge
- **Exception:** Truly immutable standards (e.g., Java's `com.sun.net.httpserver` package API) may be referenced without re-fetching
- Documents only validated truths—no speculation, no assumptions

### 6.3 Quality Gates

**Per-Task Cycle:**
1. Coder writes code + tests
2. Orchestrator reviews tests (validates authenticity, no stubs/mocks)
3. Orchestrator reviews code (quality, best practices, design alignment)
4. Orchestrator validates plan adherence
5. Issues are fixed before proceeding

**Requirement:** All tests must pass based on real integrations and use cases.

### 6.4 Issue Tracking

The Orchestrator maintains `.workflow/NNN-feature-slug/issues.md` to track any bugs or issues discovered during implementation.

---

## Phase 7: Review & Completion

Once all tasks are complete, Claude presents to the user:
- Final implementation summary
- Any deviations from the original plan
- Outstanding issues (if any)

**User Options for Incomplete/Deviated Tasks:**
- Complete now
- Defer to backlog
- Drop entirely

**Project Backlog:** `.workflow/backlog.md` (root level, spans entire project)
