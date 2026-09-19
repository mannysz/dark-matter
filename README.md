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

* 🧠 [**Neuron Engine Memory Architecture**](./packages/neuron/README.md): 3-tier cognitive memory hierarchy (L1 Working Focus, L2 Context Graph JSON, L3 Episodic Logs & Vector Embeddings).
* 📊 [**Statusline Component Engine & Configuration**](./packages/statusline/README.md): Configure components (`mode`, `project`, `usage`, `model`) and reorder slots via `!statusline order 4 1 2 3`.
* 🧩 [**Custom Statusline Components Guide**](./packages/statusline/COMPONENTS.md): How to prompt Gemini/AGY to build custom components (Battery, Git, Runtimes).
* 🎯 [**Milestone & Task Tracking**](./packages/milestone/README.md): Ambient progress and task auto-advancement without polluting LLM token context.

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
