# Plugin Builder Examples

Comprehensive examples of using the plugin-builder to scaffold Claude Code components.

## Creating Skills

### Example 1: Code Quality Reviewer

```
/plugin-builder:create-plugin create a skill for code quality review
```

**What happens:**
1. Parser extracts: type="skill", domain="code quality review", name="code-quality-review"
2. Loads skill templates
3. Generates domain-specific content about linting, code smells, best practices
4. Creates files in `.claude/skills/code-quality-review/`

**Generated files:**
```
.claude/skills/code-quality-review/
├── SKILL.md                 # Main skill with when-to-use, process, principles
└── examples/
    ├── simple.md            # Basic linting checklist
    ├── advanced.md          # Code smell detection with metrics
    └── production.md        # Full review workflow with security scanning
```

**Usage:**
Claude will automatically invoke this skill when discussing code quality topics.

---

### Example 2: Deployment Automation

```
/plugin-builder:create-plugin create a skill for deployment automation
```

**Generated content includes:**
- Introduction to deployment automation
- When to use (CI/CD, multi-environment, rollback scenarios)
- Process steps (validate, test, deploy, health-check, monitor, rollback)
- Three examples: simple script, multi-env with gates, blue-green deployment

**Files created:**
```
.claude/skills/deployment-automation/
├── SKILL.md
└── examples/
    ├── simple.md
    ├── advanced.md
    └── production.md
```

---

### Example 3: Test Runner

```
/plugin-builder:create-plugin create a skill for test execution
```

**Domain-specific content:**
- Test discovery and selection
- Execution strategies (all, changed, by pattern)
- Result reporting and coverage

**Progressive examples:**
- Simple: Run all tests with single command
- Advanced: Selective execution with patterns
- Production: Parallel execution with detailed reporting

---

## Creating Agents

### Example 4: Test Result Analyzer

```
/plugin-builder:create-plugin create an agent for test result analysis
```

**What happens:**
1. Parser extracts: type="agent", domain="test result analysis", name="test-result-analysis"
2. Loads agent template
3. Generates role, capabilities, process for test analysis
4. Creates `.claude/agents/test-result-analysis.md`

**Generated file:**
```
.claude/agents/test-result-analysis.md
```

**Agent specializes in:**
- Analyzing test failures
- Identifying patterns in failures
- Suggesting fixes
- Prioritizing failures by impact

**Usage:**
```
@test-result-analysis analyze the test failures from the last CI run
```

---

### Example 5: Performance Optimizer

```
/plugin-builder:create-plugin create an agent for performance optimization
```

**Generated capabilities:**
- Profile code for bottlenecks
- Analyze algorithms for complexity
- Suggest optimization strategies
- Benchmark improvements

**Usage:**
```
@performance-optimizer suggest optimizations for this function
```

---

## Creating Commands

### Example 6: Run All Tests

```
/plugin-builder:create-plugin create a command to run all project tests
```

**What happens:**
1. Parser extracts: type="command", domain="run all project tests", name="run-all-project-tests"
2. Loads command template
3. Generates instructions, usage examples, options
4. Creates `.claude/commands/run-all-project-tests.md`

**Generated file:**
```
.claude/commands/run-all-project-tests.md
```

**Command includes:**
- Description of what it does
- How to invoke it
- Options (if applicable)
- Usage examples with expected output

**Usage:**
```
/run-all-project-tests
```

---

### Example 7: Generate Documentation

```
/plugin-builder:create-plugin create a command to generate API documentation
```

**Command customized for:**
- Documentation generation workflow
- Options for format, output directory
- Examples showing different formats

**Usage:**
```
/generate-api-documentation
```

---

## Creating Hooks

### Example 8: Pre-commit Validation

```
/plugin-builder:create-plugin create a hook for pre-commit validation
```

**What happens:**
1. Parser extracts: type="hook", domain="pre-commit validation", name="pre-commit-validation"
2. Asks for hook type (if not clear)
3. Loads hook templates
4. Generates hook logic for validation
5. Creates/updates `.claude/hooks/hooks.json`
6. Creates `.claude/hooks/pre-commit-validation.sh`

**Generated files:**
```
.claude/hooks/
├── hooks.json                    # Updated with new hook entry
└── pre-commit-validation.sh      # Executable hook script
```

**Hook automatically:**
- Triggers before commits
- Runs validation checks
- Blocks commit if validation fails (exit code 2)
- Allows commit if validation passes (exit code 0)

**No manual invocation needed** - hooks trigger automatically on events.

---

### Example 9: Session Start Reminder

```
/plugin-builder:create-plugin create a hook for session start reminders
```

**Hook type:** SessionStart
**Purpose:** Display reminders when Claude Code starts

**Generated logic:**
- Reads project-specific reminders
- Displays them at session start
- Uses JSON output format for SessionStart hooks

---

## Handling Ambiguity

### Example 10: Ambiguous Input

```
/plugin-builder:create-plugin create something for testing
```

**Plugin response:**
```
What type of component would you like to create?

1. Skill - Auto-invoked capability (Recommended)
2. Agent - Specialized subagent
3. Command - Slash command
4. Hook - Event handler
```

User selects "Skill", then generation proceeds with domain="testing".

---

### Example 11: Confirm Interpretation

```
/plugin-builder:create-plugin make a code reviewer
```

**Plugin response:**
```
I'll create a skill for code review. Is this correct?

1. Yes, create skill (Recommended)
2. No, create agent instead
3. No, create command instead
```

Confirmation ensures the user gets exactly what they want.

---

## Handling Existing Components

### Example 12: Component Already Exists

```
/plugin-builder:create-plugin create a skill for code review
```

**If `.claude/skills/code-review/` already exists:**

```
Component 'code-review' already exists. Overwrite?

1. No, cancel (Recommended) - Keep existing component
2. Yes, overwrite - Replace with new generated component
```

User selects based on whether they want to keep or replace.

---

## Multiple Component Types

### Example 13: Complete Workflow

Create a complete code quality workflow:

**Step 1: Create the skill**
```
/plugin-builder:create-plugin create a skill for code quality review
```

**Step 2: Create an agent for deep analysis**
```
/plugin-builder:create-plugin create an agent for code quality deep dive
```

**Step 3: Create a command to trigger review**
```
/plugin-builder:create-plugin create a command to review current file
```

**Step 4: Create a hook to enforce standards**
```
/plugin-builder:create-plugin create a hook for pre-commit code quality check
```

**Result:** Complete workflow with auto-invocation (skill), deep analysis (agent), manual trigger (command), and enforcement (hook).

---

## Edge Cases

### Example 14: Long Domain Name

```
/plugin-builder:create-plugin create a skill for comprehensive end-to-end integration test automation with detailed reporting
```

**Generated name:** `comprehensive-end-to-end-integration-test-automation-with-detailed-reporting`

**Note:** Very long names are valid but may be unwieldy. Consider shortening:
```
/plugin-builder:create-plugin create a skill for E2E test automation
```

**Generated name:** `e2e-test-automation` (much cleaner!)

---

### Example 15: Special Characters in Domain

```
/plugin-builder:create-plugin create a skill for code review (fast & thorough)
```

**Generated name:** `code-review-fast-thorough` (special characters stripped)

**Message:** "Using sanitized name: 'code-review-fast-thorough'"

---

## Tips and Best Practices

### Naming Tips

**Good names:**
- "code quality review" → `code-quality-review`
- "deployment automation" → `deployment-automation`
- "test runner" → `test-runner`

**Too generic:**
- "helper" (helper for what?)
- "utility" (utility for what?)
- "tool" (tool for what?)

**Too verbose:**
- "comprehensive automated testing framework with parallel execution and detailed reporting"

**Better:**
- "test automation" or "parallel test runner"

### When to Use Each Type

**Use Skills when:**
- You want auto-invocation based on conversation context
- The capability should be always available
- It's domain-specific expertise

**Use Agents when:**
- You want explicit invocation with @ mention
- Task requires deep, focused analysis
- You want to isolate the work context

**Use Commands when:**
- You want explicit slash command invocation
- It's a specific action to trigger
- You want it in the slash command menu

**Use Hooks when:**
- You want automatic event-driven behavior
- You need validation or enforcement
- You want actions on session start, tool use, etc.

### Customizing Generated Components

All generated components are **starting points** - customize them!

1. **Edit SKILL.md** - Adjust when-to-use, process, principles for your project
2. **Modify examples/** - Tailor examples to your specific use cases
3. **Enhance agents** - Add project-specific knowledge and capabilities
4. **Customize commands** - Add options, parameters, error handling
5. **Refine hooks** - Adjust validation logic, matchers, exit conditions

The plugin gives you a solid foundation - make it yours!

---

## Testing Generated Components

### Test Skills
```
# Skill should auto-invoke when relevant topic discussed
Ask Claude about code quality → skill should activate
```

### Test Agents
```
# Agent should respond to @ mention
@test-result-analysis look at these failures
```

### Test Commands
```
# Command should appear in slash command menu
/run-tests
```

### Test Hooks
```
# Hooks trigger automatically
git commit → pre-commit hook should run
```

---

## Getting Help

If you encounter issues:

1. **Check the generated files** - Are all expected files created?
2. **Review SKILL.md** - Is the syntax correct (YAML frontmatter)?
3. **Test invocation** - Try using the component
4. **Regenerate** - Delete and recreate if needed
5. **Report issues** - File issue with the plugin-builder repository

The plugin-builder creates well-formed components that should work immediately!
