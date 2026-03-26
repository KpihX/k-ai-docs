# 🛠️ Tool Governance

> **Problem we had:** once an agent has many tools, two bad futures appear quickly: either it becomes opaque, or it becomes annoying.

We wanted neither.

This page explains the approval system and why it exists.

---

## The Problem

A tool-enabled agent can easily become:

1. too powerful and surprising
2. too blocked and exhausting

Examples:

- asking approval for everything = unusable
- asking approval for nothing = unsafe

So the system needed policy, not ad-hoc behavior.

---

## The Model

Each tool has:

- category
- risk
- default policy
- justification panel
- optional session override
- optional global override
- protected or not

The catalog is the source of truth.

---

## Resolution Order

```text
protected hard rule
    > session override
    > global override
    > default risk policy
```

This matters because it makes the final decision explainable.

---

## Example

```text
tool: exa_search
risk: low
default: auto

=> no confirmation panel needed
=> proposal still shown
=> result still shown
```

```text
tool: shell_exec
risk: high
default: ask

=> proposal shown
=> approval required
=> result shown after validation
```

---

## Why Proposal + Result Both Matter

We deliberately show two separate moments:

### Tool Proposal

What the agent wants to do:

- tool name
- arguments
- policy source
- justification

The justification is now explicit by default.

If the model explains itself, that text is shown.

If the model emits only a bare tool call, `k-ai` derives a fallback:

```text
Use exa_search to search the web using the Exa semantic search API.
Main input: query=Masters 1000 Miami 2026...
```

So the user never validates a tool "blind".

### Tool Result

What actually happened:

- success/failure
- rendered result
- truncated history payload if needed

Without this split, tool usage becomes hard to audit.

---

## Why Admin Tools Stay Protected

Some tools govern the governance itself:

- `tool_policy_list`
- `tool_policy_set`
- `tool_policy_reset`

These remain protected on purpose.

Otherwise the agent could relax the very controls that keep it safe.

---

## The Real UX Goal

The user should be able to say:

```text
for low-risk tools, stop asking this session
```

or

```text
show me which tools are auto, ask, or protected
```

without touching YAML manually.

That is why policy inspection and mutation are both exposed through tools and slash commands.

---

## Visual Summary

```text
tool request
   │
   ├─ extract model rationale if present
   ├─ otherwise derive fallback justification
   ├─ read catalog
   ├─ resolve effective policy
   ├─ render proposal
   ├─ ask or auto-approve
   └─ render result
```

## Config Toggle

If you want a denser UI, you can disable the justification panel:

```yaml
cli:
  show_tool_rationale: false
```

Default:

```yaml
cli:
  show_tool_rationale: true
```

See also:

- [⚙️ Live Config](live-config.md)
- [📄 tool-approval-resolution.txt](templates/tool-approval-resolution.txt)
