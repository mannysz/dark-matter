# 🌌 Dark Matter

> *Antigravity makes development fly; Dark Matter is the invisible infrastructure that holds the galaxy together.*

Dark Matter is an ecosystem of modular plugins and native terminal tooling built specifically for **Google Antigravity (`agy`)**.

---

## 📦 Packages & Documentation

Install only what you need, or install the full suite. Click any package below to view its complete documentation:

| Package | Purpose | Docs | Installation |
| :--- | :--- | :---: | :--- |
| **`@dark-matter/cli`** | The complete Dark Matter umbrella suite | [📖 Docs](./packages/cli/README.md) | `agy install @dark-matter/cli` |
| **`@dark-matter/neuron`** | Progressive Non-Linear Context Graph (PNG-RAG) memory engine with QMD hybrid vector search | [📖 Docs](./packages/neuron/README.md) | `agy install @dark-matter/neuron` |
| **`@dark-matter/statusline`** | Telemetry-aware, modular terminal status bar with slot reordering & custom components | [📖 Docs](./packages/statusline/README.md) | `agy install @dark-matter/statusline` |
| **`@dark-matter/milestone`** | Decoupled terminal task and milestone execution tracker | [📖 Docs](./packages/milestone/README.md) | `agy install @dark-matter/milestone` |

---

## 🚀 Deep-Dive Guides

* 🧠 [**Neuron** (`@dark-matter/neuron`)](./packages/neuron/README.md)  
  **The Problem**: AI coding agents suffer from amnesia across restarts and drown in token costs when trying to re-read everything.  
  **The Solution**: A lightweight, dependency-free cognitive memory architecture that keeps your agent perpetually aware of past architectural decisions, user preferences, and business goals—without consuming prompt tokens until recalled.

* 📊 [**Statusline** (`@dark-matter/statusline`)](./packages/statusline/README.md)  
  **The Problem**: Flying blind in the terminal without knowing how much quota is left, when rolling rate limits reset, or what mode the agent is in.  
  **The Solution**: A modular, telemetry-aware live status bar pinned to your terminal footer. Shows real-time quota countdown timers, active AI model, git branch, and context window %. Fully customizable on the fly with numbered slot reordering (`!statusline order 4 1 2 3`).

* 🧩 [**Custom Statusline Components**](./packages/statusline/COMPONENTS.md)  
  **The Problem**: Status bars are typically rigid and hardcoded, making it difficult to show project-specific metrics like battery, docker containers, or test statuses.  
  **The Solution**: An open, plug-and-play component contract. Drop any executable script into `~/.config/statusline/components/`—or just ask your agent to write one—and it is instantly discovered and ready to add.

* 🎯 [**Milestone** (`@dark-matter/milestone`)](./packages/milestone/README.md)  
  **The Problem**: Complex tasks derail when agents lose track of their step-by-step progress or bloat the conversation history with repetitive status updates.  
  **The Solution**: An ambient, decoupled task tracker that auto-discovers milestones across nested subdirectories, auto-advances current focus, and operates with zero LLM overhead.

---

## ⚡ Quick Start (Manual Setup)

```bash
# Clone the repository
git clone https://github.com/mannysz/dark-matter.git
cd dark-matter

# Link binaries to your local environment
ln -sf $(pwd)/packages/statusline/bin/statusline ~/.local/bin/statusline
ln -sf $(pwd)/packages/milestone/bin/milestone ~/.local/bin/milestone
ln -sf $(pwd)/packages/neuron/bin/neuron ~/.local/bin/neuron
```

---

## 🛠 Features

* **Zero-Latency Bang-Commands (`!`)**: Execute all utilities directly from your `agy` chat prompt (`!statusline`, `!neuron awake`, `!milestone status`) without triggering an LLM turn or consuming tokens.
* **Component Extensibility**: Drop executable scripts into `~/.config/statusline/components/` and they are discovered automatically.
* **Telemetry-Aware**: Live 5-hour quota, weekly quota, humanized countdown timers, and context window utilization.

---

## 📄 License
MIT © Manny Silva
