# External Research: Context Window Progress Indicator

**Date**: 2025-12-13
**Feature Slug**: 001-context-window-progress-indicator

## Goal

Research external documentation and best practices for implementing a progress indicator that displays context window utilization percentage in a Claude Code plugin.

## Documentation Reviewed

| Source | Version | Key Findings |
|--------|---------|--------------|
| Claude API Token Counting Docs | 2023-06-01 API version | Free token counting endpoint, TypeScript SDK support |
| Claude Context Windows Docs | Dec 2025 | Standard 200K tokens, 1M beta available |
| Evil Martians CLI UX Guide | 2025 | Three patterns for progress displays |
| npm tiktoken libraries | Various | OpenAI tokenizers, not directly applicable to Claude |

## Context Window Limits

### Standard Limits
- **Standard context window**: 200K tokens (approximately 500 pages of text)
- **Extended context (beta)**: 1M tokens for Claude Sonnet 4 and Sonnet 4.5
- **Enterprise plans**: 500K context window for Claude Sonnet 4.5

### Extended Context Requirements
- Requires `context-1m-2025-08-07` beta header
- Available for usage tier 4 organizations or custom rate limit customers
- Premium pricing: 2x input tokens, 1.5x output tokens for requests exceeding 200K

### Extended Thinking Considerations
- Input and output tokens (including thinking tokens) count toward context window
- Thinking budget tokens are a subset of `max_tokens` parameter
- Previous thinking blocks are automatically stripped from context calculation

**Source**: https://docs.claude.com/en/docs/build-with-claude/context-windows

## Token Counting API

### Endpoint
```
POST https://api.anthropic.com/v1/messages/count_tokens
```

### Key Characteristics
- **Free to use** (no token charges)
- Subject to requests-per-minute rate limits by usage tier
- Returns `{ "input_tokens": <number> }` response
- Separate rate limits from message creation

### Supported Content Types
- Text messages
- System prompts
- Tool definitions
- Images (base64 encoded)
- PDFs (base64 encoded)
- Extended thinking blocks

### Rate Limits by Usage Tier
| Tier | RPM |
|------|-----|
| 1    | 100 |
| 2    | 2,000 |
| 3    | 4,000 |
| 4    | 8,000 |

### Important Notes
- Token count is an **estimate** - actual usage may differ slightly
- Token counts may include system-added tokens (not billed)
- Does not use prompt caching logic

**Source**: https://platform.claude.com/docs/en/build-with-claude/token-counting

## Code Examples

### TypeScript Token Counting
```typescript
// Source: https://platform.claude.com/docs/en/build-with-claude/token-counting
import Anthropic from '@anthropic-ai/sdk';

const client = new Anthropic();

const response = await client.messages.countTokens({
  model: 'claude-sonnet-4-5',
  system: 'You are a scientist',
  messages: [{
    role: 'user',
    content: 'Hello, Claude'
  }]
});

console.log(response); // { input_tokens: 14 }
```

### Token Counting with Tools
```typescript
// Source: https://platform.claude.com/docs/en/build-with-claude/token-counting
const response = await client.messages.countTokens({
  model: 'claude-sonnet-4-5',
  tools: [
    {
      name: "get_weather",
      description: "Get the current weather in a given location",
      input_schema: {
        type: "object",
        properties: {
          location: {
            type: "string",
            description: "The city and state, e.g. San Francisco, CA",
          }
        },
        required: ["location"],
      }
    }
  ],
  messages: [{ role: "user", content: "What's the weather like in San Francisco?" }]
});
// Returns: { input_tokens: 403 }
```

## Best Practices for CLI Progress Indicators

### Pattern Selection

#### 1. Spinners
- **When to use**: Single or few sequential tasks completing within seconds; no quantifiable metrics available
- **Characteristics**: Simple implementation, minimal insight into actual progress
- **Recommendation**: Make spinners tick on task completion to signal if process stalls
- **Not suitable for**: Context utilization display (we have quantifiable metrics)

#### 2. X of Y Pattern
- **When to use**: Step-by-step processes with measurable progress; when total work can be determined
- **Characteristics**: Provides actionable data without visual overhead
- **Format**: `X / Y` (e.g., "45,000 / 200,000 tokens")
- **Best for**: Context window utilization display

#### 3. Progress Bars
- **When to use**: Multiple lengthy parallel processes; tracking numerous metrics
- **Note**: "Progress bars might be overkill" in CLI contexts
- **Alternative**: Single bar showing overall progress rather than individual bars

**Source**: https://evilmartians.com/chronicles/cli-ux-best-practices-3-patterns-for-improving-progress-displays

### Universal Best Practices

1. **Never leave users in silence** - Provide meaningful status updates during time-consuming operations
2. **Update messaging appropriately** - Use gerunds (-ing) during actions; past tense on completion
3. **Clean output logs** - Remove spinners/progress bars after completion
4. **Respect color preferences** - Honor `--no-color` flags and `NO_COLOR` environment variables
5. **Machine-readable output** - Ensure piped output remains machine-readable; consider `--plain` flags
6. **Test output redirection** - Verify appearance when piped to files

### Technical Considerations

- Handle terminal resize events
- Set minimum update interval (e.g., 0.1 seconds) to avoid excessive updates
- Implement graceful exit handling (SIGINT/SIGTERM)
- Consider non-dynamic terminals (cloud logging, K8s) - use slower update intervals
- Clear progress indicators on completion

## Token Counting Libraries

### For Claude (Recommended)
Use the official Anthropic SDK `messages.countTokens()` method - no third-party tokenizer needed.

### Third-Party Libraries (OpenAI-focused, NOT for Claude)
| Library | Type | Weekly Downloads | Notes |
|---------|------|------------------|-------|
| js-tiktoken | Pure JS | ~2M | OpenAI models only |
| tiktoken | WASM | - | OpenAI models, WASM bindings |
| gpt-tokenizer | TypeScript | - | OpenAI models, feature-rich |

**Important**: These libraries use OpenAI's BPE tokenizer encodings (cl100k_base, o200k_base, etc.) and are **not accurate for Claude models**. Claude uses a different tokenizer.

**Source**: https://www.npmjs.com/package/js-tiktoken

## Security Considerations

- Token counting endpoint requires API key authentication (`x-api-key` header)
- API keys should not be exposed in client-side code
- Rate limiting prevents abuse but may affect real-time display updates

## Performance Considerations

- Token counting is a network request - adds latency
- Consider caching token counts for unchanged content
- Rate limits (100-8000 RPM depending on tier) may constrain update frequency
- For real-time display, consider estimation between API calls
- Token counting API is separate from message creation - concurrent calls possible

## Relevant Model Information

| Model | Context Window | Notes |
|-------|----------------|-------|
| Claude Sonnet 4 | 200K (1M beta) | Extended context with beta header |
| Claude Sonnet 4.5 | 200K (1M beta) | Extended context with beta header |
| Claude Opus 4.5 | 200K | Standard context |

**Source**: https://docs.claude.com/en/docs/build-with-claude/context-windows

## Sources Referenced

- https://platform.claude.com/docs/en/build-with-claude/token-counting - Official token counting API documentation with code examples
- https://docs.claude.com/en/docs/build-with-claude/context-windows - Context window limits and extended context information
- https://evilmartians.com/chronicles/cli-ux-best-practices-3-patterns-for-improving-progress-displays - CLI UX patterns for progress displays
- https://www.npmjs.com/package/js-tiktoken - JavaScript tokenizer library documentation (OpenAI only)
- https://platform.claude.com/docs/en/api/rate-limits - Rate limit documentation by usage tier
