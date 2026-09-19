#!/usr/bin/env bash
set -e

# Dark Matter - Automated Installer for Antigravity (agy)
# Symlinks binaries into ~/.local/bin and imports plugins into agy.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"

PLUGINS_DIR="$HOME/.gemini/config/plugins"

mkdir -p "$BIN_DIR"
mkdir -p "$PLUGINS_DIR"

DEV_MODE=false
if [[ "$1" == "--dev" || "$1" == "--link" ]]; then
  DEV_MODE=true
fi

echo "🌌 Installing Dark Matter for Antigravity..."

# 1. Symlink CLI binaries into ~/.local/bin
echo "• Symlinking binaries to $BIN_DIR..."
ln -sf "$SCRIPT_DIR/packages/statusline/bin/statusline" "$BIN_DIR/statusline"
ln -sf "$SCRIPT_DIR/packages/milestone/bin/milestone" "$BIN_DIR/milestone"
ln -sf "$SCRIPT_DIR/packages/neuron/bin/neuron" "$BIN_DIR/neuron"
echo "  ✔ statusline, milestone, neuron linked to $BIN_DIR"

# 2. Register or link plugins with agy
if [ "$DEV_MODE" = true ]; then
  echo "• Linking packages directly for local development (--link)..."
  rm -rf "$PLUGINS_DIR/dark-matter-neuron" && ln -s "$SCRIPT_DIR/packages/neuron" "$PLUGINS_DIR/dark-matter-neuron"
  rm -rf "$PLUGINS_DIR/dark-matter-statusline" && ln -s "$SCRIPT_DIR/packages/statusline" "$PLUGINS_DIR/dark-matter-statusline"
  rm -rf "$PLUGINS_DIR/dark-matter-milestone" && ln -s "$SCRIPT_DIR/packages/milestone" "$PLUGINS_DIR/dark-matter-milestone"
  rm -rf "$PLUGINS_DIR/neuron-engine" && ln -s "$SCRIPT_DIR/packages/neuron" "$PLUGINS_DIR/neuron-engine"
  echo "  ✔ Packages symlinked to $PLUGINS_DIR (changes reflect immediately)"
elif command -v agy >/dev/null 2>&1; then
  echo "• Registering native Antigravity plugins..."
  agy plugin install "$SCRIPT_DIR/packages/neuron" >/dev/null 2>&1 || true
  agy plugin install "$SCRIPT_DIR/packages/statusline" >/dev/null 2>&1 || true
  agy plugin install "$SCRIPT_DIR/packages/milestone" >/dev/null 2>&1 || true
  echo "  ✔ Plugins registered with agy"
fi

echo ""
echo "✨ Dark Matter installation complete!"
echo "Try running:"
echo "  statusline list"
echo "  neuron awake"
echo "  milestone status"
