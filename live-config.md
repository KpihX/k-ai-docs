# ⚙️ Live Config Instead of YAML Editing

> **Problem we had:** editing `config.yaml` by hand for every small tweak is slow, error-prone, and breaks flow.

The answer was not "hide config".  
The answer was: **make config fully operable from chat and CLI**.

---

## What Can Be Changed Live

Examples:

- provider
- model
- max tokens
- temperature
- render mode
- tool display limits
- session limits
- config export paths

And this can happen from:

- shell CLI
- slash commands
- natural language via the agent

---

## Three Ways To Operate Config

### 1. Shell CLI

```bash
k-ai config sections
k-ai config show
k-ai config show --section models --section governance
k-ai config get -o config.yaml
k-ai config edit all
k-ai config edit ui
```

### 2. Slash commands

```text
/config sections
/config show section:models
/config edit governance
/set cli.theme mono
/provider mistral mistral-large-latest
```

### 3. Natural language

```text
set max_tokens to 4096
show me the governance section
switch provider to mistral
```

The agent then routes through the same internal tools.

---

## Why This Is Better

Because the config system becomes:

- visible
- inspectable
- mutable
- persistent when needed

instead of being a hidden file the user must remember to edit.

---

## Split Config Model

The built-in defaults are split into fragments:

```text
00-models.yaml
10-ui-prompts.yaml
20-sessions-memory.yaml
30-runtime-governance.yaml
```

This avoids one giant unreadable config file.

But the user can still export:

- one section
- several sections
- the whole merged config

---

## Practical Rule

Use live config for exploration.  
Persist when the setting becomes part of your stable environment.

---

## Editing Without Remembering Paths

One pain point with split YAML is obvious:

```text
split config is cleaner for the system
but harder for the human if file paths must be remembered
```

That is why `config edit` exists.

```text
k-ai config edit all
        │
        └─ opens the active persisted config

k-ai config edit governance
        │
        └─ opens 30-runtime-governance.yaml directly
```

Editor resolution order:

```text
config.editor
   ↓
K_AI_EDITOR
   ↓
VISUAL
   ↓
EDITOR
   ↓
nano
```

And during `scripts/install.sh`, `k-ai` can install `micro` and register it as
the default editor for this flow.

---

## Visual Summary

```text
chat / slash / shell
        │
        ▼
  internal config tools
        │
        ├─ inspect
        ├─ mutate live
        └─ persist if requested
```

See also:

- [🛠️ Tool Governance](tool-governance.md)
- [📄 Templates](templates/README.md)
