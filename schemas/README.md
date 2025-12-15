# JSON Schemas

This directory contains JSON Schema definitions for validating the epic plugin structure.

## Schemas

| Schema | Validates | Required Fields |
|--------|-----------|-----------------|
| `plugin.schema.json` | `.claude-plugin/plugin.json` | name, version, description |
| `command.schema.json` | `commands/*.md` frontmatter | description |
| `skill.schema.json` | `skills/*/SKILL.md` frontmatter | name, description |
| `agent.schema.json` | `agents/*.md` frontmatter | name, description |

## Design Decisions

- **Lenient validation**: All schemas use `additionalProperties: true` to allow plugin evolution without breaking tests
- **Minimal required fields**: Only truly essential fields are required
- **Flexible patterns**: Skill names allow hyphens (`^epic-[a-z-]+$`)

## Usage

These schemas are used by the Vitest test suite in `tests/` to validate plugin structure automatically.

```bash
npm test
```
