# 🧠 k-ai — Problem-First Docs

> **This is not API-first documentation.** It documents the real problems we hit while building `k-ai`, and the architectural moves we made to remove those problems for good.

No abstract theory. No fake examples. The pages below exist because the system used to fail, drift, confuse, or surprise us.

Live site:

- GitHub Pages: [kpihx.github.io/k-ai-docs](https://kpihx.github.io/k-ai-docs/)
- Source repo: [github.com/KpihX/k-ai-docs](https://github.com/KpihX/k-ai-docs)
- Main project repo: [github.com/kpihx/k-ai](https://github.com/kpihx/k-ai)
- Main project README: [github.com/KpihX/k-ai/blob/master/README.md](https://github.com/KpihX/k-ai/blob/master/README.md)
- Install guide: [github.com/KpihX/k-ai/blob/master/install/README.md](https://github.com/KpihX/k-ai/blob/master/install/README.md)

---

## What This Doc Solves

| Problem | Where to read |
|--------|---------------|
| "What exactly is sent to the LLM?" | [📦 Request Payload](request-payload.md) |
| "Why does this chat stay coherent instead of becoming a mess?" | [🧵 Session Homogeneity](session-homogeneity.md) |
| "How do tools stay visible, controllable, auditable, and justified?" | [🛠️ Tool Governance](tool-governance.md) |
| "How do native `SKILL.md` skills stay explicit instead of magical?" | [🧩 Skills Runtime](skills-runtime.md) |
| "How are lifecycle hooks structured without turning the core into spaghetti?" | [🪝 Hooks Runtime](hooks-runtime.md) |
| "How does MCP become a first-class runtime layer instead of a bolt-on?" | [🔌 MCP Runtime](mcp-runtime.md) |
| "How do `k-ai \"...\"`, `!`, `>`, `/?`, and focused local runners actually work?" | [⚡ Interaction Runtime](interaction-runtime.md) |
| "How does the terminal UI stay readable without hiding runtime details?" | [🔍 Runtime Transparency](runtime-transparency.md) |
| "How can config be changed live or edited directly without remembering YAML paths?" | [⚙️ Live Config](live-config.md) |
| "How do memory, external context, and session metadata fit together?" | [🧠 Memory Model](memory-model.md) |
| "Why do tests not pollute my machine?" | [🧪 Safety & Tests](safety-and-tests.md) |
| "How does installation really work, and where do install defaults live?" | [🚀 Installation](installation.md) |
| "What exactly is the runtime panel telling me?" | [🔍 Runtime Transparency](runtime-transparency.md) |
| "How does first boot / `/init` / assistant identity work?" | [👋 Onboarding and Identity](onboarding-and-identity.md) |
| "How do I recover from drift or broken state?" | [🩺 Doctor and Recovery](doctor-recovery.md) |
| "Does the Python API behave like the CLI or not?" | [🧩 Programmatic API](programmatic-api.md) |

---

## The Core Philosophy

`k-ai` is not "just a chat".

It is a terminal-first agent runtime with 5 explicit layers:

```text
┌──────────────────────────────────────────────────────────────┐
│  User surface                                                │
│  chat · slash commands · runtime panels · tool approvals     │
├──────────────────────────────────────────────────────────────┤
│  Session brain                                               │
│  prompt builder · tool loop · digest · switching · rollback  │
├──────────────────────────────────────────────────────────────┤
│  Tool layer                                                  │
│  memory · sessions · config · qmd · python · shell · search  │
├──────────────────────────────────────────────────────────────┤
│  Persistence                                                 │
│  session JSONL · memory JSON · config YAML                   │
├──────────────────────────────────────────────────────────────┤
│  Providers                                                   │
│  mistral · anthropic · ollama · gemini oauth · ...           │
└──────────────────────────────────────────────────────────────┘
```

The philosophy is simple:

- keep the system inspectable
- keep the tools explicit
- keep the sessions semantically clean
- prefer verification over model guesswork
- never force the user to remember hidden mechanics

---

## Read This First

If you want the shortest path to understanding the project:

1. Read [📦 Request Payload](request-payload.md)
2. Read [🧵 Session Homogeneity](session-homogeneity.md)
3. Read [🛠️ Tool Governance](tool-governance.md)
4. Read [🚀 Installation](installation.md) if you are setting up or redistributing the system

That is enough to understand most of the runtime behavior.

---

## Templates

Reusable visual artifacts live in [templates/](templates/README.md):

- request JSON skeleton
- session lifecycle ASCII flow
- tool approval resolution flow

They are there so the docs stay visual without repeating large blocks everywhere.

---

## Coverage Map

This doc set now covers:

- request payload structure
- sessions and semantic switching
- memory model
- tool governance and approvals
- skills runtime and progressive loading
- hooks runtime and lifecycle control
- MCP runtime, roots, and protocol-backed tools
- interaction runtime: ask, cwd, mixed input parsing, persistent local runners, and focus
- terminal UI rendering, runtime panels, and interaction flow
- live config and editor flows
- installation and install profiles
- runtime transparency
- onboarding and identity
- doctor and recovery
- safety and test isolation
- programmatic API behavior
