---
description: Create Claude Code components (skills, agents, commands, hooks) from natural language
disable-model-invocation: false
---

Parse the user's input and invoke the plugin-builder:generator skill to scaffold the requested component.

**Input format:**
- User provides natural language description
- Example: "create a skill for code quality review"

**Your task:**
1. Extract the full description from the user's input
2. Invoke the plugin-builder:generator skill
3. Pass the description to the skill
4. Let the skill handle parsing, generation, and file creation

**Do not modify or interpret the description - pass it verbatim to the generator skill.**

**The generator skill will:**
- Parse the natural language to extract component type, domain, and name
- Load appropriate templates
- Generate domain-specific content using Claude's knowledge
- Create files in `.claude/` directory
- Confirm what was created

Invoke the skill now with the user's description.
