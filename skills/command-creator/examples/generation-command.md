# Example: Component Generation Command

This example demonstrates a well-structured generation command with templates.

## The Command

**File**: `commands/generate.md`

```markdown
---
description: Generate boilerplate component
argument-hint: [type] [name]
allowed-tools:
  - Read
  - Write
  - Glob
---

Generate a new $1 named $2.

## Supported Types

| Type | Description | Output Location |
|------|-------------|-----------------|
| `component` | React component | `src/components/$2/` |
| `hook` | Custom React hook | `src/hooks/use$2.ts` |
| `service` | API service class | `src/services/$2Service.ts` |
| `test` | Test file | `src/__tests__/$2.test.ts` |

If $1 is not recognized, list available types and ask user to choose.

## Template Discovery

Before generating, examine existing code to match project patterns:

1. Find similar files:
   - For component: `glob src/components/**/*.tsx`
   - For hook: `glob src/hooks/*.ts`
   - For service: `glob src/services/*.ts`

2. Read 2-3 examples to identify:
   - Import style (named vs default exports)
   - Naming conventions
   - File structure patterns
   - TypeScript usage patterns

## Generation Rules

### Components
```typescript
// Match existing component structure
// Include:
// - Props interface named ${Name}Props
// - Default export of component
// - CSS module import if project uses them
// - Test file alongside if project pattern
```

### Hooks
```typescript
// Match existing hook structure
// Include:
// - Return type annotation
// - JSDoc comment
// - Proper use* naming
```

### Services
```typescript
// Match existing service structure
// Include:
// - Class with typed methods
// - Error handling pattern from existing services
// - Singleton export if project uses that pattern
```

## Output

After generation:
1. List created files with full paths
2. Show any integration steps needed (imports, exports)
3. Suggest running tests: `npm test -- --watch $2`

## Validation

Before writing files:
- Check target path doesn't already exist
- Verify parent directories exist
- Confirm naming follows project conventions
```

## Why This Command Is Well-Structured

1. **Template Discovery**: Learns from existing code rather than imposing patterns
2. **Type Documentation**: Clear table of what can be generated
3. **Consistent Output**: Same structure regardless of type
4. **Safety Checks**: Validates before overwriting
5. **Follow-up Guidance**: Tells user what to do next
6. **Project-Aware**: Adapts to existing codebase conventions
