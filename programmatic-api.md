# 🧩 Programmatic API and Embedding

> **Problem we had:** many CLI-first LLM systems become second-class citizens when used from Python.

`k-ai` tries to keep the programmatic path aligned with the interactive one.

---

## The Principle

The Python API should not be a separate toy runtime.

It should reuse the same core ideas:

- same config model
- same session model
- same tool layer
- same safety rules

---

## Why This Matters

If programmatic calls and CLI calls diverge, you get:

- different behavior
- different rollback guarantees
- different session history semantics
- different debugging expectations

That quickly becomes impossible to reason about.

---

## What Was Fixed

One important correction was aligning programmatic send flows with the interactive lifecycle.

So `send()` and `send_with_tools()` now follow the same guarantees around:

- finalization
- rollback on failed follow-up
- coherent tool call/result history

That is the difference between "API exists" and "API is trustworthy".

---

## Mental Model

```text
CLI chat
   │
   ├─ same config
   ├─ same session store
   ├─ same memory store
   └─ same tool execution semantics

Python API
   │
   └─ same core runtime, different surface
```

---

## When To Use It

Use the programmatic path when:

- embedding `k-ai` into a script
- building higher-level automation around sessions
- testing behaviors without the TTY UI
- reusing the same runtime in another Python system

---

## Visual Summary

```text
surface differs
brain stays the same
```

That is the only sane long-term design.

See also:

- [📦 Request Payload](request-payload.md)
- [🧵 Session Homogeneity](session-homogeneity.md)
- [🧪 Safety & Tests](safety-and-tests.md)
