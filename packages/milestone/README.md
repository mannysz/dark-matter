# 🎯 @dark-matter/milestone `[Experimental]`

> [!WARNING]
> **Status: Experimental / Work in Progress**
> This module is actively undergoing major architectural expansion and design iterations. APIs, schemas, and CLI commands may change before the stable 1.0 release.

> Ambient terminal task and milestone tracking for **Google Antigravity (`agy`)**.

A lightweight, decoupled milestone tracking system and native terminal task engine. Tracks progress without polluting agent context or inflating LLM token counts.

---

## 1. Overview

* **State Storage**: `./.milestones.json` in the workspace root.
* **Zero LLM Token Usage**: Runs 100% locally via fast native JSON manipulation.
* **Upward Tree Traversal**: Auto-discovers milestones from any nested subdirectory.

---

## 2. CLI Reference (`milestone`)

| Command | Description | Example |
| :--- | :--- | :--- |
| `milestone set "<title>"` | Initialize or rename active milestone | `milestone set "M1: Authentication Engine"` |
| `milestone task add "<text>"` | Append a new pending task | `milestone task add "Write OAuth2 routes"` |
| `milestone task start <id>` | Mark task in-progress & update focus | `milestone task start 1` |
| `milestone task done <id>` | Mark task complete & advance focus | `milestone task done 1` |
| `milestone task remove <id>` | Remove a task from milestone | `milestone task remove 1` |
| `milestone focus "<text>"` | Explicitly set current focus text | `milestone focus "Debugging token expiry"` |
| `milestone status` | Pretty-print progress bar and task list | `milestone status` |
| `milestone json` | Print raw machine-readable JSON | `milestone json` |
| `milestone clear` | Remove `.milestones.json` | `milestone clear` |

---

## 3. Bang-Command Protocol (`!`)

Execute directly from inside your `agy` chat prompt without consuming an agent turn:
```bash
!milestone status
!milestone task add "Implement rate limiter"
!milestone task done 1
```
