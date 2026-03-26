# 🧠 Memory Model

> **Problem we had:** memory was too coarse. One big blob meant weak retrieval, weak updates, and awkward deletion.

The fix was not "more memory". It was **better memory shape**.

---

## Two Memory Sources

### External memory

Read-only context file injected into the system prompt:

```text
memory.external_file
```

Use it for broad profile/context that should always be present.

### Internal memory

Mutable persistent entries managed by tools:

```text
memory_add
memory_list
memory_remove
```

Use it for discrete facts learned over time.

---

## Why Atomic Facts Matter

This was a real design correction.

Bad approach:

```text
one memory entry
  - writes in English
  - user lives in Palaiseau
  - likes racket sports
```

Good approach:

```text
#3 Memories are stored atomically...
#4 Always write memories in English...
#5 User is based in Palaiseau...
#6 Favorite sports: racket sports...
```

Why this is better:

- remove one fact without touching others
- retrieve one fact precisely
- update one fact cleanly
- keep IDs meaningful

---

## Where Memory Appears At Runtime

Inside the system message:

```text
## User Context
[external memory]

## Remembered Facts
- fact 1
- fact 2
- fact 3
```

So memory is:

- persistent
- inspectable
- not hidden

---

## Design Rule

If a fact may need future independent deletion or update, it should be its own entry.

That is the practical rule.

---

## Example Workflow

```text
user: remember these 3 things
agent: memory_add x3

later:
user: update only the location
agent:
  - memory_remove #5
  - memory_add "User is based in ..."
```

That is impossible to do cleanly if all facts were packed into one entry.

---

## What Memory Is Not

Memory is not:

- a replacement for live verification
- a place for volatile facts that should be re-checked
- a hidden fine-tuning layer

The memory stores stable user context.
The tools verify changing reality.

That distinction is important.

---

## Visual Summary

```text
external memory
    -> broad, always-on, read-only

internal memory
    -> atomic, mutable, ID-based

live reality
    -> verify with tools, not memory
```

See also:

- [📦 Request Payload](request-payload.md)
- [🛠️ Tool Governance](tool-governance.md)
