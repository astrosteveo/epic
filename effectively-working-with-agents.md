---
title: "Effectively Working with Coding Agents: A Framework for Modern Software Development"
author: "Anonymous"
date: \today
abstract: |
  The rapid emergence and adoption of artificial intelligence-powered coding assistants represents a paradigm shift in software development practices. This paper examines the implications of integrating autonomous coding agents into development workflows, analyzing their impact on software engineering methodologies and identifying best practices for maximizing their effectiveness. We present a comprehensive framework for working with coding agents across multiple contexts, from rapid prototyping to complex system architecture. Our analysis spans the integration of agents across documentation platforms, integrated development environments, and standalone applications, demonstrating the breadth of impact of this technological shift.
---

# 1. Introduction

## 1.1 Motivation

The emergence of coding assistants has become a defining characteristic of modern software development. Over the past year, these tools have proliferated across the technology landscape at an unprecedented rate. Their integration spans multiple platforms: documentation sites now feature embedded assistants, integrated development environments (IDEs) are being architected with deep agent integration as a core design principle, and standalone applications dedicated to coding assistance have entered the market.

## 1.2 Research Context

This widespread adoption signals a fundamental shift in how software is developed, shipped, and maintained. The implications extend beyond individual programmer productivity to encompass team dynamics, project management, and organizational software engineering practices. Understanding how to effectively integrate and leverage coding agents is becoming increasingly critical for software development professionals.

# 2. Challenges in Working with Coding Agents

Despite their transformative potential, coding agents present significant challenges that practitioners must navigate. This section examines the primary difficulties encountered when integrating these tools into software development workflows.

## 2.1 Context Window Limitations

Perhaps the most fundamental constraint of current coding agents is the finite context window—the amount of information an agent can consider simultaneously. Large codebases frequently exceed these limits, forcing developers to make strategic decisions about what context to provide. This limitation manifests in several ways:

- **Incomplete understanding**: Agents may generate solutions that conflict with code outside their visible context
- **Fragmented reasoning**: Complex features spanning multiple files may be addressed piecemeal rather than holistically
- **Context management overhead**: Developers must invest effort in curating and prioritizing what information to surface

## 2.2 Hallucination and Confabulation

Coding agents can generate plausible-sounding but incorrect code, APIs, or explanations. This phenomenon, often termed "hallucination," poses particular risks in software development where incorrect code may compile and run but produce subtle bugs or security vulnerabilities. Common manifestations include:

- Inventing non-existent library functions or APIs
- Generating syntactically correct but semantically flawed logic
- Providing confident explanations of code behavior that do not match actual execution

## 2.3 Maintaining Consistency Across Sessions

Agents lack persistent memory across conversation sessions, requiring developers to re-establish context repeatedly. This limitation affects:

- **Long-running projects**: Architectural decisions and conventions must be restated
- **Team collaboration**: Individual team members' agent sessions remain siloed
- **Iterative development**: Previous design rationale is lost between sessions

## 2.4 Verification and Trust Calibration

Determining when to trust agent-generated code presents an ongoing challenge. Over-reliance can introduce bugs, while excessive skepticism negates productivity benefits. Developers must cultivate appropriate calibration—neither blindly accepting nor reflexively rejecting agent outputs.

## 2.5 Integration with Existing Workflows

Incorporating agents into established development practices—code review processes, testing pipelines, documentation standards—requires careful consideration. Agents may produce code that functions correctly but violates team conventions, or that passes tests but lacks appropriate documentation.

## 2.6 Security Vulnerabilities in Generated Code

A critical concern emerging from empirical research is the security quality of AI-generated code. Perry et al. (2023) conducted the first large-scale user study examining security implications of AI code assistants, finding that "participants who had access to an AI assistant based on OpenAI's codex-davinci-002 model wrote significantly less secure code than those without access" [1]. More concerning, "participants with access to an AI assistant were more likely to believe they wrote secure code than those without access to the AI assistant" [1], suggesting a dangerous overconfidence effect.

This finding is partially corroborated by Sandoval et al. (2023) in their study "Lost at C," which examined security implications in low-level programming contexts. While their results indicated smaller security impacts in C programming with pointer manipulations—"AI-assisted users produce critical security bugs at a rate no greater than 10% more than the control" [2]—the research nevertheless confirms that AI assistance does not improve, and may slightly degrade, code security.

The security implications manifest across several dimensions:

- **Vulnerability injection**: Generated code may contain common vulnerability patterns (SQL injection, buffer overflows, insecure deserialization)
- **Overconfidence bias**: Developers using AI assistants may perform less rigorous security review, assuming the AI would not generate vulnerable code
- **Training data contamination**: Models trained on public repositories may reproduce known vulnerable code patterns

## 2.7 Economic and Computational Cost Considerations

The deployment of coding agents at scale introduces significant cost considerations that organizations must carefully evaluate. These costs manifest across multiple dimensions:

**Inference costs**: API-based coding agents charge per token processed, meaning complex tasks requiring multiple iterations, long context windows, or extensive code generation can accumulate substantial costs. Organizations scaling agent usage across development teams face potentially significant operational expenses.

**Productivity-cost tradeoffs**: While Peng et al. (2023) demonstrated that developers with GitHub Copilot access "completed the task 55.8% faster than the control group" [3], organizations must weigh these productivity gains against subscription and inference costs, particularly for tasks where the speedup is less pronounced.

**Infrastructure requirements**: Self-hosted solutions require substantial computational infrastructure, including GPU clusters for inference, which introduces capital expenditure and operational complexity.

**Hidden costs of iteration**: Complex software engineering tasks, as demonstrated by the SWE-bench benchmark (Jimenez et al., 2023), reveal that current models struggle with real-world challenges—"the best-performing model, Claude 2, is able to solve a mere 1.96% of the issues" [4]. This suggests that for complex tasks, multiple expensive iterations may be required, amplifying costs without guaranteed success.

## 2.8 Cognitive Skill Atrophy and Developer Dependency

Perhaps the most insidious long-term risk of coding agent adoption is the potential for developer skill atrophy. As AI systems handle increasingly complex programming tasks, practitioners may experience degradation in fundamental skills.

**Foundational skill erosion**: Regular reliance on AI for routine coding tasks—algorithm implementation, API usage, debugging—may atrophy the neural pathways and mental models that undergird expert programming. Skills that require deliberate practice to maintain may deteriorate with disuse.

**Reduced deep understanding**: When agents generate solutions that developers accept without fully comprehending the underlying mechanisms, shallow understanding may supplant deep expertise. This becomes particularly problematic when debugging or extending AI-generated code.

**Problem decomposition atrophy**: The ability to break complex problems into tractable subproblems—a core programming skill—may weaken if developers habitually delegate this cognitive work to AI assistants.

**Labor market implications**: Eloundou et al. (2023) found that "around 80% of the U.S. workforce could have at least 10% of their work tasks affected by the introduction of LLMs, while approximately 19% of workers may see at least 50% of their tasks impacted" [5]. For software developers specifically, this exposure raises questions about how skill requirements and career development will evolve.

The analogy to GPS navigation is instructive: research has demonstrated that heavy GPS reliance degrades spatial reasoning capabilities. Similar effects may emerge in programming, where outsourcing cognitive work to AI could diminish the very expertise that makes developers effective collaborators with AI systems.

# 3. The Transformer Architecture and Its Implications for Coding Agents

To effectively work with coding agents, practitioners benefit from understanding the fundamental architecture that powers these systems. This section provides a technical overview of the Transformer architecture, its computational characteristics, and the practical implications for context management.

## 3.1 The Transformer Architecture

Modern coding agents are built upon the Transformer architecture, introduced by Vaswani et al. (2017) in the seminal paper "Attention Is All You Need" [6]. The Transformer represented a paradigm shift in sequence modeling by "dispensing with recurrence and convolutions entirely" [6] in favor of a mechanism called self-attention.

The core innovation of the Transformer is the **self-attention mechanism**, which allows the model to weigh the importance of different positions in an input sequence when processing each token. Formally, attention is computed as:

$$\text{Attention}(Q, K, V) = \text{softmax}\left(\frac{QK^T}{\sqrt{d_k}}\right)V$$

where $Q$ (queries), $K$ (keys), and $V$ (values) are linear projections of the input, and $d_k$ is the dimension of the key vectors. This mechanism enables the model to capture long-range dependencies that sequential models like RNNs struggle to learn.

The Transformer architecture consists of stacked layers, each containing:

1. **Multi-head attention**: Multiple attention mechanisms operating in parallel, allowing the model to attend to information from different representation subspaces
2. **Feed-forward networks**: Position-wise fully connected layers that process each position independently
3. **Layer normalization and residual connections**: Stabilizing mechanisms that enable training of deep networks

## 3.2 The Quadratic Cost of Attention

The self-attention mechanism, while powerful, introduces a fundamental computational constraint: **quadratic complexity** with respect to sequence length. For a sequence of length $n$, computing attention requires $O(n^2)$ time and space complexity.

This quadratic scaling has profound implications:

**Memory consumption**: Processing a context window of 100,000 tokens requires computing and storing an attention matrix with 10 billion elements. At 16-bit precision, this single matrix consumes approximately 20GB of memory—and this must be computed for every attention head in every layer.

**Computational cost**: Doubling the context length quadruples the computational requirements. This relationship explains why extending context windows from 4K to 128K tokens is not merely a 32× increase in cost, but approaches a 1,024× increase in attention computation.

**Inference latency**: Longer contexts directly translate to slower response times, as the model must attend to all previous tokens when generating each new token.

Choromanski et al. (2020) addressed this challenge with Performers, "Transformer architectures which can estimate regular (softmax) full-rank-attention Transformers with provable accuracy, but using only linear (as opposed to quadratic) space and time complexity" [7]. However, most production coding agents continue to use standard attention mechanisms, making context management a critical practical concern.

## 3.3 Context Window Dynamics and the "Lost in the Middle" Problem

Beyond raw computational cost, research has revealed qualitative limitations in how language models utilize long contexts. Liu et al. (2023) demonstrated in "Lost in the Middle" that "performance can degrade significantly when changing the position of relevant information" [8].

Their findings reveal a U-shaped attention pattern:

- **Primacy bias**: Models attend strongly to information at the beginning of the context
- **Recency bias**: Information near the end of the context receives disproportionate attention
- **Middle neglect**: "Performance is often highest when relevant information occurs at the beginning or end of the input context, and significantly degrades when models must access relevant information in the middle of long contexts" [8]

This phenomenon has direct implications for how developers should structure prompts and context when working with coding agents. Information critical to the task should be positioned strategically—at the beginning to establish context or at the end as a direct instruction—rather than buried in the middle of long inputs.

An et al. (2024) proposed information-intensive training to address this limitation, noting that the problem "stems from insufficient explicit supervision during the long-context training, which fails to emphasize that any position in a long context can hold crucial information" [9].

# 4. Best Practices for Context Management

Given the architectural constraints and empirical findings discussed above, effective use of coding agents requires deliberate context management strategies. This section synthesizes research findings into actionable practices.

## 4.1 Retrieval-Augmented Generation (RAG)

Rather than attempting to fit entire codebases into context windows, Retrieval-Augmented Generation offers a scalable alternative. Lewis et al. (2020) introduced RAG as a paradigm that "combine[s] pre-trained parametric and non-parametric memory for language generation" [10].

In the context of coding agents, RAG implementations typically:

1. **Index the codebase**: Create vector embeddings of code files, functions, and documentation
2. **Retrieve relevant context**: When processing a query, retrieve only the most semantically relevant code segments
3. **Augment the prompt**: Include retrieved context alongside the user's query

Gao et al. (2023) provide a comprehensive survey of RAG techniques, noting that "RAG synergistically merges LLMs' intrinsic knowledge with the vast, dynamic repositories of external databases" [11], addressing limitations around "hallucination, outdated knowledge, and non-transparent, untraceable reasoning processes" [11].

For coding agents, RAG offers several advantages:

- **Scalability**: Codebases of any size can be indexed and queried
- **Relevance**: Only pertinent code is included in the context
- **Currency**: The retrieval index can be updated as code changes
- **Traceability**: Retrieved sources can be cited, improving verifiability

## 4.2 Strategic Context Positioning

Given the "lost in the middle" phenomenon, practitioners should structure their prompts to place critical information in high-attention positions:

**Beginning of context**: Place foundational information that establishes the task domain
- Project architecture overview
- Relevant type definitions and interfaces
- Coding conventions and style guides

**End of context**: Position the specific task and any critical constraints
- The immediate coding task or question
- Required constraints or edge cases
- Expected output format

**Middle sections**: Use for supplementary information that supports but does not drive the task
- Example code patterns
- Related but not critical context
- Background documentation

## 4.3 Hierarchical Context Summarization

For large codebases, maintaining multiple levels of abstraction helps agents reason effectively:

1. **System-level summary**: High-level architecture, module relationships, technology stack
2. **Module-level context**: Purpose and interface of relevant modules
3. **File-level detail**: Specific implementations relevant to the current task

This hierarchical approach mirrors how human developers navigate unfamiliar codebases—starting with broad orientation before diving into specific details.

## 4.4 Iterative Context Refinement

Rather than attempting to provide all context upfront, effective workflows often involve:

1. **Initial broad query**: Start with minimal context to gauge the agent's baseline understanding
2. **Diagnostic probing**: Identify gaps in the agent's knowledge through targeted questions
3. **Targeted augmentation**: Provide specific context to address identified gaps
4. **Validation iteration**: Verify understanding before proceeding with implementation

This iterative approach conserves context window capacity for the most relevant information while building shared understanding incrementally.

## 4.5 Context Window Budgeting

Treat the context window as a finite resource requiring explicit allocation:

| Context Category | Suggested Allocation |
|------------------|---------------------|
| System prompt / instructions | 5-10% |
| Architecture / type context | 15-25% |
| Relevant code snippets | 30-40% |
| Examples and patterns | 10-15% |
| Current task specification | 10-20% |
| Buffer for response | 10-15% |

These allocations should be adjusted based on task complexity and the specific capabilities of the coding agent being used.

# 5. Effective Workflows with Coding Agents

Understanding how to structure interactions with coding agents is as important as understanding their technical foundations. This section examines empirically-grounded workflows, common anti-patterns, and best practices for productive human-agent collaboration.

## 5.1 The Bimodal Nature of Human-Agent Interaction

Barke et al. (2022) conducted a grounded theory analysis of programmer interactions with code-generating models, revealing that "interactions with programming assistants are bimodal" [12]:

**Acceleration Mode**: The programmer knows what to do next and uses the agent to get there faster. In this mode:
- The developer has a clear mental model of the solution
- The agent serves as a sophisticated autocomplete
- Value derives from reduced keystroke overhead
- Trust calibration is straightforward—the developer can readily evaluate suggestions

**Exploration Mode**: The programmer is unsure how to proceed and uses the agent to explore options. In this mode:
- The developer lacks a clear implementation path
- The agent serves as a brainstorming partner
- Value derives from surfacing possibilities
- Trust calibration is complex—the developer may lack expertise to evaluate suggestions

Recognizing which mode you're operating in fundamentally changes how you should interact with a coding agent. Conflating these modes—treating exploration as acceleration or vice versa—leads to frustration and suboptimal outcomes.

## 5.2 Anti-Patterns: How Not to Work with Coding Agents

### 5.2.1 The "Magic Wand" Anti-Pattern

**Description**: Treating the agent as an oracle that can transform vague intentions into working software with minimal guidance.

**Manifestation**: 
```
"Build me a web app that does X"
"Fix this code" (without context on what's broken)
"Make it better"
```

**Why it fails**: LLMs, despite impressive capabilities, are not mind readers. As Bubeck et al. (2023) observed in their analysis of GPT-4, while the model demonstrates remarkable capabilities, "GPT-4's performance is strikingly close to human-level performance" [13]—meaning it still requires the same kind of clear specification a human collaborator would need.

**Remedy**: Provide specific, actionable context including constraints, requirements, and success criteria.

### 5.2.2 The "Fire and Forget" Anti-Pattern

**Description**: Submitting a large, complex task and expecting a complete, correct solution in one pass.

**Manifestation**:
- Requesting implementation of entire features without intermediate checkpoints
- Copy-pasting generated code without review
- Not validating outputs against requirements

**Why it fails**: Complex tasks require decomposition, iteration, and verification. Even sophisticated agents struggle with tasks requiring "exploration, strategic lookahead, or where initial decisions play a pivotal role" [14] as Yao et al. (2023) demonstrated with Tree of Thoughts.

**Remedy**: Break tasks into verifiable subtasks; validate each step before proceeding.

### 5.2.3 The "Context Starvation" Anti-Pattern

**Description**: Providing insufficient context and expecting the agent to infer critical information.

**Manifestation**:
- Not sharing relevant code files
- Omitting type definitions and interfaces
- Assuming the agent knows project conventions

**Why it fails**: Agents cannot access information outside their context window. Every assumption you leave unstated is a potential source of error.

**Remedy**: Explicitly provide all information the agent needs—err on the side of over-specification.

### 5.2.4 The "Context Flooding" Anti-Pattern

**Description**: Dumping entire codebases into context without curation or prioritization.

**Manifestation**:
- Providing thousands of lines of marginally relevant code
- Including deprecated or commented-out code
- No summarization or hierarchical structure

**Why it fails**: The "lost in the middle" phenomenon [8] means relevant information buried in massive contexts may be ignored. Additionally, quadratic attention costs [7] make processing excessive context computationally expensive.

**Remedy**: Curate context deliberately; use hierarchical summarization; position critical information strategically.

### 5.2.5 The "Infinite Retry" Anti-Pattern

**Description**: Repeatedly re-prompting with the same or slightly modified requests hoping for different results.

**Manifestation**:
- "Try again"
- "That's not quite right, do it differently"
- Rephrasing the same question without adding information

**Why it fails**: Without diagnostic information about why previous attempts failed, the agent has no basis for improvement. Kim et al. (2023) showed that effective iteration requires the agent to "Recursively Criticize and Improve" [15]—but this requires specific feedback on what needs improvement.

**Remedy**: Provide specific feedback on what failed and why; include concrete examples of desired behavior.

## 5.3 Effective Workflows: How to Work with Coding Agents

### 5.3.1 The Plan-Decompose-Execute-Verify (PDEV) Workflow

Drawing from chain-of-thought prompting [16] and ReAct paradigms [17], effective coding workflows typically follow:

**1. Plan**: Establish high-level approach before implementation
```
"I need to implement user authentication. Before coding, outline 
the components we'll need and their interactions."
```

**2. Decompose**: Break the plan into tractable subtasks
```
"Let's start with the JWT token generation utility. It should:
- Accept a user ID and role
- Return a signed token with 1-hour expiry
- Use RS256 algorithm"
```

**3. Execute**: Implement individual components with full context
```
"Here's the User interface [provide interface]. Generate the 
token generation function following our project's error handling 
patterns [provide example]."
```

**4. Verify**: Validate outputs before integration
```
"Review this implementation against these requirements:
1. Token expires in exactly 1 hour
2. Payload includes userId and role
3. Uses RS256 signing
What issues do you identify?"
```

### 5.3.2 The Iterative Refinement Workflow

For exploratory work where requirements are unclear:

**1. Scaffold**: Request a minimal working structure
```
"Generate a basic Express.js route handler skeleton for 
user registration. Include only the structure—no implementation."
```

**2. Elaborate**: Incrementally add functionality
```
"Add input validation for email and password fields using 
the Joi library."
```

**3. Harden**: Address edge cases and error handling
```
"What edge cases should we handle? For each, show the 
handling code."
```

**4. Polish**: Refine for production quality
```
"Review for security vulnerabilities and performance issues."
```

### 5.3.3 The Rubber Duck Debugging Workflow

Leverage agents for diagnostic reasoning:

**1. Present the problem**:
```
"This function should return sorted unique values but returns 
duplicates. Here's the implementation: [code]"
```

**2. Request reasoning trace**:
```
"Walk through execution with input [1, 2, 2, 3] step by step."
```

**3. Identify divergence**:
```
"At which step does actual behavior diverge from expected?"
```

**4. Generate fix**:
```
"Propose a fix and explain why it addresses the root cause."
```

## 5.4 Interaction Patterns for Agentic Workflows

When working with autonomous coding agents like Claude Code that can execute multi-step tasks:

### 5.4.1 Establishing Guardrails

Before autonomous execution:
- Define clear boundaries on what files/systems can be modified
- Specify required human approval points
- Establish rollback procedures

### 5.4.2 Providing Navigation Context

Help agents understand codebase structure:
```
"The project uses a modular architecture:
- /src/core - Framework-agnostic business logic
- /src/adapters - External service integrations  
- /src/api - HTTP endpoint handlers
New features should follow this separation."
```

### 5.4.3 Specifying Success Criteria

Make verification possible:
```
"Implementation is complete when:
1. All existing tests pass
2. New tests cover edge cases X, Y, Z
3. No new linter warnings
4. Function handles null input gracefully"
```

### 5.4.4 Maintaining Human Oversight

Even with capable agents, maintain checkpoints:
- Review generated code before commit
- Validate tests actually test what they claim
- Verify documentation matches implementation
- Audit security-sensitive changes manually

---

# References

[1] N. Perry, M. Srivastava, D. Kumar, and D. Boneh, "Do Users Write More Insecure Code with AI Assistants?," in *Proceedings of the 2023 ACM SIGSAC Conference on Computer and Communications Security (CCS '23)*, pp. 2785–2799, November 2023. arXiv:2211.03622 [cs.CR].

[2] G. Sandoval, H. Pearce, T. Nys, R. Karri, S. Garg, and B. Dolan-Gavitt, "Lost at C: A User Study on the Security Implications of Large Language Model Code Assistants," in *Proceedings of the 32nd USENIX Security Symposium (USENIX Security '23)*, 2023. arXiv:2208.09727 [cs.CR].

[3] S. Peng, E. Kalliamvakou, P. Cihon, and M. Demirer, "The Impact of AI on Developer Productivity: Evidence from GitHub Copilot," arXiv:2302.06590 [cs.SE], February 2023.

[4] C. E. Jimenez, J. Yang, A. Wettig, S. Yao, K. Pei, O. Press, and K. Narasimhan, "SWE-bench: Can Language Models Resolve Real-World GitHub Issues?," in *Proceedings of the Twelfth International Conference on Learning Representations (ICLR '24)*, 2024. arXiv:2310.06770 [cs.CL].

[5] T. Eloundou, S. Manning, P. Mishkin, and D. Rock, "GPTs are GPTs: An Early Look at the Labor Market Impact Potential of Large Language Models," arXiv:2303.10130 [econ.GN], March 2023.

[6] A. Vaswani, N. Shazeer, N. Parmar, J. Uszkoreit, L. Jones, A. N. Gomez, L. Kaiser, and I. Polosukhin, "Attention Is All You Need," in *Advances in Neural Information Processing Systems 30 (NeurIPS 2017)*, 2017. arXiv:1706.03762 [cs.CL].

[7] K. Choromanski, V. Likhosherstov, D. Dohan, X. Song, A. Gane, T. Sarlos, P. Hawkins, J. Davis, A. Mohiuddin, L. Kaiser, D. Belanger, L. Colwell, and A. Weller, "Rethinking Attention with Performers," in *Proceedings of the Ninth International Conference on Learning Representations (ICLR '21)*, 2021. arXiv:2009.14794 [cs.LG].

[8] N. F. Liu, K. Lin, J. Hewitt, A. Paranjape, M. Bevilacqua, F. Petroni, and P. Liang, "Lost in the Middle: How Language Models Use Long Contexts," *Transactions of the Association for Computational Linguistics (TACL)*, 2023. arXiv:2307.03172 [cs.CL].

[9] S. An, Z. Ma, Z. Lin, N. Zheng, and J.-G. Lou, "Make Your LLM Fully Utilize the Context," arXiv:2404.16811 [cs.CL], April 2024.

[10] P. Lewis, E. Perez, A. Piktus, F. Petroni, V. Karpukhin, N. Goyal, H. Küttler, M. Lewis, W. Yih, T. Rocktäschel, S. Riedel, and D. Kiela, "Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks," in *Advances in Neural Information Processing Systems 33 (NeurIPS 2020)*, 2020. arXiv:2005.11401 [cs.CL].

[11] Y. Gao, Y. Xiong, X. Gao, K. Jia, J. Pan, Y. Bi, Y. Dai, J. Sun, M. Wang, and H. Wang, "Retrieval-Augmented Generation for Large Language Models: A Survey," arXiv:2312.10997 [cs.CL], December 2023.

[12] S. Barke, M. B. James, and N. Polikarpova, "Grounded Copilot: How Programmers Interact with Code-Generating Models," in *Proceedings of the ACM on Programming Languages (OOPSLA)*, 2022. arXiv:2206.15000 [cs.HC].

[13] S. Bubeck, V. Chandrasekaran, R. Eldan, J. Gehrke, E. Horvitz, E. Kamar, P. Lee, Y. T. Lee, Y. Li, S. Lundberg, H. Nori, H. Palangi, M. T. Ribeiro, and Y. Zhang, "Sparks of Artificial General Intelligence: Early experiments with GPT-4," arXiv:2303.12712 [cs.CL], March 2023.

[14] S. Yao, D. Yu, J. Zhao, I. Shafran, T. L. Griffiths, Y. Cao, and K. Narasimhan, "Tree of Thoughts: Deliberate Problem Solving with Large Language Models," in *Advances in Neural Information Processing Systems 36 (NeurIPS 2023)*, 2023. arXiv:2305.10601 [cs.CL].

[15] G. Kim, P. Baldi, and S. McAleer, "Language Models can Solve Computer Tasks," arXiv:2303.17491 [cs.CL], March 2023.

[16] J. Wei, X. Wang, D. Schuurmans, M. Bosma, B. Ichter, F. Xia, E. Chi, Q. Le, and D. Zhou, "Chain-of-Thought Prompting Elicits Reasoning in Large Language Models," in *Advances in Neural Information Processing Systems 35 (NeurIPS 2022)*, 2022. arXiv:2201.11903 [cs.CL].

[17] S. Yao, J. Zhao, D. Yu, N. Du, I. Shafran, K. Narasimhan, and Y. Cao, "ReAct: Synergizing Reasoning and Acting in Language Models," in *Proceedings of the Eleventh International Conference on Learning Representations (ICLR '23)*, 2023. arXiv:2210.03629 [cs.CL].

