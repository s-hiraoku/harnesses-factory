#!/bin/bash

# Test a hook script and display its output
# Usage: ./scripts/test-hook.sh <plugin-name> [hook-script]
#
# Examples:
#   ./scripts/test-hook.sh version-notifier
#   ./scripts/test-hook.sh version-notifier version-check.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
  echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BLUE}  $1${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# Check arguments
if [ -z "$1" ]; then
  echo -e "${YELLOW}Usage: $0 <plugin-name> [hook-script]${NC}"
  echo ""
  echo "Available plugins:"
  for dir in "$ROOT_DIR/plugins"/*/; do
    if [ -d "$dir" ]; then
      plugin_name=$(basename "$dir")
      echo "  - $plugin_name"
    fi
  done
  exit 1
fi

PLUGIN_NAME="$1"
PLUGIN_DIR="$ROOT_DIR/plugins/$PLUGIN_NAME"

# Check if plugin exists
if [ ! -d "$PLUGIN_DIR" ]; then
  echo -e "${RED}Error: Plugin '$PLUGIN_NAME' not found${NC}"
  echo "Path: $PLUGIN_DIR"
  exit 1
fi

# Find hook scripts
SCRIPTS_DIR="$PLUGIN_DIR/scripts"
if [ ! -d "$SCRIPTS_DIR" ]; then
  echo -e "${RED}Error: No scripts directory found in plugin${NC}"
  exit 1
fi

# If specific script provided, use it
if [ -n "$2" ]; then
  HOOK_SCRIPT="$SCRIPTS_DIR/$2"
  if [ ! -f "$HOOK_SCRIPT" ]; then
    echo -e "${RED}Error: Script '$2' not found${NC}"
    exit 1
  fi
  SCRIPTS=("$HOOK_SCRIPT")
else
  # Find all .sh scripts
  SCRIPTS=("$SCRIPTS_DIR"/*.sh)
fi

# Test each script
for script in "${SCRIPTS[@]}"; do
  if [ ! -f "$script" ]; then
    continue
  fi

  script_name=$(basename "$script")
  print_header "Testing: $script_name"

  echo -e "${YELLOW}Script path:${NC} $script"
  echo -e "${YELLOW}Plugin:${NC} $PLUGIN_NAME"
  echo ""

  # Set environment variable for plugin root
  export CLAUDE_PLUGIN_ROOT="$PLUGIN_DIR"

  echo -e "${GREEN}▶ Executing...${NC}\n"

  # Execute and capture output
  if output=$("$script" 2>&1); then
    echo -e "${GREEN}✓ Script executed successfully${NC}\n"
  else
    exit_code=$?
    echo -e "${RED}✗ Script failed with exit code: $exit_code${NC}\n"
  fi

  echo -e "${YELLOW}▼ Raw Output:${NC}"
  echo "$output"
  echo ""

  # Try to parse as JSON
  if echo "$output" | jq . >/dev/null 2>&1; then
    echo -e "${YELLOW}▼ Parsed JSON:${NC}"
    echo "$output" | jq .

    # Extract additionalContext if present
    additional_context=$(echo "$output" | jq -r '.hookSpecificOutput.additionalContext // empty' 2>/dev/null)
    if [ -n "$additional_context" ]; then
      echo -e "\n${YELLOW}▼ additionalContext (what Claude sees):${NC}"
      echo "$additional_context"
    fi
  else
    echo -e "${YELLOW}(Output is not valid JSON)${NC}"
  fi

  echo ""
done

print_header "Test Complete"
