---
name: epic-validate
description: Run comprehensive project validation including tests, linting, type checking, and build verification. Use after implementation to verify code quality. Triggers on /epic:validate or when user wants to run tests, check types, lint code, verify build, or validate changes before committing.
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Bash(npm:*, npx:*, cargo:*, go:*, python:*, pytest:*, ruff:*, mypy:*, make:*, tsc:*)
---

# Epic Validate

Validation phase of the Explore-Plan-Implement workflow. Run comprehensive checks to verify implementation quality.

## Arguments

| Argument | Description |
|----------|-------------|
| `--fix` | Auto-fix linting issues where possible |
| `--skip-tests` | Skip test suite (faster, less thorough) |

## Workflow

```
1. Locate active workflow: .claude/workflows/*/state.md
2. Detect project type from config files
3. Run validation suite (tests, lint, types, build)
4. Write results to validation.md
5. Update state.md
6. Report pass/fail with actionable details
```

## Project Type Detection

| Files Found | Project Type | Tools |
|-------------|--------------|-------|
| `package.json` | Node.js | npm test, eslint, tsc |
| `Cargo.toml` | Rust | cargo test, clippy, build |
| `go.mod` | Go | go test, golangci-lint, build |
| `pyproject.toml` | Python | pytest, ruff, mypy |
| `Makefile` | Make-based | make test, lint, build |

## Validation Order

### 1. Tests
```bash
npm test          # Node.js
cargo test        # Rust
go test ./...     # Go
pytest            # Python
```

Capture: total, passed, failed, skipped, failure details.

### 2. Linting
```bash
npm run lint              # Node.js
cargo clippy -D warnings  # Rust
golangci-lint run         # Go
ruff check .              # Python
```

With `--fix`: add `--fix` flag to auto-correct.

Capture: errors, warnings, auto-fixed count.

### 3. Type Checking
```bash
npx tsc --noEmit   # TypeScript
mypy .             # Python
cargo check        # Rust (implicit)
```

Capture: error count, file:line locations.

### 4. Build
```bash
npm run build          # Node.js
cargo build --release  # Rust
go build ./...         # Go
```

Capture: success/failure, duration, output location.

## Results Summary

| Check | Status | Details |
|-------|--------|---------|
| Tests | ✓/✗ | X passed, Y failed |
| Lint | ✓/✗ | X errors, Y warnings |
| Types | ✓/✗ | X errors |
| Build | ✓/✗ | Success/Failure |

**Overall**: PASS (all checks passed) or FAIL (one+ failed)

## Output Format

### PASS
```
✓ Validation Complete - PASS

| Check | Result |
|-------|--------|
| Tests | ✓ 42 passed |
| Lint | ✓ Clean |
| Types | ✓ No errors |
| Build | ✓ Success |

Next: Run /epic:commit
```

### FAIL
```
⚠️ Validation Complete - FAIL

| Check | Result |
|-------|--------|
| Tests | ✗ 2 failed |
| Build | ✗ Failed |

### Failed Tests
1. `src/auth.test.ts` - "should validate token" - AssertionError

### Build Errors
- Missing module: '@/utils/helper'

Fix issues and run /epic:validate again.
```

## Context Efficiency

**DO:**
- Summarize to pass/fail counts
- Extract only error messages
- Note file:line for failures

**DON'T:**
- Dump entire test output
- Include passing test details
- Copy full stack traces or build logs

## References

- `references/validation-template.md` - Validation results template
