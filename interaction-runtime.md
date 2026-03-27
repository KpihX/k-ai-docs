# ⚡ Interaction Runtime

This page documents the input/runtime layer added on top of the chat
brain so that `k-ai` can handle:

- fast one-shot asks
- explicit working directories
- mixed multiline user documents
- persistent local shell and Python execution
- secure focus for interactive prompts

---

## What Problem This Solves

Before this layer, a user message was just one string sent to the model.

That was too weak for real terminal work:

- you could not ask a fast tool-less one-shot question from the CLI root
- you could not cleanly pin a chat session to one working directory
- you could not interleave local shell/Python execution with natural-language questions in one submitted batch
- interactive local prompts like `sudo` passwords had no principled PTY-backed path

The new interaction runtime fixes that by making the input surface explicit and
typed instead of magical.

---

## The Four Block Kinds

Inside `k-ai chat`, one submitted multiline document is parsed into ordered
blocks:

```text
!pwd
!git status --short
explique ce que tu vois
>import os
>os.getcwd()
/? rappelle-moi en une phrase ce que cela signifie
```

The parser turns this into:

1. shell block
2. LLM block
3. Python block
4. ephemeral LLM block

Rules:

- lines starting with `!` go to the persistent shell runner
- lines starting with `>` go to the persistent Python runner
- plain lines go to the main LLM turn
- a document starting with `/?` is treated as one tool-less, non-persistent quick question

The parser is deterministic and line-oriented. There is no hidden fuzzy routing
here.

---

## One-Shot Ask

You can now run:

```bash
k-ai "Que signifie MCP ?"
k-ai ask "Explique la différence entre hooks et skills"
k-ai -C ~/Work/AI/k_ai "Quel est le rôle de session.py ?"
```

Properties:

- no chat history
- no tool loop
- no runtime catalogs
- minimal system prompt + remembered facts only

This makes root ask much faster than opening a full chat session.

---

## Working Directory

`-C/--cwd` sets the session working directory explicitly:

```bash
k-ai chat -C ~/Work/AI/k_ai
k-ai ask -C '$HOME/Work/AI/k_ai' "Décris ce repo"
```

It supports:

- absolute paths
- relative paths
- `~`
- environment variables such as `$HOME`

Inside chat, `/cwd` shows the current working directory and `/cwd <path>` moves
the session runtime to a new one.

This cwd is shared by:

- user shell blocks
- user Python blocks
- `shell_exec`
- `python_exec`
- the roots used by local runtime decisions

---

## Persistent Runners

The local shell and Python execution surfaces are session-persistent.

That means:

- `!cd repo` changes the shell state for later `!pwd`
- `>x = 41` survives into later `>print(x + 1)`

This is implemented with PTY-backed runners rather than one subprocess per
block. The persistence is local to the current chat session.

By default, normal `!` and `>` blocks render through buffered result panels
instead of raw PTY passthrough. That keeps the UI clean even when login shells
emit prompt noise or terminal-control chatter.

Use `/focus shell` or `/focus python` when you want fully interactive PTY
control rather than clean buffered execution.

---

## Focus Mode

Interactive programs need real terminal input.

`k-ai` now exposes:

- `/focus shell`
- `/focus python`

When focused:

- keystrokes go directly to the runner PTY
- they are not added to chat history
- they are not persisted as memory
- they are not routed through the model
- shell echo is restored for the focused interaction, then tightened again when
  you return to normal buffered block execution

This is the correct path for:

- `sudo` password entry
- `yes/no` prompts
- Python `input()`

Exit focus with `Ctrl+]`.

---

## Streaming UI

Long model responses now stream append-only.

That means `k-ai` no longer keeps one ever-growing full-height Rich `Live`
panel for the assistant answer. Instead:

- the waiting phase still uses a light spinner
- the first visible content switches to a static assistant header
- completed content chunks are flushed progressively below it

This avoids the old failure mode where long answers could clip at the bottom,
blink on full-panel redraws, or remain invisible until enough content had been
buffered.

When you use the new default Textual TUI, this append-only strategy is coupled
with a dedicated streaming slot above the transcript, so the in-flight answer is
updated in place and only committed into the transcript when complete.

If needed, the previous prompt-toolkit + Rich surface remains available through:

```bash
k-ai chat --classic-ui
```

---

## Design Principle

The important architectural choice is that this is **not** implemented as a bag
of regexes inside `session.py`.

The runtime is split into dedicated modules:

- `k_ai.interaction.cwd`
- `k_ai.interaction.models`
- `k_ai.interaction.parser`
- `k_ai.interaction.runners`

So the session layer orchestrates the interaction runtime without owning all of
its parsing and PTY mechanics directly.
