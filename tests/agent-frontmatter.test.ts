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
