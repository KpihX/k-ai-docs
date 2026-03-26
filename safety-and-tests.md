# 🧪 Safety, Rollback, and Test Isolation

> **Problem we had:** agent systems can look stable until one bad edge case leaves partial history, broken session state, or files written into the wrong place.

This page explains the defensive layer.

---

## What We Protect Against

Real failure classes:

- LLM provider errors mid-turn
- tool success followed by model failure
- Ctrl+C during prompt, stream, or approval
- stale/malformed config
- tests accidentally touching the real `~/.k-ai`

---

## Runtime Safety

### Turn rollback

If a turn partially succeeds and then fails:

```text
assistant tool_calls appended
tool results appended
follow-up LLM fails
```

the whole turn is rolled back instead of leaving a broken function-call pair in history.

---

### Interruptions

The runtime distinguishes:

- prompt interruption
- generation interruption
- tool confirmation interruption

This is why `Ctrl+C` does not leave the system in a weird half-state.

---

## Test Safety

The suite is now deliberately hermetic.

### Fake HOME

Each test gets a temporary home:

```text
HOME=/tmp/pytest-.../home
```

So paths like:

- `~/.k-ai/config.yaml`
- `~/.k-ai/sessions`
- `~/.k-ai/tokens/...`

resolve into a disposable test space.

### Fake secrets

The suite also injects dummy API keys, so tests do not depend on your real shell secrets.

### Hermetic python_exec tests

`python_exec` unit tests do not rely on a real sandbox venv in your home directory.

That matters a lot:

- faster
- deterministic
- no local pollution

---

## Why This Matters

A green test suite is not enough.

It must also be:

- reproducible
- machine-independent
- non-destructive

Otherwise the suite is lying.

---

## Visual Summary

```text
test starts
   │
   ├─ fake HOME
   ├─ fake API keys
   ├─ temp cwd
   └─ temp stores only

=> no writes to the real ~/.k-ai
```

That is not polish. That is correctness.
