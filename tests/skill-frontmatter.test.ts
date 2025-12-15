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
