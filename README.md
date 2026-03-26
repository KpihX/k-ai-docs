# 🧠 k-ai — Problem-First Docs

> **This is not API-first documentation.** It documents the real problems we hit while building `k-ai`, and the architectural moves we made to remove those problems for good.

No abstract theory. No fake examples. The pages below exist because the system used to fail, drift, confuse, or surprise us.

Live site:

- GitHub Pages: `https://kpihx.github.io/k-ai-docs/`
- Source repo: `https://github.com/KpihX/k-ai-docs`

---

## What This Doc Solves

| Problem | Where to read |
|--------|---------------|
| "What exactly is sent to the LLM?" | [📦 Request Payload](request-payload.md) |
| "Why does this chat stay coherent instead of becoming a mess?" | [🧵 Session Homogeneity](session-homogeneity.md) |
| "How do tools stay visible, controllable, auditable, and justified?" | [🛠️ Tool Governance](tool-governance.md) |
| "How can config be changed live or edited directly without remembering YAML paths?" | [⚙️ Live Config](live-config.md) |
| "How do memory, external context, and session metadata fit together?" | [🧠 Memory Model](memory-model.md) |
| "Why do tests not pollute my machine?" | [🧪 Safety & Tests](safety-and-tests.md) |

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

That is enough to understand most of the runtime behavior.

---

## Templates

Reusable visual artifacts live in [templates/](templates/README.md):

- request JSON skeleton
- session lifecycle ASCII flow
- tool approval resolution flow

They are there so the docs stay visual without repeating large blocks everywhere.
