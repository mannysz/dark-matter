#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATUSLINE_BIN="$(cd "$SCRIPT_DIR/../bin" && pwd)/statusline"
LIB_COMP_DIR="$(cd "$SCRIPT_DIR/../lib/statusline/components" && pwd)"

TMP_DIR="$(mktemp -d /tmp/statusline-modular-test.XXXXXX)"
trap 'rm -rf "$TMP_DIR"' EXIT

# Isolate statusline configuration
export HOME="$TMP_DIR"
mkdir -p "$HOME/.gemini/antigravity-cli"
mkdir -p "$HOME/.config/statusline/components"

echo "=== Running Modular Statusline Test Suite ==="

# -------------------------------------------------------------
# Unit Test 1: Isolated Model Component
# -------------------------------------------------------------
echo "• Test 1: Model Component Execution"
OUT_MODEL=$(printf '{"model":{"display_name":"Gemini 3.8 Pro"}}' | "$LIB_COMP_DIR/model")
if [[ "$OUT_MODEL" != *"Gemini 3.8 Pro"* ]]; then
  echo "FAIL: Model component failed. Got: '$OUT_MODEL'"
  exit 1
fi
echo "  ✔ Model component outputs correct name"

# -------------------------------------------------------------
# Unit Test 2: Isolated Usage Component
# -------------------------------------------------------------
echo "• Test 2: Usage Component Execution (Quotas + Context + Countdown)"
MOCK_USAGE='{"quota":{"gemini-5h":{"remaining_fraction":0.45,"reset_in_seconds":3600},"gemini-weekly":{"remaining_fraction":0.80,"reset_in_seconds":172800}},"context_window":{"used_percentage":6.51702880859375}}'
OUT_USAGE=$(printf '%s' "$MOCK_USAGE" | "$LIB_COMP_DIR/usage")
if [[ "$OUT_USAGE" != *"5h:"* ]] || [[ "$OUT_USAGE" != *"45%"* ]] || [[ "$OUT_USAGE" != *"(1h)"* ]] || [[ "$OUT_USAGE" != *"Wk:"* ]] || [[ "$OUT_USAGE" != *"80%"* ]] || [[ "$OUT_USAGE" != *"(2d)"* ]] || [[ "$OUT_USAGE" != *"7%"* ]] || [[ "$OUT_USAGE" != *"ctx"* ]]; then
  echo "FAIL: Usage component failed. Got: '$OUT_USAGE'"
  exit 1
fi
echo "  ✔ Usage component parses quotas, countdowns, and context window"

# -------------------------------------------------------------
# Unit Test 2b: Isolated Mode Component
# -------------------------------------------------------------
echo "• Test 2b: Mode Component Execution"
OUT_MODE_PLAN=$(printf '{"cycle_mode":"plan"}' | "$LIB_COMP_DIR/mode")
if [[ "$OUT_MODE_PLAN" != *"plan"* ]]; then
  echo "FAIL: Mode component failed for plan. Got: '$OUT_MODE_PLAN'"
  exit 1
fi
OUT_MODE_EDIT=$(printf '{"cycle_mode":"accept-edits"}' | "$LIB_COMP_DIR/mode")
if [[ "$OUT_MODE_EDIT" != *"accept-edits"* ]]; then
  echo "FAIL: Mode component failed for accept-edits. Got: '$OUT_MODE_EDIT'"
  exit 1
fi
echo "  ✔ Mode component outputs styled mode badge"

# -------------------------------------------------------------
# Unit Test 3: Isolated Project Component (Git Repo & Non-Git)
# -------------------------------------------------------------
echo "• Test 3: Project Component Execution"
# Inside git repo
GIT_REPO="$TMP_DIR/my-git-app"
mkdir -p "$GIT_REPO"
git init -b main "$GIT_REPO" >/dev/null 2>&1
touch "$GIT_REPO/file.txt"
git -C "$GIT_REPO" add . >/dev/null 2>&1
git -C "$GIT_REPO" -c user.name="Tester" -c user.email="test@test.com" commit -m "init" >/dev/null 2>&1

OUT_GIT=$(export STATUSLINE_CWD="$GIT_REPO"; echo '{}' | "$LIB_COMP_DIR/project")
if [[ "$OUT_GIT" != *"my-git-app"* ]] || [[ "$OUT_GIT" != *"main"* ]]; then
  echo "FAIL: Project component inside git failed. Got: '$OUT_GIT'"
  exit 1
fi

# Dirty state
touch "$GIT_REPO/dirty.txt"
OUT_GIT_DIRTY=$(export STATUSLINE_CWD="$GIT_REPO"; echo '{}' | "$LIB_COMP_DIR/project")
if [[ "$OUT_GIT_DIRTY" != *"*"* ]]; then
  echo "FAIL: Project component dirty detection failed. Got: '$OUT_GIT_DIRTY'"
  exit 1
fi

# Non-git folder
PLAIN_DIR="$TMP_DIR/plain-workspace"
mkdir -p "$PLAIN_DIR"
OUT_PLAIN=$(export STATUSLINE_CWD="$PLAIN_DIR"; echo '{}' | "$LIB_COMP_DIR/project")
if [[ "$OUT_PLAIN" != *"plain-workspace"* ]] || [[ "$OUT_PLAIN" == *"⎇"* ]]; then
  echo "FAIL: Project component non-git failed. Got: '$OUT_PLAIN'"
  exit 1
fi
echo "  ✔ Project component accurately handles git and non-git directories"

# -------------------------------------------------------------
# Test 4: CLI Subcommands (reset, list, add, rm, order)
# -------------------------------------------------------------
echo "• Test 4: CLI Component Management (reset, list, add, rm, order)"

# Reset
"$STATUSLINE_BIN" reset >/dev/null
LIST_OUT=$("$STATUSLINE_BIN" list)
if [[ "$LIST_OUT" != *"mode"* ]] || [[ "$LIST_OUT" != *"model"* ]] || [[ "$LIST_OUT" != *"usage"* ]] || [[ "$LIST_OUT" != *"project"* ]]; then
  echo "FAIL: Reset/list failed. Got: '$LIST_OUT'"
  exit 1
fi

# Remove component
"$STATUSLINE_BIN" rm usage >/dev/null
LIST_AFTER_RM=$("$STATUSLINE_BIN" list)
if [[ "$LIST_AFTER_RM" == *"usage        ✔ active"* ]]; then
  echo "FAIL: Usage was not deactivated after rm. Got: '$LIST_AFTER_RM'"
  exit 1
fi

# Add component back
"$STATUSLINE_BIN" add usage >/dev/null
LIST_AFTER_ADD=$("$STATUSLINE_BIN" list)
if [[ "$LIST_AFTER_ADD" != *"usage        ✔ active"* ]]; then
  echo "FAIL: Usage was not reactivated after add. Got: '$LIST_AFTER_ADD'"
  exit 1
fi

# Order components by names
"$STATUSLINE_BIN" order project model >/dev/null
ORDER_OUT=$("$STATUSLINE_BIN" list)
if [[ "$ORDER_OUT" != *"Active Order: [1] project  [2] model"* ]]; then
  echo "FAIL: Named order change failed. Got: '$ORDER_OUT'"
  exit 1
fi

# Order components by numbers
"$STATUSLINE_BIN" order 2 1 >/dev/null
ORDER_NUM_OUT=$("$STATUSLINE_BIN" list)
if [[ "$ORDER_NUM_OUT" != *"Active Order: [1] model  [2] project"* ]]; then
  echo "FAIL: Numeric order change failed. Got: '$ORDER_NUM_OUT'"
  exit 1
fi
echo "  ✔ CLI management commands (reset, list, add, rm, order by name & index) function correctly"

# -------------------------------------------------------------
# Test 5: Dynamic Custom User Component Discovery
# -------------------------------------------------------------
echo "• Test 5: User Extensibility & Discovery (~/.config/statusline/components)"

CUSTOM_SCRIPT="$HOME/.config/statusline/components/battery"
cat << 'EOF' > "$CUSTOM_SCRIPT"
#!/usr/bin/env bash
# Description: Shows device battery percentage
printf "\033[32m⚡ 100%%\033[0m"
EOF
chmod +x "$CUSTOM_SCRIPT"

LIST_CUSTOM=$("$STATUSLINE_BIN" list)
if [[ "$LIST_CUSTOM" != *"battery"* ]] || [[ "$LIST_CUSTOM" != *"Shows device battery percentage"* ]]; then
  echo "FAIL: Custom component discovery failed. Got: '$LIST_CUSTOM'"
  exit 1
fi

# Add custom component
"$STATUSLINE_BIN" add battery >/dev/null

RENDER_CUSTOM=$(printf '{"model":{"display_name":"TestModel"}}' | "$STATUSLINE_BIN")
if [[ "$RENDER_CUSTOM" != *"⚡ 100%"* ]]; then
  echo "FAIL: Custom component not rendered in pipeline: '$RENDER_CUSTOM'"
  exit 1
fi
echo "  ✔ Custom component discovered and rendered seamlessly"

# -------------------------------------------------------------
# Test 6: Full Pipeline Composition & Delimiters
# -------------------------------------------------------------
echo "• Test 6: Full Pipeline Composition"
"$STATUSLINE_BIN" reset >/dev/null
MOCK_FULL='{"model":{"display_name":"Gemini 3.8 Flash"},"quota":{"gemini-5h":{"remaining_fraction":0.95,"reset_in_seconds":18000},"gemini-weekly":{"remaining_fraction":0.88,"reset_in_seconds":400000}},"context_window":{"used_percentage":12}}'

FULL_OUT=$(export STATUSLINE_CWD="$GIT_REPO"; printf '%s' "$MOCK_FULL" | "$STATUSLINE_BIN")
if [[ "$FULL_OUT" != *"Gemini 3.8 Flash"* ]] || [[ "$FULL_OUT" != *"95%"* ]] || [[ "$FULL_OUT" != *"my-git-app"* ]] || [[ "$FULL_OUT" != *" | "* ]]; then
  echo "FAIL: Full pipeline output invalid. Got: '$FULL_OUT'"
  exit 1
fi
echo "  ✔ Pipeline composes active components separated by delimiters"

echo ""
echo -e "\033[32m✔ All 6 Modular Statusline Tests Passed!\033[0m"
echo ""
