# 🧩 Skills Runtime

> **Problem we had:** a large skill catalog is useless if the runtime either loads everything eagerly or routes unpredictably.

`k-ai` now uses a native `SKILL.md` runtime built to stay explicit, inspectable, and boringly deterministic on the local side.

---

## Discovery Model

By default, the runtime scans:

- `.k-ai/skills`
- `.agents/skills`
- `~/.agents/skills`

Discovery is recursive, but the runtime only indexes lightweight metadata first.

That means:

- startup stays cheap
- large catalogs stay manageable
- the model can see what exists without paying the full prompt cost of every skill body

---

## Loading Model

The runtime is progressive:

```text
catalog metadata
   │
   ├─ skill name
   ├─ scope
   └─ short description
        │
        └─ full SKILL.md body only when activated
```

This matters because "known skill" and "loaded skill" are intentionally different states.

The user can inspect both states live:

- `/skills`
- `/skills show <name>`
- `/skills active`
- `/skills reload`

---

## Routing Discipline

The local runtime stays intentionally conservative.

It only does two things deterministically:

- explicit activation when the user clearly names a skill
- carry-over for structurally weak continuation turns when the same task is clearly continuing

The broader semantic choice is delegated to the model through the visible catalog and the internal `activate_skill` tool.

This avoids the classic failure mode of brittle keyword routing.

---

## Why This Design

The runtime is deliberately close to the emerging `SKILL.md` ecosystem and the `agentskills.io` direction:

- file-based
- portable
- progressively disclosed
- metadata first
- body on demand

This keeps the implementation standard-friendly without forcing the user to trust invisible magic.

---

## Transparency

When a skill is actually loaded for a turn, the runtime can announce it and the panel can show the active skill context.

That solves an important ambiguity:

- catalog presence does not imply body injection
- active skill context means the `SKILL.md` content really participated in the turn

---

## Practical Surface

```text
/skills
/skills show kpihx-workspace
/skills active
/skills reload
```

And from the model side:

- `activate_skill`

So the user can inspect, the model can request, and the session layer remains the orchestrator instead of the owner of parsing logic.

See also:

- [⚙️ Live Config](live-config.md)
- [🔍 Runtime Transparency](runtime-transparency.md)
- [🛠️ Tool Governance](tool-governance.md)
