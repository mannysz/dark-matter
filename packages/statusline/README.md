# Live TUI Statusline System

A modular, extensible terminal statusline engine designed for Antigravity (`agy`).

---

## 1. Overview

The statusline system provides ambient, real-time visibility into active AI model parameters, live quotas, context window usage, and workspace/git repository status directly at the bottom of the terminal screen.

* **CLI Binary**: `bin/statusline` (symlinked to `~/.local/bin/statusline`).
* **Component Library**: `lib/statusline/components/`.
* **User Custom Components**: `~/.config/statusline/components/`.
* **Renderer**: Invoked automatically by `agy` via `settings.json`.

---

## 2. Dynamic Bang-Commands (`!statusline`)

You can inspect and configure your statusline on the fly directly from the prompt using the `!` shell escape with zero model latency and zero restarts:

```bash
# List all available components, active status, and descriptions
!statusline list

# Add components to active statusline
!statusline add model usage project

# Remove components from statusline
!statusline rm usage

# Reorder active components by slot number (easiest) or name
!statusline order 4 1 2 3
!statusline order usage model mode project

# Reset statusline to default configuration (model, mode, project, usage)
!statusline reset
```

---

## 3. Built-In Components

| Component | Description | Output Example |
| :--- | :--- | :--- |
| **`mode`** | Active cycle mode (`plan`, `accept-edits`, `normal`) | `✍ accept-edits` or `⚡ plan` |
| **`model`** | Active AI model name and tier | `Gemini 3.8 Flash (Medium)` |
| **`usage`** | Rolling 5h quota, weekly quota, countdown timers, & context window % | `[5h: 52% (3h 45m), Wk: 85% (4d 1h), 16% ctx]` |
| **`project`** | Directory name and git branch/dirty status | `carlinhos ⎇ main*` |

---

## 4. Extensibility & Custom Components

Anyone can create custom statusline components or prompt Gemini/agy to build them. See [`STATUSLINE_COMPONENTS.md`](./STATUSLINE_COMPONENTS.md) for full developer documentation and prompt recipes.

---

## 5. Standalone Milestone Tracker (`milestone`)

Milestone and task execution tracking is managed independently via the standalone `milestone` CLI binary:

```bash
milestone set "M1: New Feature"
milestone task add "Write unit tests"
milestone task start 1
milestone task done 1
milestone status
```
*(Its previous statusline widget has been archived into `lib/statusline/components/milestone.archived` in preparation for an expanded task framework).*
