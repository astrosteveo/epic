---
description: Run comprehensive project validation
argument-hint: [--fix] [--skip-tests]
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Bash(npm:*, npx:*, cargo:*, go:*, python:*, pytest:*, ruff:*, mypy:*, make:*, tsc:*)
---

# Validate Phase

Execute the **Validate** phase of the Frequent Intentional Compaction workflow.

Run comprehensive project validation: tests, linting, type checking, and build verification.

## Arguments

| Argument | Description |
|----------|-------------|
| `--fix` | Auto-fix linting issues where possible |
| `--skip-tests` | Skip test suite (faster, less thorough) |

## Process

### 1. Locate Active Feature

Find the current workflow state:
```
.claude/workflows/*/state.md
```

Read `state.md` to get:
- Feature directory path for writing results
- Implementation status

**If Implementation not complete:**
```
⚠️ Implementation incomplete

Implementation progress: [X]/[Y] phases

Run `/implement --continue` to complete implementation first.
```

### 2. Detect Project Type

Examine project root for configuration files:

| Files Found | Project Type | Validation Tools |
|-------------|--------------|------------------|
| `package.json` | Node.js | npm test, eslint, tsc |
| `Cargo.toml` | Rust | cargo test, cargo clippy, cargo build |
| `go.mod` | Go | go test, golangci-lint, go build |
| `pyproject.toml` / `setup.py` | Python | pytest, ruff/flake8, mypy |
| `Makefile` | Make-based | make test, make lint, make build |

Read the config file to identify available scripts/commands.

### 3. Run Validation Suite

Execute validations in this order:

#### 3a. Tests

```bash
# Node.js
npm test

# Rust
cargo test

# Go
go test ./...

# Python
pytest
```

Capture:
- Total tests
- Passed / Failed / Skipped
- Failure details (summarized)

#### 3b. Linting

```bash
# Node.js
npm run lint
# or: npx eslint . --ext .ts,.tsx,.js,.jsx

# Rust
cargo clippy -- -D warnings

# Go
golangci-lint run

# Python
ruff check .
# or: flake8
```

If `--fix` argument provided:
```bash
npm run lint -- --fix
# or: ruff check . --fix
```

Capture:
- Error count
- Warning count
- Auto-fixed count (if --fix)

#### 3c. Type Checking

```bash
# Node.js/TypeScript
npx tsc --noEmit
# or: npm run typecheck

# Python
mypy .

# Rust (included in cargo check)
cargo check
```

Capture:
- Error count
- Error locations (file:line)

#### 3d. Build

```bash
# Node.js
npm run build

# Rust
cargo build --release

# Go
go build ./...
```

Capture:
- Success / Failure
- Build time
- Output location

### 4. Compile Results

Create validation summary:

| Check | Status | Details |
|-------|--------|---------|
| Tests | ✓/✗ | X passed, Y failed |
| Lint | ✓/✗ | X errors, Y warnings |
| Types | ✓/✗ | X errors |
| Build | ✓/✗ | Success/Failure |

**Overall Status:**
- **PASS** - All checks passed
- **FAIL** - One or more checks failed

### 5. Write Validation Report

Write results to: `[feature-dir]/validation/results.md`

Use template: `${CLAUDE_PLUGIN_ROOT}/templates/validation-results.md`

```markdown
# Validation Results

**Date**: [timestamp]
**Feature**: [description]
**Overall**: PASS / FAIL

## Summary

| Check | Status | Details |
|-------|--------|---------|
| Tests | ✓ PASS | 42 passed, 0 failed |
| Lint | ✓ PASS | 0 errors, 3 warnings |
| Types | ✓ PASS | No errors |
| Build | ✓ PASS | Completed in 12s |

## Test Results

**Command**: `npm test`
**Duration**: 8.2s

- Total: 42
- Passed: 42
- Failed: 0
- Skipped: 0

## Lint Results

**Command**: `npm run lint`

### Warnings (3)
- `src/utils/helper.ts:23` - Unused variable 'temp'
- ...

## Type Check Results

**Command**: `npx tsc --noEmit`

No errors.

## Build Results

**Command**: `npm run build`
**Duration**: 12.4s

Build successful. Output: `dist/`
```

### 6. Update State and Report

Update `state.md`: Set Validate status to "complete".

Present results to user:

#### If PASS:
```
✓ Validation Complete - PASS

| Check | Result |
|-------|--------|
| Tests | ✓ 42 passed |
| Lint | ✓ Clean |
| Types | ✓ No errors |
| Build | ✓ Success |

All checks passed. Ready to commit.

Next: Run `/commit` to create commit with artifacts.
```

#### If FAIL:
```
⚠️ Validation Complete - FAIL

| Check | Result |
|-------|--------|
| Tests | ✗ 2 failed |
| Lint | ✓ Clean |
| Types | ✓ No errors |
| Build | ✗ Failed |

### Failed Tests
1. `src/auth.test.ts` - "should validate token" - AssertionError
2. `src/api.test.ts` - "should handle errors" - Timeout

### Build Errors
- Missing module: '@/utils/newHelper'

Fix issues and run `/validate` again.
```

## Output Format

### All Passed
```
✓ Validation Phase Complete - PASS

Tests: 42 passed
Lint: Clean
Types: No errors
Build: Success (12s)

Artifact: validation/results.md

Next: Run `/commit`
```

### Failures Found
```
⚠️ Validation Phase Complete - FAIL

Failed Checks:
- Tests: 2 failures
- Build: Missing dependency

Details in: validation/results.md

Fix issues, then run `/validate` again.
```

## Context Efficiency

**DO:**
- Summarize test output to pass/fail counts
- Extract only error messages, not full stack traces
- Note file:line for failures

**DON'T:**
- Dump entire test output into context
- Include passing test details
- Copy full build logs

## Validation Rules

1. **Run all checks** - Don't skip unless explicitly requested
2. **Summarize output** - Extract key information only
3. **Specific failures** - Report exact file:line for errors
4. **Actionable guidance** - Suggest how to fix failures
5. **Update state** - Always update state.md with results
