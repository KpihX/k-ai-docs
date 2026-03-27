# 🔍 Runtime Transparency

> **Problem we had:** many agent systems feel intelligent only because the user cannot see what they are doing.

`k-ai` goes the other direction:
show the runtime state as part of the product.

---

## What The Panel Exposes

The runtime surface can show:

- provider
- model
- auth mode
- token source
- stream mode
- estimated or provider-reported token usage
- context window
- compaction threshold
- active session metadata
- active skill context
- discovered MCP runtime state

This is not ornamental UI.
It is the debugging surface of the system.

---

## Why It Matters

Without runtime transparency, the user cannot easily tell:

- which provider is actually active
- whether the session is near compaction
- whether auth came from API key or OAuth
- whether token counts are exact or estimated
- whether a tool-rich run is behaving as expected
- whether skills were merely known or actually loaded
- whether MCP servers/tools/resources are really available

So the panel reduces ambiguity before ambiguity turns into bugs.

---

## Practical Examples

```text
Context  8,225 / 128,000 tok
```

This tells you:

- current load
- model window
- whether compaction pressure is near

```text
Auth  oauth
```

This tells you you are not using a static API key path.

```text
Type  meta
```

This tells you the current session is an admin/control thread, not a topic thread.

```text
Skills  kpihx-soul, kpihx-duties
Catalog  19 discovered
```

This tells you the difference between:

- currently active session skill context
- total discovered catalog size

```text
MCP  1 server | 12 tools | 0 resources | 0 prompts
```

This tells you the protocol-backed runtime is actually live, not just configured on disk.

---

## Visual Summary

```text
runtime panel
   │
   ├─ provider/model truth
   ├─ auth truth
   ├─ token/context truth
   ├─ session truth
   ├─ skill truth
   └─ MCP truth
```

That is why the product feels inspectable instead of mystical.

See also:

- [📦 Request Payload](request-payload.md)
- [🧵 Session Homogeneity](session-homogeneity.md)
- [🧩 Skills Runtime](skills-runtime.md)
- [🔌 MCP Runtime](mcp-runtime.md)
- [🩺 Doctor & Recovery](doctor-recovery.md)
