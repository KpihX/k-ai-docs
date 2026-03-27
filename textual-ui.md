# 🖥️ Textual TUI

`k-ai chat` now runs on a full-screen Textual application by default.

This is not just a new skin. It changes the UI model from:

- one linear terminal transcript
- inline approval prompts
- one prompt loop coupled to rendering

to:

- stable panes
- real modal dialogs
- explicit focus targets
- a dedicated multiline composer

---

## What Problem This Solves

The previous Rich + prompt-toolkit surface had reached a ceiling:

- tool approvals were visually mixed into the transcript
- long responses still required careful streaming compromises
- session lists, runtime transparency, conversation, and local activity all
  fought for the same scrolling column
- focus was simulated rather than spatially explicit

That was good enough for a premium CLI, but not for a terminal application that
should keep scaling with new panes, inspectors, focusable surfaces, and future
agent workflows.

---

## Current Layout

The Textual app is intentionally split into persistent zones:

```text
┌──────────────────────────────────────────────────────────────────────┐
│ Header                                                              │
├───────────────┬────────────────────────────────┬─────────────────────┤
│ Sessions      │ Streaming slot                 │ Runtime / Activity  │
│ DataTable     │ Transcript                     │ inspector tabs      │
│               │ RichLog                        │                     │
│               │ Composer (TextArea)            │                     │
├───────────────┴────────────────────────────────┴─────────────────────┤
│ Footer / key hints                                                  │
└──────────────────────────────────────────────────────────────────────┘
```

Meaning:

- the conversation stays readable
- approvals no longer pollute the transcript
- runtime transparency stays visible in its own pane
- session navigation is always one focus change away

---

## Approval Flow

Tool approvals are now true modals.

Before:

- proposal panel appended into the transcript
- raw `[y/n]` prompt below it
- result appended again below

Now:

- the transcript remains stable
- a modal screen captures focus
- the user approves or rejects
- the transcript only receives the meaningful outcome

This removes a major source of UI fatigue.

---

## Composer and Focus

The main input is a `TextArea`, not a single-line prompt.

Default bindings:

- `Ctrl+Enter` submit
- `Ctrl+J` focus composer
- `Ctrl+B` focus sessions
- `Ctrl+R` focus runtime
- `Ctrl+L` focus activity
- `Ctrl+Q` quit

The old slash commands still work, but they now live inside a real application
shell instead of driving the whole UI by themselves.

---

## Streaming Strategy

The TUI keeps a dedicated streaming slot above the transcript.

That means:

- the in-flight assistant answer is updated in place
- once complete, the final message is committed into the transcript log
- the transcript remains append-only

So we preserve the robustness of append-only rendering without forcing the user
to watch a fragile full-screen redraw.

---

## Classic Fallback

The legacy surface still exists:

```bash
k-ai chat --classic-ui
```

This is important for:

- fallback/debugging
- low-risk migration
- keeping the old runtime available if a terminal has unusual Textual issues

The goal is not to pretend the old UI never existed. The goal is to make the
new UI the default while keeping the runtime core shared.
