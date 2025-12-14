# Workflow Example: Adding Authentication to an API

This example shows the explore-plan-implement workflow applied to a real task.

## The Task

Add JWT authentication to an existing Express API.

## Phase 1: Explore

**Command**: `/explore add JWT authentication to the Express API`

### Codebase Exploration Output

```markdown
# Codebase Exploration: Add JWT Authentication

## Relevant Files

| File | Lines | Purpose |
|------|-------|---------|
| `src/app.ts` | 1-45 | Express app setup, middleware chain |
| `src/routes/index.ts` | 1-30 | Route registration |
| `src/routes/users.ts` | 15-45 | User routes (needs protection) |
| `src/middleware/` | - | Existing middleware directory |
| `src/config/index.ts` | 1-20 | Config loading pattern |

## Code Flow

```
Request → app.ts middleware → routes/index.ts → specific route handler
```

## Existing Patterns

### Middleware Pattern
- Location: `src/middleware/logging.ts:5-20`
- Pattern: Export function that returns RequestHandler
- Uses: next() for pass-through, res.status() for errors

### Config Pattern
- Location: `src/config/index.ts:1-20`
- Pattern: Load from env with defaults
- Uses: dotenv, exports config object

## Dependencies

| Dependency | Version | Usage |
|------------|---------|-------|
| express | 4.18.2 | Web framework |
| dotenv | 16.0.0 | Environment config |
```

### External Research Output

```markdown
# External Research: JWT Authentication

## Best Practices

### Token Storage
- **Source**: OWASP JWT Cheatsheet
- **Recommendation**: Use httpOnly cookies for web, Authorization header for API
- **Rationale**: Prevents XSS token theft

### Token Expiration
- **Source**: Auth0 Documentation
- **Recommendation**: Short-lived access tokens (15min), longer refresh tokens
- **Rationale**: Limits exposure window

## Library Recommendation

| Library | Version | Notes |
|---------|---------|-------|
| jsonwebtoken | 9.0.0 | Standard JWT implementation |
| bcryptjs | 2.4.3 | Password hashing |

## Code Example

```typescript
// Source: jsonwebtoken docs
import jwt from 'jsonwebtoken';

const token = jwt.sign({ userId: user.id }, process.env.JWT_SECRET, {
  expiresIn: '15m'
});
```
```

## Phase 2: Plan

**Command**: `/plan`

### Implementation Plan Output

```markdown
# Implementation Plan: Add JWT Authentication

## Approach Summary
Add JWT middleware following existing middleware pattern. Use jsonwebtoken library.
Short-lived tokens with httpOnly cookie storage.

## Phase 1: Dependencies & Config

### Changes
| File | Action | Description |
|------|--------|-------------|
| `package.json` | Modify | Add jsonwebtoken, bcryptjs |
| `src/config/index.ts` | Modify | Add JWT_SECRET, TOKEN_EXPIRY |
| `.env.example` | Modify | Document new env vars |

### Verification
**Automated**:
- [ ] `npm install` succeeds
- [ ] `npm run typecheck` passes

**Manual**:
- [ ] Verify .env.example updated

## Phase 2: Auth Middleware

### Changes
| File | Action | Description |
|------|--------|-------------|
| `src/middleware/auth.ts` | Create | JWT verification middleware |
| `src/types/express.d.ts` | Create | Extend Request type with user |

### Verification
**Automated**:
- [ ] `npm run typecheck` passes
- [ ] `npm test` passes

## Phase 3: Protected Routes

### Changes
| File | Action | Description |
|------|--------|-------------|
| `src/routes/users.ts` | Modify | Add auth middleware to routes |
| `src/routes/auth.ts` | Create | Login/logout endpoints |

### Verification
**Automated**:
- [ ] All tests pass

**Manual**:
- [ ] Test login flow with curl/Postman
```

## Phase 3: Implement

**Command**: `/implement`

Executes each phase, running verification after each.

### Progress Output

```markdown
# Implementation Progress

## Status: Complete

| Phase | Status | Notes |
|-------|--------|-------|
| Phase 1: Dependencies | Complete | - |
| Phase 2: Middleware | Complete | - |
| Phase 3: Routes | Complete | Added integration test |

## Deviations from Plan

| Deviation | Reason | Impact |
|-----------|--------|--------|
| Added integration test | Discovered existing test pattern | Positive - better coverage |
```

## Phase 4: Validate

**Command**: `/validate`

```markdown
# Validation Results

| Check | Status |
|-------|--------|
| Tests | PASS (24 passed) |
| Lint | PASS |
| Types | PASS |
| Build | PASS |

## Overall: PASS
```

## Phase 5: Commit

**Command**: `/commit`

```
feat: add JWT authentication to API

## Summary
- Add jsonwebtoken-based auth middleware
- Add login/logout endpoints
- Protect user routes with auth requirement

## Artifacts
- Research: docs/003-jwt-auth/research/
- Plan: docs/003-jwt-auth/plans/implementation-plan.md
- Validation: docs/003-jwt-auth/validation/results.md

Generated with Claude Code using explore-plan-implement workflow
```

## Key Observations

1. **Research prevented wrong approach**: External research identified httpOnly cookies as best practice - without this, might have used localStorage (security issue).

2. **Plan caught integration point**: The plan identified the need to extend Express Request type - easy to miss without explicit planning.

3. **Deviation was documented**: Adding integration test wasn't in original plan but was documented, maintaining traceability.

4. **Artifacts enable review**: Reviewer can understand the change by reading plan (5 min) vs reading all code changes (30+ min).
