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
