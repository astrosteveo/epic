# Example: Security Analysis Command

This example demonstrates a well-structured analysis command.

## The Command

**File**: `commands/security-scan.md`

```markdown
---
description: Scan code for security vulnerabilities
argument-hint: [path]
allowed-tools:
  - Read
  - Glob
  - Grep
---

Perform a security analysis on: $1

If no path is provided, scan the entire project.

## Vulnerability Categories

Scan for these vulnerability types:

### 1. Injection Vulnerabilities
- SQL injection patterns (string concatenation in queries)
- Command injection (unsanitized input to exec/spawn)
- XSS (unescaped output in templates)

### 2. Authentication Issues
- Hardcoded credentials (API keys, passwords, tokens)
- Weak password validation
- Missing authentication checks

### 3. Data Exposure
- Sensitive data in logs
- Unencrypted storage of secrets
- Overly permissive CORS

### 4. Dependency Risks
- Known vulnerable packages (check package.json/requirements.txt)
- Outdated dependencies with security patches

## Analysis Process

1. Identify file types in the target path
2. Apply language-specific patterns:
   - JavaScript/TypeScript: Check for `eval()`, `innerHTML`, SQL string building
   - Python: Check for `exec()`, `pickle.loads()`, SQL string formatting
   - Go: Check for `exec.Command()` with user input

3. Search for credential patterns:
   - `password\s*=`
   - `api[_-]?key\s*=`
   - `secret\s*=`
   - `token\s*=`

4. Check configuration files for security misconfigurations

## Output Format

Present findings in a structured report:

### Summary
| Severity | Count |
|----------|-------|
| Critical | X |
| High | X |
| Medium | X |
| Low | X |

### Findings

For each finding:
| File | Line | Vulnerability | Severity | Description |
|------|------|---------------|----------|-------------|

### Recommendations

Provide specific remediation guidance for each finding category.

## Limitations

Note: This is a static analysis scan. It cannot detect:
- Runtime vulnerabilities
- Business logic flaws
- Infrastructure misconfigurations

Recommend additional security testing for production systems.
```

## Why This Command Is Well-Structured

1. **Clear Purpose**: Description explains what it does in under 60 characters
2. **Minimal Permissions**: Only read-access tools needed for analysis
3. **Flexible Input**: Handles both specific path and full-project scans
4. **Structured Process**: Clear steps for Claude to follow
5. **Defined Output**: Specific format for presenting results
6. **Honest Limitations**: Acknowledges what it can't do
