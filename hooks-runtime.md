# 🪝 Hooks Runtime

> **Problem we had:** without lifecycle hooks, policy enforcement either leaks into random code paths or stays impossible to audit.

`k-ai` now ships a native hooks layer that keeps execution external, structured, and observable.

---

## Discovery Model

The runtime looks for hooks in:

- `.k-ai/hooks`
- `.agents/hooks`
- `~/.agents/hooks`

Supported config files:

- `hooks.yaml`
- `hooks.yml`
- `hooks.json`

This keeps hooks portable across project, workspace, and user scope.

---

## Event Model

The hooks layer follows a Claude-style lifecycle naming approach.

Current supported events include:

- `SessionStart`
- `UserPromptSubmit`
- `PreToolUse`
- `PermissionRequest`
- `PostToolUse`
- `PostToolUseFailure`
- `Stop`

The important point is not the names themselves.
It is that the runtime treats them as explicit lifecycle seams instead of scattering policy in ad hoc branches.

---

## Contract

Hooks receive structured JSON on `stdin`.

That gives them:

- event name
- session context
- tool or request payload when relevant
- enough metadata to decide whether to allow, deny, warn, or enrich

The runtime then interprets the hook result under a strict policy:

- timeouts are bounded
- failures are surfaced
- blocking pre-hooks can actually stop unsafe execution

---

## Why It Matters

This design lets you move policy outward without making the core incoherent.

Examples:

- block a risky shell or MCP command before execution
- add audit context after a tool call
- enforce project-specific governance without editing Python

So hooks become a clean extension seam, not a side channel.

---

## Practical Surface

```text
/hooks
/hooks reload
```

And in config:

- `hooks.enabled`
- discovery roots
- timeouts
- fail modes

That means hooks are runtime-governed, inspectable, and not hidden behind startup-only behavior.

See also:

- [🛠️ Tool Governance](tool-governance.md)
- [⚙️ Live Config](live-config.md)
- [🧪 Safety & Tests](safety-and-tests.md)
