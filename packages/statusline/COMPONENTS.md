# Statusline Components & Extensibility Guide

The **Carlinhos Statusline Engine** is a modular, high-speed CLI utility designed for the Google Antigravity (`agy`) prompt. It renders configurable components separated by delimiters (` | `) and supports plug-and-play user components.

---

## 1. Quick Start & CLI Bang-Commands

You can configure your statusline on the fly from the `agy` prompt using bang-commands (`!`):

```bash
# List all available components, active status, and descriptions
!statusline list

# Add one or more components
!statusline add model project

# Remove one or more components
!statusline rm usage

# Set explicit display order
!statusline order project model usage

# Reset to default configuration (model, usage, project)
!statusline reset
```

---

## 2. Built-In Components

| Component | Description | Output Example |
| :--- | :--- | :--- |
| **`model`** | Shows active AI model name and tier | `Gemini 3.8 Flash (Medium)` |
| **`usage`** | Rolling 5h quota, weekly quota, countdown timers, & context window % | `[5h: 52% (3h 45m), Wk: 85% (4d 1h), 16% ctx]` |
| **`project`**| Workspace directory name and git repository branch & dirty status | `carlinhos ⎇ main*` |

*(Note: The `milestone` component has been archived into `lib/statusline/components/milestone.archived` pending our upcoming standalone task framework).*

---

## 3. Creating Custom Components

You can create custom components in **`~/.config/statusline/components/`**. Any executable script placed here is automatically discovered by `!statusline list`.

### The Component Contract
Every component script must satisfy four simple rules:

1. **Location & Executable**:
   Place your script in `~/.config/statusline/components/<name>` and mark it executable (`chmod +x`).
2. **Metadata Header**:
   Include a `# Description: <one-liner>` comment in the first 5 lines of the script. This is shown in `!statusline list`.
3. **Standard Input (JSON Telemetry)**:
   The script receives `agy` telemetry JSON on standard input (`stdin`). You can extract data using `jq`.
4. **Standard Output**:
   The script prints its formatted string (with ANSI escape codes if desired) to `stdout`.
   - If the component has nothing to display in the current context, output nothing (`""`). The engine will automatically omit it and its delimiters.

---

## 4. Prompting Gemini / AGY to Create Custom Components

You can ask your agent directly:
> *"Create a new statusline component called `battery` that shows my macOS battery percentage and charging status."*

### Example 1: macOS Battery Component
Create `~/.config/statusline/components/battery`:
```bash
#!/usr/bin/env bash
# Description: Shows macOS battery percentage and charging state

BATT=$(pmset -g batt 2>/dev/null | grep -Eo '[0-9]+%' | head -1)
[ -z "$BATT" ] && exit 0

GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
RESET="\033[0m"

VAL=$(echo "$BATT" | tr -d '%')
if [ "$VAL" -ge 50 ]; then
  COLOR="$GREEN"
elif [ "$VAL" -ge 20 ]; then
  COLOR="$YELLOW"
else
  COLOR="$RED"
fi

printf "⚡ ${COLOR}%s${RESET}" "$BATT"
```
Make it executable and enable it:
```bash
chmod +x ~/.config/statusline/components/battery
!statusline add battery
```

### Example 2: Active Node.js / Python Version Component
Create `~/.config/statusline/components/runtime`:
```bash
#!/usr/bin/env bash
# Description: Displays active Node.js and Python runtime versions

DIM="\033[2m"
CYAN="\033[36m"
RESET="\033[0m"

NODE_VER=$(node -v 2>/dev/null)
if [ -n "$NODE_VER" ]; then
  printf "${DIM}node:${RESET}${CYAN}%s${RESET}" "$NODE_VER"
fi
```
Enable it:
```bash
chmod +x ~/.config/statusline/components/runtime
!statusline add runtime
```

---

## 5. Telemetry Schema (Input to Components)

On every prompt cycle, `agy` feeds a JSON object into standard input:
```json
{
  "workspace_path": "/Users/manny/repo/carlinhos",
  "cwd": "/Users/manny/repo/carlinhos",
  "model": {
    "id": "gemini-3-8-flash",
    "display_name": "Gemini 3.8 Flash (Medium)"
  },
  "context_window": {
    "total_tokens": 1048576,
    "used_tokens": 167772,
    "used_percentage": 16.0
  },
  "quota": {
    "gemini-5h": {
      "remaining_fraction": 0.52,
      "reset_in_seconds": 13500
    },
    "gemini-weekly": {
      "remaining_fraction": 0.85,
      "reset_in_seconds": 350000
    }
  }
}
```

Components can inspect any of these keys or read environment variables (e.g. `$STATUSLINE_CWD`, `$PWD`).
