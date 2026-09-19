# 🌌 Dark Matter

> *Antigravity makes development fly; Dark Matter is the invisible infrastructure that holds the galaxy together.*

Dark Matter is an ecosystem of modular plugins and native terminal tooling built specifically for **Google Antigravity (`agy`)**.

---

## 📦 Packages & Documentation

Install only what you need, or install the full suite. Click any package below to view its complete documentation:

| Package | Purpose | Docs | Installation |
| :--- | :--- | :---: | :--- |
| **`@dark-matter/cli`** | Complete umbrella suite delivering memory, live telemetry status bar, and task execution in one install. | [📖 Docs](./packages/cli/README.md) | Clone & run `./install.sh` |
| **`@dark-matter/neuron`** | Eliminates agent session amnesia with a dependency-free memory graph that recalls past context without token bloat. | [📖 Docs](./packages/neuron/README.md) | `agy plugin install ./packages/neuron` |
| **`@dark-matter/statusline`** | Eliminates blind terminal coding by pinning live quota countdowns, model badges, and git branch to your status bar. | [📖 Docs](./packages/statusline/README.md) | `agy plugin install ./packages/statusline` |
| **`@dark-matter/milestone`** `[Experimental]` | Prevents complex goals from derailing by ambiently tracking tasks and auto-advancing focus with zero LLM overhead. *(Work in progress)* | [📖 Docs](./packages/milestone/README.md) | `agy plugin install ./packages/milestone` |

---

## 🚀 Deep-Dive Guides

* 🧠 [**Neuron Architecture & Vector RAG** (`@dark-matter/neuron`)](./packages/neuron/README.md)  
  A 3-tier cognitive memory hierarchy (L1 Working Consciousness focus via CLI, L2 Context Graph JSON pointers, and L3 Episodic Markdown logs backed by QMD hybrid vector embeddings). Features asynchronous session consolidation, automated wake-up hooks, and bang-command query capabilities.

* 📊 [**Statusline Telemetry Engine & Reordering** (`@dark-matter/statusline`)](./packages/statusline/README.md)  
  High-speed subshell pipeline ingesting real-time JSON telemetry from `agy`'s stdin. Computes dynamic rolling quota resets (5-hour and 7-day windows), integer-rounded context utilization, and ANSI escape sequences. Supports fast 1-indexed slot reordering via `!statusline order 4 1 2 3`.

* 🧩 [**Extensible Component Contract**](./packages/statusline/COMPONENTS.md)  
  Open standard for third-party statusline widgets. Discovers both built-in components and user scripts dropped in `~/.config/statusline/components/`. Enforces a strict contract: metadata comment header (`# Description:`), JSON stdin ingestion, and isolated stdout rendering.

* 🎯 [**Milestone Tree Traversal & Task Engine** (`@dark-matter/milestone`) `[Experimental]`](./packages/milestone/README.md)  
  *(Work in Progress / Experimental)* Deterministic task execution engine operating over workspace `.milestones.json` files. Implements recursive upward directory traversal to detect project milestones from deep subdirectories, manages discrete task states (`not_started`, `in_progress`, `completed`), and dynamically drives focus markers.

---

## ⚡ Quick Start & Installation

### Option 1: Native Antigravity Plugin Import (`agy plugin install`)
Clone the repository and install packages directly into your Antigravity environment:

```bash
# Clone the Dark Matter monorepo
git clone https://github.com/mannysz/dark-matter.git ~/.dark-matter

# Install individual plugins into agy
agy plugin install ~/.dark-matter/packages/neuron
agy plugin install ~/.dark-matter/packages/statusline
agy plugin install ~/.dark-matter/packages/milestone

# Symlink CLI binaries into your path (~/.local/bin)
ln -sf ~/.dark-matter/packages/statusline/bin/statusline ~/.local/bin/statusline
ln -sf ~/.dark-matter/packages/milestone/bin/milestone ~/.local/bin/milestone
ln -sf ~/.dark-matter/packages/neuron/bin/neuron ~/.local/bin/neuron
```

### Option 2: One-Step Automated Installer
```bash
git clone https://github.com/mannysz/dark-matter.git ~/.dark-matter
~/.dark-matter/install.sh
```

---

## 🛠 Features

* **Zero-Latency Bang-Commands (`!`)**: Execute all utilities directly from your `agy` chat prompt (`!statusline`, `!neuron awake`, `!milestone status`) without triggering an LLM turn or consuming tokens.
* **Component Extensibility**: Drop executable scripts into `~/.config/statusline/components/` and they are discovered automatically.
* **Telemetry-Aware**: Live 5-hour quota, weekly quota, humanized countdown timers, and context window utilization.

---

## 📄 License
MIT © Manny Silva
