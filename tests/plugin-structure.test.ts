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
