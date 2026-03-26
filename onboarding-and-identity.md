# 👋 Onboarding and Identity

> **Problem we had:** the first launch of an agent is often awkward. The system knows nothing, the user knows little, and both sides pretend that is fine.

`k-ai` now treats first boot as a real phase.

---

## What Happens On First Real Boot

When there is:

- no meaningful prior session history
- no useful local internal memory

the system can trigger onboarding logic instead of pretending setup is already complete.

That flow can also be restarted explicitly:

```text
/init
```

or by asking the agent to initialize the system.

---

## What Onboarding Collects

Two identity anchors matter early:

1. how the assistant should be called
2. how the user wants to be called

The assistant name is persisted into prompt config.
The user-preferred name is persisted into internal memory.

---

## Why This Matters

This solves a subtle but real problem:

```text
identity should not be hardcoded forever
but it also should not be ephemeral every session
```

So `k-ai` uses:

- config for assistant identity
- internal memory for user identity

That split is deliberate.

---

## Mental Model

```text
assistant identity
   -> prompt-layer configuration

user preferred name
   -> persistent internal memory fact
```

---

## What Comes Next

After onboarding, the agent can present:

- what the system can do directly
- what can be done via slash commands
- what can be done just by asking in natural language

This is the right moment to introduce the surface area.
Not buried later in a README the user may never read.

---

## Visual Summary

```text
first boot
   │
   ├─ collect assistant name
   ├─ collect user preferred name
   ├─ persist both in the right layers
   └─ present system capabilities
```

See also:

- [🧠 Memory Model](memory-model.md)
- [⚙️ Live Config](live-config.md)
- [📦 Request Payload](request-payload.md)
