# 🔌 MCP Runtime

> **Problem we had:** protocol-backed tools are only valuable if they are managed like first-class runtime citizens, not bolted on as one-off exceptions.

`k-ai` now has a native MCP layer built on the official Python `mcp` SDK, with the official `filesystem` server as the first bundled MCP.

---

## What Is Implemented

The runtime foundation now covers:

- transports: `stdio`, `streamable_http`, `sse`
- dynamic MCP tool import
- resources
- resource templates
- prompts
- roots
- chat/admin surfaces

That means MCP is no longer "just another external binary".
It is a managed subsystem of the runtime.

---

## First Bundled Server: Filesystem

The first configured MCP is the official filesystem server:

- npm package: `@modelcontextprotocol/server-filesystem`
- binary: `mcp-server-filesystem`

The installer can provision it directly, and the runtime can then import tools such as:

- `read_text_file`
- `write_file`
- `edit_file`
- `list_allowed_directories`

This gives `k-ai` robust file operations without inventing a bespoke edit protocol from scratch.

---

## Roots And Safety

The runtime exposes roots explicitly to MCP servers.

In practice that means:

- the workspace root can be shared by default
- additional paths can be configured
- roots are part of the contract, not an accidental current directory leak

This is especially important for `filesystem`, where root boundaries are a real safety primitive.

---

## Dynamic Tool Import

Imported MCP tools become real runtime tools:

```text
mcp__filesystem__read_text_file
mcp__filesystem__write_file
mcp__filesystem__edit_file
```

So they inherit:

- approval policy
- runtime transparency
- tool proposals
- auditability

This is the key design choice:
MCP stays integrated into the existing tool kernel instead of bypassing it.

---

## Live Admin Surface

MCP can now be administered from chat:

```text
/mcp
/mcp tools
/mcp resources [server]
/mcp templates [server]
/mcp prompts [server]
/mcp probe <name> [command_or_package]
/mcp install <name> [package] [binary]
/mcp add-stdio <name> <command> [cwd]
/mcp add-http <name> <url> [streamable_http|sse]
/mcp enable <name>
/mcp disable <name>
/mcp remove <name>
/mcp reload
```

And the model can use internal admin tools such as:

- `mcp_server_probe`
- `mcp_server_install`
- `mcp_server_upsert`
- `mcp_server_remove`
- `mcp_resource_read`
- `mcp_prompt_get`

So MCP configuration is no longer trapped in YAML-only workflows.

---

## A Real Compatibility Lesson

One of the most important live findings during implementation was that not every MCP server exposes every optional protocol surface.

The official filesystem server, for example, can work fine while not implementing some list operations like a richer demo server might.

So the runtime now treats absent optional capabilities as compatibility variation, not as total server failure.

That is exactly the kind of detail that makes a protocol client feel robust instead of fragile.

---

## Practical Outcome

`k-ai` now has the right foundation:

- MCP is modular
- `filesystem` is only the first server, not a special case baked into the architecture
- future MCPs can be added without redesigning the core

See also:

- [🚀 Installation](installation.md)
- [🔍 Runtime Transparency](runtime-transparency.md)
- [🛠️ Tool Governance](tool-governance.md)
