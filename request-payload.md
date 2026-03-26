# 📦 What Actually Gets Sent to the LLM

> **Problem we had:** when a system becomes tool-rich, it becomes easy to forget what is actually sent to the model. Then debugging becomes mystical.

This page shows the real structure of one request.

---

## The Real Question

When a turn is sent to the provider, where do these things go?

- the meta prompt
- external memory
- internal memory
- current session digest
- recent sessions
- custom runtime instructions
- tool results

Short answer:

```text
Everything contextual becomes messages[]
Tools become tools[]
Provider knobs stay at top level
```

---

## Mental Model

```text
Config prompts
   + external memory file
   + internal memory entries
   + active session profile
   + recent sessions (boot only)
   + custom session instructions
   = one big SYSTEM message

history messages
   + assistant tool calls
   + tool results
   = conversation body

tool definitions
   = separate tools[] field
```

---

## Example Request

This is the kind of JSON assembled before calling LiteLLM.

```json
{
  "model": "mistral/mistral-medium-latest",
  "messages": [
    {
      "role": "system",
      "content": "You are k-ai, an intelligent CLI chat assistant.\n\n## User Context\n- external profile or file-backed context\n\n## Remembered Facts\n- Always write memories in English even if the conversation is in French.\n- User is based in Palaiseau, France.\n- Favorite sports: racket sports.\n\n## Active Session Profile\n- id: 46774711\n- type: classic\n- summary: Analyse complète du Masters 1000 de Miami 2026.\n- themes: tennis, ATP, WTA, Miami Open\n\n## Custom Instructions\n- keep answers concise"
    },
    {
      "role": "user",
      "content": "parle moi de l'elimination de alcaraz"
    },
    {
      "role": "assistant",
      "content": "",
      "tool_calls": [
        {
          "id": "call_1",
          "type": "function",
          "function": {
            "name": "exa_search",
            "arguments": "{\"query\":\"Masters 1000 Miami 2026 Alcaraz elimination\",\"num_results\":8}"
          }
        }
      ]
    },
    {
      "role": "tool",
      "tool_call_id": "call_1",
      "name": "exa_search",
      "content": "- ATP Tour official result...\n- article...\n- recap..."
    }
  ],
  "stream": true,
  "temperature": 0.7,
  "max_tokens": 8192,
  "tools": [
    {
      "type": "function",
      "function": {
        "name": "exa_search",
        "description": "Search the web using Exa semantic search API",
        "parameters": {
          "type": "object"
        }
      }
    }
  ]
}
```

---

## Where Each Piece Comes From

| Piece | Source |
|------|--------|
| base meta-prompt | `prompts.identity` |
| external memory | `memory.external_file` content |
| internal memory | persistent `MemoryStore` entries |
| active session profile | `SessionStore` metadata |
| recent sessions | boot-only session table context |
| custom instructions | `/system` or runtime system prompt |
| tool definitions | tool registry → OpenAI-style function schema |
| tool call history | previous assistant/tool messages |

---

## Why This Design Matters

This was chosen to solve 3 concrete issues:

1. Hidden context drift  
   If memory or session metadata lived in secret side channels, debugging would be impossible.

2. Tool inconsistency  
   Tool usage has to appear in the same message history as the rest of the conversation.

3. Provider portability  
   Most providers already understand `messages[] + tools[]`; staying close to that wire shape keeps the system portable.

---

## Important Consequence

`k-ai` does **not** send memory as a magical special field.

It is injected into the `system` message on purpose.

That means:

- you can reason about it
- you can inspect it
- you can reproduce it
- you can document it

That is a feature, not a limitation.

---

## Visual Summary

```text
SYSTEM
  ├─ identity prompt
  ├─ external memory
  ├─ internal memory
  ├─ active session profile
  ├─ recent sessions (sometimes)
  └─ custom instructions

HISTORY
  ├─ user
  ├─ assistant
  ├─ assistant tool_calls
  └─ tool results

SEPARATE FIELD
  └─ tools[]
```

See also:

- [🧵 Session Homogeneity](session-homogeneity.md)
- [🧠 Memory Model](memory-model.md)
- [📄 request-payload.example.json](templates/request-payload.example.json)
