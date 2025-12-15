---
type: research
topic: documentation
feature: unit-testing-claude-plugins
description: "Research testing strategies for Claude Code plugins including markdown/YAML validation, prompt testing, JSON schema validation, and CLI testing frameworks"
created: 2025-12-14
status: complete

technologies:
  - name: "Claude Code Plugins"
    version: "public beta (October 2025)"
    docs_url: "https://code.claude.com/docs/en/plugins"
  - name: "Promptfoo"
    version: "latest"
    docs_url: "https://github.com/promptfoo/promptfoo"
  - name: "AJV (JSON Schema Validator)"
    version: "8.x"
    docs_url: "https://ajv.js.org/"
  - name: "remark-lint-frontmatter-schema"
    version: "latest"
    docs_url: "https://github.com/JulianCataldo/remark-lint-frontmatter-schema"
  - name: "BATS (Bash Automated Testing System)"
    version: "1.x"
    docs_url: "https://bats-core.readthedocs.io/"
  - name: "jest-json-schema"
    version: "latest"
    docs_url: "https://www.npmjs.com/package/jest-json-schema"

sources_consulted: 12
---

# Documentation Research: Unit Testing Claude Code Plugins

## Goal

Research testing strategies for Claude Code plugins including:
1. Claude Code plugin testing (built-in support, official documentation)
2. Markdown/YAML frontmatter validation approaches
3. LLM prompt testing best practices
4. JSON schema validation for plugin manifests
5. CLI subprocess testing frameworks
6. Appropriate testing frameworks for this type of project

## Documentation Reviewed

| Source | Version | Key Findings |
|--------|---------|--------------|
| Claude Code Plugins README | beta 2025 | Agent-based validation, no traditional unit test framework |
| Promptfoo | latest | Declarative LLM prompt testing with assertions |
| AJV | 8.x | Fastest JSON schema validator, Jest integration |
| remark-lint-frontmatter-schema | latest | YAML frontmatter validation against JSON schemas |
| BATS | 1.x | TAP-compliant Bash/CLI testing framework |
| ShellSpec | latest | BDD unit testing for shell scripts |

---

## 1. Claude Code Plugin Testing

### Official Support

**Source**: [Claude Code Plugins Documentation](https://code.claude.com/docs/en/plugins)

Claude Code plugins are in public beta (October 2025). The official documentation does not describe a traditional unit testing framework for plugins. Instead, testing is achieved through:

1. **Local Marketplace Testing**: Test plugins iteratively using a local marketplace
   ```bash
   /plugin marketplace add ./my-test-marketplace
   /plugin install my-awesome-plugin@test
   ```

2. **Agent-Based Validation**: The `plugin-dev` plugin provides validation agents:
   - `plugin-validator` - Validates plugins against best practices
   - `skill-reviewer` - Reviews skill implementations

3. **SDK Verification Agents** (for Agent SDK applications):
   - `agent-sdk-verifier-py` - Python SDK validation
   - `agent-sdk-verifier-ts` - TypeScript SDK validation

### Plugin Structure (Validation-Ready)

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json          # Plugin metadata
├── commands/                 # Slash commands
├── agents/                   # Specialized agents
├── skills/                   # Agent Skills
├── hooks/                    # Event handlers
├── .mcp.json                 # External tool configuration
└── README.md
```

### Key Finding

Claude Code does not provide built-in unit testing utilities. Testing relies on agent-based validation during development and manual verification via local marketplace installation.

---

## 2. Markdown/YAML Frontmatter Validation

### remark-lint-frontmatter-schema

**Source**: [GitHub - remark-lint-frontmatter-schema](https://github.com/JulianCataldo/remark-lint-frontmatter-schema)

Validates YAML frontmatter in Markdown files against JSON Schema.

#### Installation

```bash
pnpm install -D remark remark-cli remark-frontmatter remark-lint-frontmatter-schema
```

#### Configuration (.remarkrc.mjs)

```javascript
import remarkFrontmatter from 'remark-frontmatter';
import remarkLintFrontmatterSchema from 'remark-lint-frontmatter-schema';

const remarkConfig = {
  plugins: [remarkFrontmatter, remarkLintFrontmatterSchema],
};
export default remarkConfig;
```

#### Schema Association Methods

**Method 1: In-File Declaration**
```yaml
---
'$schema': schemas/command.schema.yaml
name: explore
description: Launch research agents
---
```

**Method 2: Global Pattern Mapping**
```javascript
[
  remarkLintFrontmatterSchema,
  {
    schemas: {
      './schemas/command.schema.yaml': ['./commands/*.md'],
      './schemas/skill.schema.yaml': ['./skills/*/SKILL.md']
    }
  }
]
```

#### Usage

```bash
pnpm remark .  # Validate all markdown files
```

### Key Finding

JSON Schema can validate YAML frontmatter structure. This enables automated validation of command definitions, skill metadata, and agent configurations.

---

## 3. LLM Prompt Testing

### Best Practices

**Sources**:
- [Confident AI - LLM Testing](https://www.confident-ai.com/blog/llm-testing-in-2024-top-methods-and-strategies)
- [Patronus AI - Test Prompts](https://www.patronus.ai/llm-testing/ai-llm-test-prompts)
- [Helicone - Test LLM Prompts](https://www.helicone.ai/blog/test-your-llm-prompts)

#### Testing Methods

| Method | Description | Use Case |
|--------|-------------|----------|
| Consistency Testing | Verify stable output for same prompt | Agent definitions |
| Edge Case Testing | Test with ambiguous/unusual inputs | Error handling |
| Regression Testing | Same test cases across iterations | Breaking changes |
| Intent Preservation | Ensure prompts deliver consistent intent | Skill behavior |

#### Key Principles

1. **Treat prompts as living tools**: Use version control, automate updates, integrate test-driven practices
2. **Use quantitative metrics**: Set thresholds to define "breaking changes"
3. **Test regularly**: Ensure outputs are accurate, relevant, and consistent
4. **Log and iterate**: Log requests, create variations, evaluate outputs

### Promptfoo

**Source**: [GitHub - Promptfoo](https://github.com/promptfoo/promptfoo)

LLM prompt testing framework with declarative configuration.

#### Installation

```bash
npx promptfoo@latest init
npx promptfoo eval
```

#### Key Features

- Automated evaluations comparing prompt performance
- Multi-model comparison (OpenAI, Anthropic, Azure, etc.)
- Red teaming and security scanning
- CI/CD integration
- 100% local execution for privacy

#### Use Case for Claude Plugins

Could be adapted to test agent definitions by:
1. Creating test prompts that simulate user inputs
2. Defining expected output patterns/behaviors
3. Running evaluations to verify agent responses

### Key Finding

LLM prompt testing requires a combination of consistency checking, regression testing, and potentially using tools like Promptfoo for systematic evaluation. For Claude Code plugins, focus on validating prompt structure and expected behavior patterns.

---

## 4. JSON Schema Validation (plugin.json)

### AJV (Another JSON Schema Validator)

**Source**: [AJV Documentation](https://ajv.js.org/)

Fastest JSON Schema validator for JavaScript.

#### Features

- Supports JSON Schema drafts 04, 06, 07, 2019-09, 2020-12
- JSON Type Definition (RFC8927)
- Compiles schemas to optimized JavaScript functions
- Works in Node.js, browser, Electron, etc.

#### Installation

```bash
npm install ajv
npm install ajv-formats  # For format validation (uri, email, etc.)
```

#### Basic Usage

```javascript
import Ajv from 'ajv';
const ajv = new Ajv({ allErrors: true });

const schema = {
  type: 'object',
  properties: {
    name: { type: 'string' },
    version: { type: 'string', pattern: '^\\d+\\.\\d+\\.\\d+$' }
  },
  required: ['name', 'version']
};

const validate = ajv.compile(schema);
const valid = validate(data);

if (!valid) {
  console.log(validate.errors);
}
```

### jest-json-schema

**Source**: [npm - jest-json-schema](https://www.npmjs.com/package/jest-json-schema)

Jest matchers for JSON Schema validation.

#### Installation

```bash
npm install -D jest-json-schema
```

#### Usage with Jest

```javascript
import { matchers } from 'jest-json-schema';
expect.extend(matchers);

const schema = { /* JSON Schema */ };

test('plugin.json matches schema', () => {
  const pluginJson = require('./.claude-plugin/plugin.json');
  expect(pluginJson).toMatchSchema(schema);
});
```

#### Custom Options

```javascript
import Ajv2020 from 'ajv/dist/2020';
import { matchersWithOptions } from 'jest-json-schema';

const matchers = matchersWithOptions({
  AjvClass: Ajv2020,
  allErrors: true
});
expect.extend(matchers);
```

### Key Finding

AJV with Jest provides robust JSON Schema validation for plugin.json manifests. Create a schema defining required fields, valid types, and constraints.

---

## 5. CLI/Subprocess Testing

### BATS (Bash Automated Testing System)

**Source**: [BATS Documentation](https://bats-core.readthedocs.io/)

TAP-compliant testing framework for Bash.

#### Installation

```bash
# macOS
brew install bats-core

# npm (cross-platform)
npm install -g bats
```

#### Basic Test Structure

```bash
#!/usr/bin/env bats

setup() {
  # Runs before each test
}

teardown() {
  # Runs after each test
}

@test "command returns success" {
  run my-command --flag
  [ "$status" -eq 0 ]
}

@test "output contains expected text" {
  run my-command
  [[ "$output" =~ "expected text" ]]
}
```

#### Key Features

- `run` command captures exit codes and output
- `load` function for sharing common test code
- `skip` for conditional test exclusion
- `setup`/`teardown` lifecycle hooks
- Each `@test` runs in separate subprocess

### ShellSpec

**Source**: [ShellSpec](https://shellspec.info/)

BDD unit testing framework for shell scripts.

- Supports bash, ksh, zsh, dash, POSIX shells
- Code coverage
- Mocking
- Parameterized tests
- Parallel execution

### Jest/Vitest for CLI Testing

For JavaScript-based CLI tools, use `child_process`:

```javascript
import { execSync, spawn } from 'child_process';

test('CLI command works', () => {
  const result = execSync('my-cli --version', { encoding: 'utf8' });
  expect(result).toContain('1.0.0');
});

test('CLI handles async output', async () => {
  const child = spawn('my-cli', ['--watch']);
  // ... handle streams
});
```

### Key Finding

BATS is ideal for testing shell-based CLI tools. For Node.js CLIs, Jest/Vitest with child_process works well. Claude Code plugins may need integration testing via local marketplace installation.

---

## 6. Testing Framework Recommendations

### Framework Comparison

| Framework | Use Case | Language | Strengths |
|-----------|----------|----------|-----------|
| **Vitest** | Unit tests, JSON schema validation | JavaScript/TypeScript | Fast, Vite-powered, modern |
| **Jest** | Unit tests, snapshot testing | JavaScript/TypeScript | Mature, large ecosystem |
| **BATS** | Bash script testing | Bash | Simple, TAP-compliant |
| **Promptfoo** | LLM prompt evaluation | Config-based | Multi-model, CI/CD ready |
| **remark-lint** | Markdown validation | JavaScript | JSON Schema for frontmatter |

### Recommended Stack for Claude Code Plugins

1. **Vitest or Jest**: For JSON schema validation, file structure testing
2. **AJV + jest-json-schema**: For plugin.json manifest validation
3. **remark-lint-frontmatter-schema**: For markdown file validation
4. **BATS** (optional): For testing any bash-based tooling
5. **Promptfoo** (optional): For systematic agent prompt evaluation

---

## Code Examples

### Example 1: Plugin Manifest Schema

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["name", "version", "description"],
  "properties": {
    "name": {
      "type": "string",
      "pattern": "^[a-z][a-z0-9-]*$"
    },
    "version": {
      "type": "string",
      "pattern": "^\\d+\\.\\d+\\.\\d+$"
    },
    "description": {
      "type": "string",
      "minLength": 10
    },
    "commands": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["name", "path"],
        "properties": {
          "name": { "type": "string" },
          "path": { "type": "string" }
        }
      }
    }
  }
}
```

### Example 2: Vitest Test for Plugin Structure

```typescript
import { describe, it, expect } from 'vitest';
import Ajv from 'ajv';
import { readFileSync, existsSync } from 'fs';
import { glob } from 'glob';

describe('Plugin Structure', () => {
  it('plugin.json exists and is valid JSON', () => {
    const path = '.claude-plugin/plugin.json';
    expect(existsSync(path)).toBe(true);

    const content = readFileSync(path, 'utf8');
    expect(() => JSON.parse(content)).not.toThrow();
  });

  it('plugin.json matches schema', () => {
    const ajv = new Ajv({ allErrors: true });
    const schema = JSON.parse(readFileSync('schemas/plugin.schema.json', 'utf8'));
    const plugin = JSON.parse(readFileSync('.claude-plugin/plugin.json', 'utf8'));

    const validate = ajv.compile(schema);
    const valid = validate(plugin);

    if (!valid) {
      console.error(validate.errors);
    }
    expect(valid).toBe(true);
  });

  it('all referenced command files exist', () => {
    const plugin = JSON.parse(readFileSync('.claude-plugin/plugin.json', 'utf8'));

    for (const cmd of plugin.commands || []) {
      expect(existsSync(cmd.path)).toBe(true);
    }
  });
});
```

### Example 3: BATS Test for CLI

```bash
#!/usr/bin/env bats

@test "claude --help shows plugin commands" {
  run claude --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "epic:explore" ]]
}

@test "plugin installs without error" {
  run claude /plugin install ./
  [ "$status" -eq 0 ]
}
```

---

## Security Considerations

- **Red Teaming**: Test prompts with malicious inputs before production
- **Input Validation**: Validate all user inputs in plugin commands
- **Prompt Injection**: Test agent definitions for injection vulnerabilities
- **File Path Validation**: Ensure file operations stay within expected boundaries

---

## Performance Considerations

- **Schema Compilation**: AJV compiles schemas once; reuse compiled validators
- **Parallel Execution**: Run independent tests in parallel (Vitest supports this by default)
- **Selective Testing**: Use test patterns to run only relevant tests during development

---

## Limitations and Gaps

1. **No Official Claude Plugin Testing Framework**: Testing relies on agent-based validation, not automated unit tests
2. **LLM Output Non-Determinism**: Same prompt may produce different outputs across runs
3. **Integration Testing Challenges**: Full plugin testing requires Claude Code runtime
4. **Prompt Evaluation Subjectivity**: "Correct" behavior may be context-dependent

---

## Sources

- [Claude Code Plugins Documentation](https://code.claude.com/docs/en/plugins) - Official plugin documentation
- [Claude Code Plugins README (GitHub)](https://github.com/anthropics/claude-code/blob/main/plugins/README.md) - Plugin structure and validation agents
- [Promptfoo (GitHub)](https://github.com/promptfoo/promptfoo) - LLM prompt testing framework
- [AJV Documentation](https://ajv.js.org/) - JSON Schema validation
- [jest-json-schema (npm)](https://www.npmjs.com/package/jest-json-schema) - Jest matchers for JSON Schema
- [remark-lint-frontmatter-schema (GitHub)](https://github.com/JulianCataldo/remark-lint-frontmatter-schema) - Markdown frontmatter validation
- [BATS Documentation](https://bats-core.readthedocs.io/) - Bash testing framework
- [ShellSpec](https://shellspec.info/) - BDD shell testing
- [Confident AI - LLM Testing](https://www.confident-ai.com/blog/llm-testing-in-2024-top-methods-and-strategies) - LLM testing strategies
- [Patronus AI - Test Prompts](https://www.patronus.ai/llm-testing/ai-llm-test-prompts) - Prompt testing best practices
- [Helicone - Test LLM Prompts](https://www.helicone.ai/blog/test-your-llm-prompts) - Systematic prompt improvement
- [Validating YAML frontmatter with JSONSchema](https://ndumas.com/2023/06/validating-yaml-frontmatter-with-jsonschema/) - Frontmatter validation approach
