# 🌌 Dark Matter

> *Antigravity makes development fly; Dark Matter is the invisible infrastructure that holds the galaxy together.*

Dark Matter is an ecosystem of modular plugins and native terminal tooling built specifically for **Google Antigravity (`agy`)**.

---

## 📦 Packages

Install only what you need, or install the full suite:

| Package | Purpose | Installation |
| :--- | :--- | :--- |
| **`@dark-matter/neuron`** | Progressive Non-Linear Context Graph (PNG-RAG) memory engine with QMD vector search | `agy install @dark-matter/neuron` |
| **`@dark-matter/statusline`** | Telemetry-aware, modular terminal status bar with slot reordering & custom components | `agy install @dark-matter/statusline` |
| **`@dark-matter/milestone`** | Decoupled terminal task and milestone execution tracker | `agy install @dark-matter/milestone` |
| **`@dark-matter/cli`** | The complete Dark Matter umbrella suite | `agy install @dark-matter/cli` |

---

## ⚡ Quick Start

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

* **Zero-Latency Terminal Bang-Commands (`!`)**: Execute all utilities directly from your prompt (`!statusline`, `!neuron awake`, `!milestone status`) without consuming tokens or invoking LLM turns.
* **Component Extensibility**: Drop executable scripts into `~/.config/statusline/components/` and they are discovered automatically.
* **Rolling Quota & Reset Timers**: Ingests real-time 5-hour and weekly quota telemetry.

---

## 📄 License
MIT © Manny Silva
