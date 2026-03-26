# 🧵 Session Homogeneity

> **Problem we had:** one chat would start as config/admin, drift into tennis, then into memory design, and become impossible to reuse cleanly.

This page explains why `k-ai` now treats sessions as semantic objects, not just chat logs.

---

## What We Wanted

We wanted each session to feel like one coherent thread:

- one dominant intent
- one understandable summary
- one useful theme set
- one stable session type

Without this, old chats become junk drawers.

---

## The Fix

Each session now carries metadata:

```text
session_id
session_type   -> classic | meta
summary        -> one short sentence
themes[]       -> 3 to 8 useful anchors
message_count
updated_at
```

---

## Two Session Types

### `classic`

A real subject thread:

- math
- coding
- travel plan
- sports analysis
- one concrete topic

### `meta`

A control/admin thread:

- config changes
- memory management
- tool approval tweaks
- debugging the agent itself

This distinction matters because a "how do I tune approvals?" session should not be mixed with "analyse Miami Open".

---

## Session Switch Logic

When the user clearly changes dominant intent, the agent may propose `switch_session`.

ASCII flow:

```text
current session
    │
    ├─ user changes topic strongly
    │
    ├─ agent detects semantic drift
    │
    ├─ proposes switch_session
    │     summary + themes + type already seeded
    │
    ├─ user validates
    │
    ├─ old session is finalized
    │     digest refreshed
    │
    └─ new session starts clean
          same user turn continues there
```

This is why the user no longer has to remember "ah, I should have created a new thread."

---

## Why The Digest Is Recomputed

Digest generation happens at useful lifecycle points:

- early in the session
- during compaction
- on exit
- on explicit user request

It updates:

- `summary`
- `themes`
- `session_type`

So the session list stays useful without constant manual cleanup.

---

## Example

Bad old behavior:

```text
chat #17
  - tune config
  - fix OAuth
  - discuss tennis
  - ask current weather
  - redesign memory model
```

Good new behavior:

```text
chat #17  type=meta
  - tune config
  - fix OAuth
  - redesign memory model

chat #18  type=classic
  - analyse Miami Open 2026
  - discuss Alcaraz elimination
  - ask weather in Paris and Miami
```

That second structure is reusable.

---

## Why This Beats Classic LLM Chats

A classic chat usually gives you:

- linear history
- no explicit session type
- no semantic split
- no proactive hygiene

`k-ai` gives you:

- resumable threads
- visible metadata
- explicit switching
- less user discipline required

That is the real comfort gain.

---

## Visual Summary

```text
plain chat history
    -> grows
    -> mixes topics
    -> becomes noisy

k-ai session model
    -> classify
    -> digest
    -> switch when needed
    -> keep threads clean
```

See also:

- [🧠 Memory Model](memory-model.md)
- [🛠️ Tool Governance](tool-governance.md)
- [📄 session-lifecycle.txt](templates/session-lifecycle.txt)
