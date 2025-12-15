# Plan Validation Report

## Summary
**PASS WITH CONCERNS**

The implementation plan is well-structured and demonstrates strong research grounding. The approach of using Vitest + AJV for JSON schema validation is sound and directly addresses the need for automated testing of plugin structure. All three phases are clearly defined with specific files, verification steps, and implementation details. However, there are several ambiguities and gaps that should be addressed before implementation begins.

## Completeness: ⚠

**Strengths:**
- Research artifacts are properly referenced with specific citations (docs-research.md:93-95, codebase-research.md:360-362, docs-research.md:410-414)
- All phases identify specific files to create/modify
- Each phase includes both automated and manual verification steps
- Rollback plan is present and straightforward
- Success criteria are measurable and specific

**Gaps:**
1. **Missing file path specifics for .gitignore modification**: Phase 1 says "modify .gitignore" but doesn't specify what lines to add or where. Should specify exact entries:
   - `node_modules/`
   - `coverage/`
   - `*.tsbuildinfo`

2. **Schema validation step unclear**: Phase 2 automated verification says "Schemas themselves validate against JSON Schema draft-07" but doesn't specify HOW to validate them (what tool/command?)

3. **Test coverage expectations not specified**: Phase 3 tests check for exact counts (7 skills, 4 agents) but doesn't specify what happens if counts change as plugin evolves. Should document whether these are hardcoded assertions or configurable.

4. **No specification for extractFrontmatter error handling**: The frontmatter extraction function in Phase 3 (lines 336-340) doesn't specify behavior for malformed YAML. Should this throw, return null, or handle gracefully?

5. **Skill/agent frontmatter test files not shown**: Phase 3 says "follow the same pattern" for skill-frontmatter.test.ts and agent-frontmatter.test.ts but doesn't provide implementation details. These should be explicit, especially since the schemas differ.

## Feasibility: ✓

**Strengths:**
- Technology choices are well-justified (Vitest chosen per docs-research.md:410-414)
- Dependencies are modern and actively maintained (Vitest 2.1.0, AJV 8.17.0)
- Phases have appropriate scope and logical ordering
- No circular dependencies
- All verification steps are executable

**Considerations:**
1. **TypeScript without tsconfig means no type checking during tests**: Phase 1 creates tsconfig.json but doesn't show its contents. If test files use TypeScript, tsconfig should enable strict type checking for maximum safety.

2. **Node version not specified**: Modern Vitest and TypeScript require Node 18+. Should document minimum Node version requirement in package.json (`"engines": { "node": ">=18.0.0" }`).

3. **glob import may need type definitions**: Code uses `import { glob } from 'glob'` but package.json doesn't include `@types/node` or `@types/glob`. Should add: `"@types/node": "^20.0.0"`.

## Quality: ⚠

**Strengths:**
- Follows established patterns from research (JSON Schema validation is industry standard)
- Test suite design follows Vitest best practices
- Schema definitions accurately reflect codebase structure per codebase-research.md citations
- Clear separation of concerns (schemas in /schemas, tests in /tests)
- No changes to existing plugin files (non-invasive approach)

**Concerns:**
1. **Schema strictness inconsistency**: Plan uses `additionalProperties: true` for all schemas (acknowledged in Open Questions), which makes validation lenient. This means typos in frontmatter won't be caught. Recommendation: Use `additionalProperties: false` with explicit optional fields, OR document why lenient validation is preferred.

2. **Skill name pattern may be too restrictive**: Schema at line 201 uses `"pattern": "^epic-[a-z]+$"` which only allows single-word phase names (epic-explore, epic-plan). This would reject valid names like "epic-foo-bar". Should use `"^epic-[a-z-]+$"` to allow hyphens.

3. **Hard-coded test expectations are brittle**: Lines 315 and 320 hard-code expectations:
   ```typescript
   expect(skills.length).toBe(7); // 7 skills per codebase-research.md:100
   expect(agents.length).toBe(4); // 4 agents per codebase-research.md:181
   ```
   This makes tests brittle. If a skill/agent is added, tests fail. Better approach: `expect(skills.length).toBeGreaterThan(0)` OR maintain a manifest of expected components.

4. **No validation of agent tool allowlists**: Schemas validate that `allowed-tools` is an array of strings, but don't verify that tools are valid Claude Code tools. This is probably fine (future enhancement), but worth noting.

5. **Template reference not tested**: The plan tests command/skill/agent files but doesn't test template files in `templates/` or `skills/*/references/`. These also have YAML frontmatter and structure that should be validated.

## Ambiguities Requiring Resolution

1. **Line 73: ".gitignore modify"** - What exact lines should be added? In what order? Should we check if entries already exist before adding?

2. **Line 74: "tsconfig.json create"** - What should tsconfig.json contain? Need full configuration shown, not just mentioned.

3. **Line 249-251: "Schemas themselves validate against JSON Schema draft-07"** - HOW? What command/tool validates this? Should provide explicit command like `npx ajv compile -s schemas/*.json` or similar.

4. **Line 364: "follow the same pattern"** - Need explicit implementation for skill-frontmatter.test.ts and agent-frontmatter.test.ts. Don't assume "same pattern" is clear enough.

5. **Open Question 1 (lines 395-396)** - Decision needed: `additionalProperties: true` (lenient) vs `false` (strict)? This affects validation quality. Recommendation: Use `false` for strictness, explicitly mark optional fields.

6. **Open Question 2 (lines 398-399)** - Should remark-lint integration happen now or later? If later, should be tracked as follow-up task, not left as open question.

7. **Open Question 3 (lines 401-402)** - CI integration decision needed before implementation? If yes, where should CI workflow file go, what triggers it?

## Risk Assessment

**High Risk:**
- None identified

**Medium Risk:**
1. **Hard-coded test assertions break when plugin evolves**: Tests expect exactly 7 skills and 4 agents. Adding/removing components breaks tests. Mitigation: Use configurable manifest or more flexible assertions.

2. **Missing type definitions may cause runtime errors**: Tests import from `glob` and use `fs` without `@types/*` packages. Mitigation: Add `@types/node` to devDependencies.

3. **Schema pattern for skill names is too restrictive**: Pattern `^epic-[a-z]+$` rejects hyphenated names. Mitigation: Change to `^epic-[a-z-]+$`.

**Low Risk:**
1. **Lenient schema validation may miss typos**: Using `additionalProperties: true` means typos won't be caught. Mitigation: Switch to `additionalProperties: false` or document rationale.

2. **Template files not validated**: templates/ and skills/*/references/ files have frontmatter but aren't tested. Mitigation: Add template validation in Phase 3 or document as future enhancement.

## Required Changes Before Implementation

1. **Add explicit .gitignore entries to Phase 1**:
   ```
   Modify .gitignore to add:
   - node_modules/
   - coverage/
   - .vitest/
   - *.log
   ```

2. **Provide complete tsconfig.json in Phase 1**:
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
     "include": ["tests/**/*.ts"]
   }
   ```

3. **Add @types/node to package.json dependencies** (Phase 1, line 93):
   ```json
   "@types/node": "^20.0.0"
   ```

4. **Specify schema self-validation command** (Phase 2, line 250):
   ```
   Automated:
   - [ ] All schema files are valid JSON (use: node -e "require('./schemas/...')")
   - [ ] Schemas are valid JSON Schema draft-07 (use: npx ajv compile -s schemas/*.json)
   ```

5. **Fix skill name pattern** (Phase 2, line 201):
   ```json
   "pattern": "^epic-[a-z-]+$"
   ```
   (Allow hyphens in skill names)

6. **Provide explicit test implementations for skill and agent frontmatter tests** (Phase 3, line 364):
   Don't just say "follow the same pattern" - show the actual code for both test files.

7. **Make test assertions configurable or flexible** (Phase 3, lines 315, 320):
   Either:
   - Use `expect(skills.length).toBeGreaterThan(0)` for flexibility, OR
   - Create a manifest file listing expected components and compare against it

8. **Resolve Open Question 1**: Decide on `additionalProperties: true` vs `false` and implement consistently across all schemas.

## Recommendations (Optional Improvements)

1. **Add package.json "engines" field**: Specify minimum Node version (18+) to prevent issues with older Node versions.

2. **Add npm scripts for schema validation**:
   ```json
   "scripts": {
     "test": "vitest run",
     "test:watch": "vitest",
     "validate:schemas": "node scripts/validate-schemas.js"
   }
   ```

3. **Consider testing template files**: Add Phase 3.5 or Future Enhancement to validate templates/ and skills/*/references/ frontmatter.

4. **Add test for frontmatter YAML syntax errors**: Create a test that intentionally uses malformed YAML to verify error handling in extractFrontmatter.

5. **Document test philosophy in README**: Add section explaining what the tests validate (structure, not behavior) and why.

6. **Add .nvmrc or .node-version**: Help developers use correct Node version automatically.

7. **Consider watch mode in verification**: Phase 3 manual verification could mention `npm run test:watch` for iterative development.

## Validation Against CLAUDE.md Principles

✓ **Research-based decisions**: Plan cites specific research findings (docs-research.md:93-95, etc.)

✓ **No assumptions from training data**: All technology choices justified by research

✓ **Specific file references**: All files identified, though some need line-level detail

⚠ **Verification steps**: Present but some lack specificity (schema self-validation command missing)

✓ **Atomic phases**: Each phase is independently verifiable and right-sized

✓ **Professional workflow**: Follows standard Node.js testing patterns, not vibe coding

## Final Recommendation

This plan is **ready for implementation after addressing Required Changes 1-8**. The core approach is sound, research is thorough, and the structure is logical. The concerns are mostly about specification completeness (missing tsconfig.json content, unclear commands) and minor technical issues (type definitions, schema patterns) that are easy to fix before starting.

The plan demonstrates good understanding of the testing landscape and makes appropriate technology choices. Once ambiguities are resolved and required changes are made, this plan should execute smoothly.

---

**Verdict**: PASS WITH CONCERNS
**Required Changes**: 8
**Recommended Enhancements**: 7
**Estimated Impact of Issues**: Low (all issues are specification gaps, not fundamental flaws)
