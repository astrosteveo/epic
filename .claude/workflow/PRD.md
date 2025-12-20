# PRD: AGILE Workflow Plugin for Claude Code

## Vision
A Claude Code plugin that enforces AGILE-style project management workflows optimized for LLM context limitations. The plugin ensures work is broken into small, focused chunks with clear gates between exploration, planning, and implementation phases.

## Requirements
- [REQ-1] The plugin must enforce a PRD-first workflow - no exploration without requirements
- [REQ-2] The plugin must enforce planning before implementation - no coding without a plan
- [REQ-3] The plugin must maintain a JSON state file as the source of truth for project status
- [REQ-4] The plugin must provide agents for explore, plan, and implement phases
- [REQ-5] The plugin must track effort using Fibonacci story points
- [REQ-6] The plugin must generate human-readable markdown docs that mirror the JSON state

## Epics

### Epic: project-scaffold
- **Description**: This epic establishes the plugin project structure, configuration files, and base architecture
- **Requirement**: REQ-3, REQ-6
- **Status**: explore
- **Effort**: TBD

### Epic: agent-definitions
- **Description**: This epic defines and implements the explore, plan, and implement agents with their prompts and behaviors
- **Requirement**: REQ-4
- **Status**: pending
- **Effort**: TBD

### Epic: workflow-orchestration
- **Description**: This epic implements the gate enforcement and routing logic that ensures proper workflow progression
- **Requirement**: REQ-1, REQ-2
- **Status**: pending
- **Effort**: TBD

### Epic: state-management
- **Description**: This epic implements the state.json read/write operations and sync mechanisms
- **Requirement**: REQ-3, REQ-5
- **Status**: pending
- **Effort**: TBD

### Epic: commands-and-skills
- **Description**: This epic implements the user-facing commands and skills for interacting with the workflow
- **Requirement**: REQ-1, REQ-2, REQ-4
- **Status**: pending
- **Effort**: TBD
