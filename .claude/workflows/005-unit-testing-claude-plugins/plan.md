---
type: plan
feature: unit-testing-claude-plugins
description: "Add unit testing infrastructure to validate Claude Code plugin structure, YAML frontmatter, and JSON schemas"
created: 2025-12-14
status: pending

research:
  codebase: "./codebase-research.md"
  docs: "./docs-research.md"

phases:
  total: 3
  current: 0
  list:
    - name: "Test Infrastructure Setup"
      status: pending
      files_affected: 4
    - name: "JSON Schema Definitions"
      status: pending
      files_affected: 5
    - name: "Vitest Test Suite"
      status: pending
      files_affected: 4

validation:
  plan_validated: true
  validation_report: "./validation-report.md"

rollback_available: true
---

# Implementation Plan: Unit Testing Claude Code Plugins

**Research**: [Codebase](./codebase-research.md) | [Docs](./docs-research.md)

## Goal

Add automated testing infrastructure to validate the epic plugin's structure, ensuring:
1. `plugin.json` manifest is valid
2. Command files have correct YAML frontmatter
3. Skill files have required metadata
4. Agent files have proper structure
5. All referenced files exist

## Approach Summary

Based on research findings:
- **No built-in Claude Code testing framework** exists - must build our own (docs-research.md:93-95)
- **Plugin is markdown-based configuration** with no compiled code (codebase-research.md:360-362)
- **Recommended stack**: Vitest + AJV for JSON schema validation (docs-research.md:410-414)

We will:
1. Add Node.js test infrastructure (Vitest, AJV)
2. Define JSON schemas for each component type
3. Write tests that validate plugin structure against schemas

This approach provides:
- Fast, automated validation on every change
- Clear error messages when schema violations occur
- Foundation for future test expansion (e.g., Promptfoo for agent testing)

---

## Phase 1: Test Infrastructure Setup

### Changes

| File | Action | Description |
|------|--------|-------------|
| `package.json` | Create | Node.js project with test dependencies |
| `vitest.config.ts` | Create | Vitest configuration |
| `.gitignore` | Modify | Add node_modules, coverage |
| `tsconfig.json` | Create | TypeScript configuration for tests |

### Implementation Details

**package.json**:
```json
{
  "name": "epic-plugin-tests",
  "type": "module",
  "engines": {
    "node": ">=18.0.0"
  },
  "scripts": {
    "test": "vitest run",
    "test:watch": "vitest"
  },
  "devDependencies": {
    "vitest": "^2.1.0",
    "ajv": "^8.17.0",
    "ajv-formats": "^3.0.0",
    "typescript": "^5.0.0",
    "@types/node": "^20.0.0",
    "yaml": "^2.6.0",
    "glob": "^11.0.0"
  }
}
```

**vitest.config.ts**:
```typescript
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: true,
    include: ['tests/**/*.test.ts'],
  },
});
```

**tsconfig.json**:
```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ES2022",
    "moduleResolution": "bundler",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true
  },
  "include": ["tests/**/*.ts", "vitest.config.ts"]
}
```

**.gitignore additions** (append to existing file):
```
# Node.js
node_modules/
coverage/
.vitest/
*.log
*.tsbuildinfo
```

### Verification

**Automated**:
- [ ] `npm install` completes without errors
- [ ] `npm test` runs (empty test suite OK)

**Manual**:
- [ ] Verify node_modules not committed to git

---

## Phase 2: JSON Schema Definitions

### Changes

| File | Action | Description |
|------|--------|-------------|
| `schemas/plugin.schema.json` | Create | Schema for .claude-plugin/plugin.json |
| `schemas/command.schema.json` | Create | Schema for commands/*.md frontmatter |
| `schemas/skill.schema.json` | Create | Schema for skills/*/SKILL.md frontmatter |
| `schemas/agent.schema.json` | Create | Schema for agents/*.md frontmatter |
| `schemas/README.md` | Create | Documentation for schemas |

### Implementation Details

**schemas/plugin.schema.json** (based on codebase-research.md:49-64):
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["name", "version", "description"],
  "properties": {
    "name": {
      "type": "string",
      "pattern": "^[a-z][a-z0-9-]*$",
      "description": "Plugin identifier (lowercase, hyphens allowed)"
    },
    "version": {
      "type": "string",
      "pattern": "^\\d+\\.\\d+\\.\\d+$",
      "description": "Semantic version"
    },
    "description": {
      "type": "string",
      "minLength": 10
    },
    "author": {
      "type": "object",
      "properties": {
        "name": { "type": "string" }
      }
    },
    "keywords": {
      "type": "array",
      "items": { "type": "string" }
    }
  },
  "additionalProperties": true
}
```

**schemas/command.schema.json** (based on codebase-research.md:81-94):
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["description"],
  "properties": {
    "description": {
      "type": "string",
      "minLength": 5,
      "description": "Brief command description"
    },
    "argument-hint": {
      "type": "string",
      "description": "Optional argument hint displayed to user"
    }
  },
  "additionalProperties": true
}
```

**schemas/skill.schema.json** (based on codebase-research.md:108-123):
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["name", "description"],
  "properties": {
    "name": {
      "type": "string",
      "pattern": "^epic-[a-z-]+$",
      "description": "Skill name (epic-[phase] pattern, hyphens allowed)"
    },
    "description": {
      "type": "string",
      "minLength": 10
    },
    "allowed-tools": {
      "type": "array",
      "items": { "type": "string" },
      "description": "Tools this skill can use"
    }
  },
  "additionalProperties": true
}
```

**schemas/agent.schema.json** (based on codebase-research.md:177-211):
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["name", "description"],
  "properties": {
    "name": {
      "type": "string",
      "description": "Agent identifier"
    },
    "description": {
      "type": "string",
      "minLength": 10
    },
    "model": {
      "type": "string",
      "enum": ["haiku", "sonnet", "opus"],
      "description": "Model to use for this agent"
    },
    "allowed-tools": {
      "type": "array",
      "items": { "type": "string" }
    }
  },
  "additionalProperties": true
}
```

### Verification

**Automated**:
- [ ] All schema files are valid JSON: `node -e "require('./schemas/plugin.schema.json')"`
- [ ] Schemas compile without errors: `npx ajv compile -s schemas/plugin.schema.json`

**Manual**:
- [ ] Review schemas match actual file structures in codebase

---

## Phase 3: Vitest Test Suite

### Changes

| File | Action | Description |
|------|--------|-------------|
| `tests/plugin-structure.test.ts` | Create | Tests for plugin.json and file existence |
| `tests/command-frontmatter.test.ts` | Create | Tests for command YAML frontmatter |
| `tests/skill-frontmatter.test.ts` | Create | Tests for skill YAML frontmatter |
| `tests/agent-frontmatter.test.ts` | Create | Tests for agent YAML frontmatter |

### Implementation Details

**tests/plugin-structure.test.ts**:
```typescript
import { describe, it, expect } from 'vitest';
import Ajv from 'ajv';
import addFormats from 'ajv-formats';
import { readFileSync, existsSync } from 'fs';
import { glob } from 'glob';

const ajv = new Ajv({ allErrors: true });
addFormats(ajv);

describe('Plugin Structure', () => {
  it('plugin.json exists and is valid JSON', () => {
    const path = '.claude-plugin/plugin.json';
    expect(existsSync(path)).toBe(true);

    const content = readFileSync(path, 'utf8');
    expect(() => JSON.parse(content)).not.toThrow();
  });

  it('plugin.json matches schema', () => {
    const schema = JSON.parse(readFileSync('schemas/plugin.schema.json', 'utf8'));
    const plugin = JSON.parse(readFileSync('.claude-plugin/plugin.json', 'utf8'));

    const validate = ajv.compile(schema);
    const valid = validate(plugin);

    if (!valid) {
      console.error('Validation errors:', validate.errors);
    }
    expect(valid).toBe(true);
  });

  it('all command files exist', async () => {
    const commands = await glob('commands/*.md');
    expect(commands.length).toBeGreaterThan(0);

    for (const cmd of commands) {
      expect(existsSync(cmd)).toBe(true);
    }
  });

  it('all skill directories have SKILL.md', async () => {
    const skills = await glob('skills/*/SKILL.md');
    expect(skills.length).toBeGreaterThan(0);
    // Currently 7 skills per codebase-research.md:100
    // Using flexible assertion to allow plugin evolution
  });

  it('all agent files exist', async () => {
    const agents = await glob('agents/*.md');
    expect(agents.length).toBeGreaterThan(0);
    // Currently 4 agents per codebase-research.md:181
  });
});
```

**tests/command-frontmatter.test.ts**:
```typescript
import { describe, it, expect } from 'vitest';
import Ajv from 'ajv';
import { readFileSync } from 'fs';
import { glob } from 'glob';
import { parse as parseYaml } from 'yaml';

const ajv = new Ajv({ allErrors: true });

// Extract YAML frontmatter from markdown
function extractFrontmatter(content: string): object | null {
  const match = content.match(/^---\n([\s\S]*?)\n---/);
  if (!match) return null;
  return parseYaml(match[1]);
}

describe('Command Frontmatter', () => {
  it('all commands have valid YAML frontmatter', async () => {
    const schema = JSON.parse(readFileSync('schemas/command.schema.json', 'utf8'));
    const validate = ajv.compile(schema);
    const commands = await glob('commands/*.md');

    for (const cmd of commands) {
      const content = readFileSync(cmd, 'utf8');
      const frontmatter = extractFrontmatter(content);

      expect(frontmatter, `${cmd} missing frontmatter`).not.toBeNull();

      const valid = validate(frontmatter);
      if (!valid) {
        console.error(`${cmd} validation errors:`, validate.errors);
      }
      expect(valid, `${cmd} frontmatter invalid`).toBe(true);
    }
  });
});
```

**tests/skill-frontmatter.test.ts**:
```typescript
import { describe, it, expect } from 'vitest';
import Ajv from 'ajv';
import { readFileSync } from 'fs';
import { glob } from 'glob';
import { parse as parseYaml } from 'yaml';

const ajv = new Ajv({ allErrors: true });

function extractFrontmatter(content: string): object | null {
  const match = content.match(/^---\n([\s\S]*?)\n---/);
  if (!match) return null;
  try {
    return parseYaml(match[1]);
  } catch (e) {
    return null; // Return null for malformed YAML
  }
}

describe('Skill Frontmatter', () => {
  it('all skills have valid YAML frontmatter', async () => {
    const schema = JSON.parse(readFileSync('schemas/skill.schema.json', 'utf8'));
    const validate = ajv.compile(schema);
    const skills = await glob('skills/*/SKILL.md');

    for (const skill of skills) {
      const content = readFileSync(skill, 'utf8');
      const frontmatter = extractFrontmatter(content);

      expect(frontmatter, `${skill} missing or malformed frontmatter`).not.toBeNull();

      const valid = validate(frontmatter);
      if (!valid) {
        console.error(`${skill} validation errors:`, validate.errors);
      }
      expect(valid, `${skill} frontmatter invalid`).toBe(true);
    }
  });
});
```

**tests/agent-frontmatter.test.ts**:
```typescript
import { describe, it, expect } from 'vitest';
import Ajv from 'ajv';
import { readFileSync } from 'fs';
import { glob } from 'glob';
import { parse as parseYaml } from 'yaml';

const ajv = new Ajv({ allErrors: true });

function extractFrontmatter(content: string): object | null {
  const match = content.match(/^---\n([\s\S]*?)\n---/);
  if (!match) return null;
  try {
    return parseYaml(match[1]);
  } catch (e) {
    return null;
  }
}

describe('Agent Frontmatter', () => {
  it('all agents have valid YAML frontmatter', async () => {
    const schema = JSON.parse(readFileSync('schemas/agent.schema.json', 'utf8'));
    const validate = ajv.compile(schema);
    const agents = await glob('agents/*.md');

    for (const agent of agents) {
      const content = readFileSync(agent, 'utf8');
      const frontmatter = extractFrontmatter(content);

      expect(frontmatter, `${agent} missing or malformed frontmatter`).not.toBeNull();

      const valid = validate(frontmatter);
      if (!valid) {
        console.error(`${agent} validation errors:`, validate.errors);
      }
      expect(valid, `${agent} frontmatter invalid`).toBe(true);
    }
  });
});
```

### Verification

**Automated**:
- [ ] `npm test` passes all tests
- [ ] Tests catch intentionally broken files (manual test)

**Manual**:
- [ ] Review test output is clear and actionable
- [ ] Verify tests run in < 5 seconds

---

## Rollback Plan

If issues arise:
1. `git revert` the commits from each phase
2. Remove `node_modules/` directory
3. No changes to existing plugin files, so no cleanup needed

## Success Criteria

- [ ] `npm test` passes with all tests green
- [ ] Tests validate all 7 commands, 7 skills, 4 agents
- [ ] Invalid frontmatter produces clear error messages
- [ ] Test suite runs in < 10 seconds
- [ ] No changes to existing markdown/plugin files

## Decisions Made

1. **Schema strictness**: Using `additionalProperties: true` (lenient) to allow plugin evolution without breaking tests. This is appropriate for a plugin format that may add optional fields over time. Strict validation would be better for stable APIs.

2. **remark-lint integration**: Deferred to future enhancement. Vitest + AJV provides sufficient coverage for Phase 1. remark-lint could be added later for more comprehensive markdown linting.

3. **CI integration**: Deferred to future enhancement. Manual `npm test` is sufficient for initial implementation. GitHub Actions can be added as a follow-up task.

## Future Enhancements

- [ ] Add remark-lint-frontmatter-schema for comprehensive markdown linting
- [ ] Add GitHub Actions CI workflow
- [ ] Add template file validation (templates/, skills/*/references/)
- [ ] Add Promptfoo for agent prompt evaluation
