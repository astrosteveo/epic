# Example: Deployment Workflow Command

This example demonstrates a well-structured workflow command with multiple phases.

## The Command

**File**: `commands/deploy.md`

```markdown
---
description: Deploy to staging or production
argument-hint: [environment] [version]
allowed-tools:
  - Read
  - Bash(git:*, npm:run build, npm:test, docker:build, docker:push, kubectl:*)
---

Deploy version $2 to $1 environment.

## Pre-flight Validation

Before proceeding, verify:

### 1. Environment Check
Confirm $1 is valid (staging or production).
If production, require explicit user confirmation before proceeding.

### 2. Git State
```bash
git status --short
git branch --show-current
```
- Must be on `main` branch for production
- Working directory must be clean
- Verify $2 tag exists: `git tag -l "$2"`

### 3. Test Suite
```bash
npm test
```
All tests must pass before deployment.

## Build Phase

### 1. Build Application
```bash
npm run build
```

### 2. Build Docker Image
```bash
docker build -t myapp:$2 .
```

### 3. Push to Registry
```bash
docker push registry.example.com/myapp:$2
```

## Deployment Phase

### For Staging
```bash
kubectl --context=staging set image deployment/myapp myapp=registry.example.com/myapp:$2
kubectl --context=staging rollout status deployment/myapp
```

### For Production
```bash
kubectl --context=production set image deployment/myapp myapp=registry.example.com/myapp:$2
kubectl --context=production rollout status deployment/myapp
```

## Verification

After deployment:
1. Check pod status: `kubectl get pods -l app=myapp`
2. Verify health endpoint responds
3. Check application logs for errors

## Rollback Procedure

If issues are detected:
```bash
kubectl rollout undo deployment/myapp
```

Provide this command to the user if deployment verification fails.

## Output

Report:
- ✓/✗ Pre-flight checks
- ✓/✗ Build status
- ✓/✗ Deployment status
- ✓/✗ Verification results
- Rollback command (if applicable)
```

## Why This Command Is Well-Structured

1. **Specific Tool Permissions**: Only the exact tools needed for deployment
2. **Safety Gates**: Pre-flight checks prevent bad deployments
3. **Production Protection**: Requires explicit confirmation for production
4. **Clear Phases**: Logical progression through build → deploy → verify
5. **Rollback Plan**: Provides recovery option if things go wrong
6. **Progress Reporting**: Clear status indicators throughout
