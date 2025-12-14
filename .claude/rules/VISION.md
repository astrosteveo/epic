

# Getting AI to Work in Complex Codebases

It seems pretty well-accepted that AI coding tools struggle with real production codebases. The Stanford study on AI's impact on developer productivity found:

1. A lot of the "extra code" shipped by AI tools ends up just reworking the slop that was shipped last week.
2. Coding agents are great for new projects or small changes, but in large established codebases, they can often make developers *less* productive.

The common response is somewhere between the pessimist "this will never work" and the more measured "maybe someday when there are smarter models."

After several months of tinkering, I've found that **you can get really far with today's models if you embrace core context engineering principles**.

This isn't another "10x your productivity" pitch. But we've stumbled into workflows that leave me with considerable optimism for what's possible. We've gotten claude code to handle 300k LOC Rust codebases, ship a week's worth of work in a day, and maintain code quality that passes expert review. We use a family of techniques I call "frequent intentional compaction" - deliberately structuring how you feed context to the AI throughout the development process.

I am now fully convinced that AI for coding is not just for toys and prototypes, but rather a deeply technical engineering craft.

### Grounding Context from AI Engineer

Two talks from AI Engineer 2025 fundamentally shaped my thinking about this problem.

The first is Sean Grove's talk on "Specs are the new code" and the second is the Stanford study on AI's impact on developer productivity.

Sean argued that we're all *vibe coding wrong*. The idea of chatting with an AI agent for two hours, specifying what you want, and then throwing away all the prompts while committing only the final code… is like a Java developer compiling a JAR and checking in the compiled binary while throwing away the source.

Sean proposes that in the AI future, the specs will become the real code. That in two years, you'll be opening python files in your IDE with about the same frequency that, today, you might open up a hex editor to read assembly (which, for most of us, is never).

Yegor's talk on developer productivity tackled an orthogonal problem. They analyzed commits from 100k developers and found, among other things,

1. That AI tools often lead to a lot of rework, diminishing the perceived productivity gains

```
[DIAGRAM: Bar chart showing "AI Rework Rate" - demonstrates that significant
portion of AI-generated code gets reworked/rewritten shortly after being committed,
reducing net productivity gains]
```

2. That AI tools work well for greenfield projects, but are often counter-productive for brownfield codebases and complex tasks

```
[DIAGRAM: 2x2 matrix showing AI effectiveness:
- Greenfield + Simple: HIGH effectiveness
- Greenfield + Complex: MEDIUM effectiveness
- Brownfield + Simple: MEDIUM effectiveness
- Brownfield + Complex: LOW/NEGATIVE effectiveness]
```

This matched what I heard talking with founders:

* "Too much slop."
* "Tech debt factory."
* "Doesn't work in big repos."
* "Doesn't work for complex systems."

The general vibe on AI-coding for hard stuff tends to be

> Maybe someday, when models are smarter…

Whenever I hear "Maybe someday when the models are smart" I generally leap to exclaim **that's what context engineering is all about**: getting the most out of *today's* models.

### What's actually possible today

I'll deep dive on this a bit futher down, but to prove this isn't just theory, let me outline a concrete example. A few weeks ago, I decided to test our techniques on BAML, a 300k LOC Rust codebase for a programming language that works with LLMs. I'm at best an amateur Rust dev and had never touched the BAML codebase before.

Within an hour or so, I had a PR fixing a bug which was approved by the maintainer the next morning. A few weeks later, we paired on shipping 35k LOC to BAML, adding cancellation support and WASM compilation - features the team estimated would take a senior engineer 3-5 days each. We got both draft PRs ready in about 7 hours.

Again, this is all built around a workflow we call **frequent intentional compaction** - essentially designing your entire development process around context management, keeping utilization in the 40-60% range, and building in high-leverage human review at exactly the right points. We use a "research, plan, implement" workflow, but the core capabilities/learnings here are FAR more general than any specific workflow or set of prompts.

### Our weird journey to get here

I was working with one of the most productive AI coders I've ever met.
Every few days they'd drop **2000-line Go PRs**.
And this wasn't a nextjs app or a CRUD API. This was complex, race-prone systems code that did JSON RPC over unix sockets and managed streaming stdio from forked unix processes.

The idea of carefully reading 2,000 lines of complex Go code every few days was simply not sustainable.

Our approach was to adopt something like Sean's **spec-driven development**.

It was uncomfortable at first.
I had to learn to let go of reading every line of PR code.
I still read the tests pretty carefully, but the specs became our source of truth for what was being built and why.

The transformation took about 8 weeks.
It was incredibly uncomfortable for everyone involved, not least of all for me.
But now we're flying. A few weeks back, I shipped 6 PRs in a day.
I can count on one hand the number of times I've edited a non-markdown file by hand in the last three months.

## Advanced Context Engineering for Coding Agents

What we needed was:

* AI that Works Well in Brownfield Codebases
* AI that Solves Complex Problems
* No Slop
* Maintain Mental Alignment across the team

I'll dive into:

1. what we learned applying context engineering to coding agents
2. the dimensions along which using these agents is a deeply technical craft
3. why I don't believe these approaches are generalizable
4. the number of times I've been repeatedly proven wrong about (3)

### But first: The Naive Way to manage agent context

Most of us start by using a coding agent like a chatbot. You talk back and forth with it, vibing your way through a problem until you either run out of context, give up, or the agent starts apologizing.

```
[DIAGRAM: "Naive Vibe Coding"
Shows a single long conversation arrow getting progressively filled with:
- User messages
- Agent responses
- File reads
- Tool calls
- Error logs
Until the context window is completely full and labeled "EXHAUSTED - Agent starts apologizing"]
```

A slightly smarter way is to just start over when you get off track, discarding your session and starting a new one, perhaps with a little more steering in the prompt.

> [original prompt], but make sure you use XYZ approach, because ABC approach won't work

```
[DIAGRAM: "Restart When Stuck"
Shows multiple shorter conversation arrows:
- First attempt → gets stuck → discarded
- Second attempt with more steering → gets stuck → discarded
- Third attempt with even more steering → maybe succeeds
Each arrow is independent, no learning carried forward]
```

### Slightly Smarter: Intentional Compaction

You have probably done something I've come to call "intentional compaction". Whether you're on track or not, as your context starts to fill up, you probably want to pause your work and start over with a fresh context window. To do this, you might use a prompt like

> "Write everything we did so far to progress.md, ensure to note the end goal, the approach we're taking, the steps we've done so far, and the current failure we're working on"

```
[DIAGRAM: "Intentional Compaction"
Shows conversation arrow filling up to ~60%, then:
- Arrow pointing to "progress.md" document (compacted state)
- New fresh conversation arrow starting with progress.md loaded
- This new arrow has much more room to work
Label: "Compact before exhaustion, carry forward structured state"]
```

You can also use commit messages for intentional compaction.

### What Exactly Are We Compacting?

What eats up context?

* Searching for files
* Understanding code flow
* Applying edits
* Test/build logs
* Huge JSON blobs from tools

All of these can flood the context window. **Compaction** is simply distilling them into structured artifacts.

A good output for an intentional compaction might include something like:

```
## Compaction Output Example

### Goal
Add rate limiting to the API endpoints

### Approach
Using token bucket algorithm with Redis backend

### Files Identified
- src/middleware/rateLimit.ts (create new)
- src/routes/api.ts:45-67 (add middleware)
- src/config/redis.ts (connection config)

### Completed
- [x] Researched existing middleware patterns
- [x] Found Redis connection singleton

### Current Status
Implementing token bucket logic, test failing on edge case

### Next Steps
1. Fix edge case in bucket refill logic
2. Add integration tests
3. Update API documentation
```

### Why obsess over context?

As we went deep on in 12-factor agents, LLMs are stateless functions. The only thing that affects the quality of your output (without training/tuning models themselves) is the quality of the inputs.

This is just as true for wielding coding agents as it is for general agent design, you just have a smaller problem space, and rather than building agents, we're talking about using agents.

At any given point, a turn in an agent like claude code is a stateless function call. Context window in, next step out.

```
[DIAGRAM: "LLM as Stateless Function"
Shows:
  Context Window Contents
  ├── System prompt
  ├── CLAUDE.md
  ├── Conversation history
  ├── File contents read
  ├── Tool results
  └── Current user message
           │
           ▼
      [LLM Function]
           │
           ▼
      Next Action/Response

Label: "Context window is your ONLY lever for output quality"]
```

That is, the contents of your context window are the ONLY lever you have to affect the quality of your output. So yeah, it's worth obsessing over.

You should optimize your context window for:

1. Correctness
2. Completeness
3. Size
4. Trajectory

Put another way, the worst things that can happen to your context window, in order, are:

1. Incorrect Information
2. Missing Information
3. Too much Noise

If you like equations, here's a dumb one you can reference:

```
Output Quality = f(Correctness, Completeness, 1/Noise)

Where:
- Correctness: Is the information in context accurate?
- Completeness: Does context contain what's needed?
- Noise: How much irrelevant content is in context?
```

As Geoff Huntley puts it,

> The name of the game is that you only have approximately **170k of context window** to work with.
> So it's essential to use as little of it as possible.
> The more you use the context window, the worse the outcomes you'll get.

Geoff's solution to this engineering constraint is a technique he calls "Ralph Wiggum as a Software Engineer", which basically involves running an agent in a while loop forever with a simple prompt.

```bash
while :; do
  cat PROMPT.md | npx --yes @sourcegraph/amp
done
```

Geoff describes ralph as a "hilariously dumb" solution to the context window problem. I'm not entirely sure that it is dumb.

### Back to compaction: Using Sub-Agents

Subagents are another way to manage context, and generic subagents have been a feature of claude code and many coding CLIs since the early days.

Subagents are not about playing house and anthropomorphizing roles. Subagents are about context control.

The most common/straightforward use case for subagents is to let you use a fresh context window to do finding/searching/summarizing that enables the parent agent to get straight to work without clouding its context window with `Glob` / `Grep` / `Read` / etc calls.

```
[DIAGRAM: "Subagent for Context Isolation"

Parent Agent Context                    Subagent Context
(stays clean)                          (disposable)
     │                                       │
     │── "Find all auth-related files" ────▶│
     │                                       │── grep "auth"
     │                                       │── glob **/*.ts
     │                                       │── read file1.ts
     │                                       │── read file2.ts
     │                                       │── read file3.ts
     │                                       │
     │◀── Returns compact summary: ─────────│
     │    • auth/login.ts:23 - main entry   │
     │    • auth/session.ts:45 - token mgmt │
     │    • middleware/auth.ts:12 - guards  │
     │                                       │
     │    [Subagent context discarded]      ▼
     │
[Parent continues with clean context + summary]
```

The ideal subagent response probably looks similar to the ideal ad-hoc compaction from above - structured, with file:line references, focused on what exists and how it connects.

Getting a subagent to return this is not trivial:

```
[DIAGRAM: "Subagent Prompting Challenge"

What you ask for:
"Find files related to authentication"

What you might get back:
❌ "I found 47 files. Here they all are with full contents..."
❌ "The authentication system could be improved by..."
❌ "I searched but couldn't find anything definitive..."

What you actually want:
✓ Structured list of relevant files with line numbers
✓ Brief description of what each does
✓ How they connect to each other
✓ NO suggestions, NO critique, just facts]
```

### What works even better: Frequent Intentional Compaction

The techniques I want to talk about and that we've adopted in the last few months fall under what I call "frequent intentional compaction".

Essentially, this means designing your ENTIRE WORKFLOW around context management, and keeping utilization in the 40%-60% range (depends on complexity of the problem).

The way we do it is to split into three (ish) steps.

I say "ish" because sometimes we skip the research and go straight to planning, and sometimes we'll do multiple passes of compacted research before we're ready to implement.

For a given feature or bug, we'll tend to do:

**Research**

Understand the codebase, the files relevant to the issue, and how information flows, and perhaps potential causes of a problem.

The research prompt uses custom subagents, but a generic version using the claude code Task() tool with `general-agent` works almost as well.

**Plan**

Outline the exact steps we'll take to fix the issue, and the files we'll need to edit and how, being super precise about the testing / verification steps in each phase.

**Implement**

Step through the plan, phase by phase. For complex work, I'll often compact the current status back into the original plan file after each implementation phase is verified.

Aside - if you've been hearing a lot about git worktrees, this is the only step that needs to be done in a worktree. We tend to do everything else on main.

### Putting this into practice

Several weeks ago, I decided to test our techniques on a 300k LOC Rust codebase for BAML, a programming language for working with LLMs. I picked out an (admittedly small-ish) bug from the repo and got to work.

**Worth noting**: I am at best an amateur Rust dev, and I have never worked in the BAML codebase before.

#### The research

- I created a piece of research, I read it. Claude decided the bug was invalid and the codebase was correct.
- I threw that research out and kicked off a new one, with more steering.
- The final research doc correctly mapped the relevant code paths.

#### The plans

- While the research was running, I got impatient and kicked off a plan, with no research, to see if claude could go straight to an implementation plan.
- When the research was done, I kicked off another implementation plan that used the research results.

The plans are both fairly short, but they differ significantly. They fix the issue in different ways, and have different testing approaches. Without going too much into detail, they both "would have worked" but the one built with research fixed the problem in the *best* place and prescribed testing that was in line with the codebase conventions.

#### The implementation

- This was all happening the night before the podcast recording. I ran both plans in parallel and submitted both as PRs before signing off for the night.

By the time we were on the show at 10am PT the next day, the PR from the plan with the research was already approved by the maintainer, who didn't even know I was doing a bit for a podcast. We closed the other one.

So out of our original 4 goals, we hit:

- ✅ Works in brownfield codebases (300k LOC rust project)
- Solves complex problems
- ✅ no slop (pr merged)
- Keeps mental alignment

### Solving complex problems

To test on a more complex problem, we spent 7 hours (3 hours on research/plans, 4 hours on implementation) and shipped 35k LOC to add cancellation and wasm support to BAML.

The cancelation PR got merged. The WASM one has a working demo of calling the wasm-compiled rust runtime from a JS app in the browser.

While the cancelation PR required a little more love to take things over the line, we got incredible progress in just a day. Each of these PRs would have been 3-5 days of work for a senior engineer on the BAML team to complete.

✅ So we can solve complex problems too.

### This is not Magic

Remember that part in the example where I read the research and threw it out cause it was wrong? Or sitting DEEPLY ENGAGED FOR 7 HOURS? You have to engage with your task when you're doing this or it WILL NOT WORK.

There's a certain type of person who is always looking for the one magic prompt that will solve all their problems. It doesn't exist.

Frequent Intentional Compaction via a research/plan/implement flow will make your performance **better**, but what makes it **good enough for hard problems** is that you build high-leverage human review into your pipeline.

```
[DIAGRAM: "Human Review Gates in Workflow"

Research Phase ──▶ [HUMAN REVIEWS RESEARCH] ──▶ Plan Phase
                         │
                         ├── Is understanding correct?
                         ├── Any missing context?
                         └── Need to re-research?

Plan Phase ──▶ [HUMAN REVIEWS PLAN] ──▶ Implement Phase
                    │
                    ├── Is approach sound?
                    ├── Are phases right-sized?
                    ├── Verification steps adequate?
                    └── Need to revise?

Implement Phase ──▶ [HUMAN VERIFIES EACH PHASE] ──▶ Done
                           │
                           ├── Automated tests pass?
                           ├── Manual verification done?
                           └── Ready for next phase?
]
```

### Eggs on Faces

A few weeks back, we sat down for 7 hours and tried to remove hadoop dependencies from parquet java - it did not go well. The tl;dr is that the research steps didn't go deep enough through the dependency tree, and assumed classes could be moved upstream without introducing deeply nested hadoop dependencies.

There are big hard problems you cannot just prompt your way through in 7 hours, and we're still curiously and excitedly hacking on pushing the boundaries. I think the other learning here is that you probably need at least one person who is an expert in the codebase, and for this case, that was neither of us.

### On Human Leverage

If there's one thing you take away from all this, let it be this:

A bad line of code is… a bad line of code.
But a bad line of a **plan** could lead to hundreds of bad lines of code.
And a bad line of **research**, a misunderstanding of how the codebase works or where certain functionality is located, could land you with thousands of bad lines of code.

```
[DIAGRAM: "Error Amplification by Phase"

                    Impact of Errors

Research Error ─────────────────────────────────▶ 1000s of bad LOC
                 (misunderstanding cascades)

Plan Error ────────────────────▶ 100s of bad LOC
              (wrong approach)

Code Error ────▶ ~1 bad LOC
            (localized)

LEVERAGE: Focus human attention on Research > Plan > Code
]
```

So you want to **focus human effort and attention** on the HIGHEST LEVERAGE parts of the pipeline.

```
[DIAGRAM: "Human Attention Allocation"

Traditional Code Review:
[============================] 100% on final code
Result: Catching errors after they've multiplied

Research-Plan-Implement Review:
[==========] 40% on Research  ← Catch misunderstandings early
[========]   30% on Plan      ← Catch bad approaches
[======]     20% on Code      ← Catch implementation bugs
[==]         10% on PR        ← Final sanity check

Result: Errors caught at highest leverage point
]
```

When you review the research and the plans, you get more leverage than you do when you review the code.

### What is code review for?

People have a lot of different opinions on what code review is for.

I prefer Blake Smith's framing in Code Review Essentials for Software Teams, where he says the most important part of code review is mental alignment - keeping members of the team on the page as to how the code is changing and why.

```
[DIAGRAM: "Code Review Purpose - Mental Alignment"

Without Specs/Plans:
Engineer A ──[2000 line PR]──▶ Engineer B
                                    │
                                    ├── What is this trying to do?
                                    ├── Why this approach?
                                    ├── What changed in the system?
                                    └── Takes hours to understand

With Research/Plans:
Engineer A ──[200 line plan]──▶ Engineer B
                                    │
                                    ├── Clear goal stated
                                    ├── Approach explained
                                    ├── Phases documented
                                    └── Takes 15 minutes to understand

Then: [2000 line PR] becomes mechanical verification
]
```

Remember those 2k line golang PRs? I cared about them being correct and well designed, but the biggest source of internal unrest and frustration on the team was the lack of mental alignment. **I was starting to lose touch with what our product was and how it worked.**

I would expect that anyone who's worked with a very productive AI coder has had this experience.

This is actually the most important part of research/plan/implement to us.
A guaranteed side effect of everyone shipping way more code is that a much larger proportion of your codebase is going to be unfamiliar to any given engineer at any point in time.

I won't even try to convince you that research/plan/implement is the right approach for most teams - it probably isn't. But you ABSOLUTELY need an engineering process that

1. keeps team members on the same page
2. enables team members to quickly learn about unfamiliar parts of the codebase

For most teams, this is pull requests and internal docs. For us, it's now specs, plans, and research.

I can't read 2000 lines of golang daily. But I *can* read 200 lines of a well-written implementation plan.

I can't go spelunking through 40+ files of daemon code for an hour+ when something is broken. I *can* steer a research prompt to give me the speed-run on where I should be looking and why.

### Recap

Basically we got everything we needed.

- ✅ Works in brownfield codebases
- ✅ Solves complex problems
- ✅ No slop
- ✅ Maintains mental alignment

(oh, and yeah, our team of three is averaging about $12k on opus per month)

This does not work perfectly for every problem (we'll be back for another round, parquet-java).

In August the whole team spent 2 weeks spinning circles on a really tricky race condition that spiraled into a rabbit hole of issues with MCP sHTTP keepalives in golang and a whole bunch of other dead ends.

But that's the exception now. In general, this works well for us. Our intern shipped 2 PRs on his first day, and 10 on his 8th day.

### What's coming

I'm reasonably confident that coding agents will be commoditized.

The hard part will be the team and workflow transformation. Everything about collaboration will change in a world where AI writes 99% of our code.

And I believe pretty strongly that if you don't figure this out, you're gonna get lapped by someone who did.

---

## Summary: The Frequent Intentional Compaction Workflow

### Core Principle
Design your entire workflow around context management. Keep utilization at 40-60%. Compact learnings into reusable artifacts.

### The Three Phases

**1. RESEARCH** (when codebase is unfamiliar)
- Use subagent or separate session for exploration
- Output: structured document with file:line references
- Rules: Document what exists. No suggestions. No critique.

**2. PLAN** (before any implementation)
- Read research document first
- Break into phases with verification steps per phase
- Each phase: specific changes + automated checks + manual checks
- Get human approval before implementing

**3. IMPLEMENT** (execute the approved plan)
- One phase at a time
- Run automated verification after each phase
- Pause for manual verification
- Update checkboxes in plan as you complete items
- If reality ≠ plan: STOP, communicate, get guidance

### Context Management Rules

**Compact when:**
- Context > 60% utilized
- Switching tasks
- Session ending with work in progress
- Major phase complete

**What eats context (avoid):**
- Excessive grep/glob/read → use subagent instead
- Raw build/test output → summarize errors only
- Large JSON/logs → extract relevant parts only

### The Leverage Hierarchy

```
Error in Research → 1000s of bad lines of code
Error in Plan     → 100s of bad lines of code
Error in Code     → ~1 bad line of code

Therefore: Human review should focus on Research > Plan > Code
```

### Success Criteria

- ✓ Works in brownfield (large existing codebases)
- ✓ Solves complex multi-file problems
- ✓ No slop (passes expert review)
- ✓ Team maintains mental alignment on changes
