#!/bin/bash

# Launch Claude Code with a specific plugin for testing
# Usage: ./scripts/test-plugin.sh <plugin-name>
#
# Examples:
#   ./scripts/test-plugin.sh cc-version-updator
#   ./scripts/test-plugin.sh context-advisor

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check arguments
if [ -z "$1" ]; then
  echo -e "${YELLOW}Usage: $0 <plugin-name>${NC}"
  echo ""
  echo "Available plugins:"
  for dir in "$ROOT_DIR/plugins"/*/; do
    if [ -d "$dir" ]; then
      plugin_name=$(basename "$dir")
      echo "  - $plugin_name"
    fi
  done
  echo ""
  echo "Options:"
  echo "  --all    Load all plugins"
  exit 1
fi

if [ "$1" = "--all" ]; then
  # Load all plugins
  PLUGIN_ARGS=""
  for dir in "$ROOT_DIR/plugins"/*/; do
    if [ -d "$dir" ]; then
      PLUGIN_ARGS="$PLUGIN_ARGS --plugin-dir $dir"
    fi
  done

  echo -e "${GREEN}Launching Claude Code with all plugins...${NC}"
  echo -e "${YELLOW}Command: claude $PLUGIN_ARGS${NC}"
  echo ""

  exec claude $PLUGIN_ARGS
else
  PLUGIN_NAME="$1"
  PLUGIN_DIR="$ROOT_DIR/plugins/$PLUGIN_NAME"

  # Check if plugin exists
  if [ ! -d "$PLUGIN_DIR" ]; then
    echo -e "${RED}Error: Plugin '$PLUGIN_NAME' not found${NC}"
    echo "Path: $PLUGIN_DIR"
    exit 1
  fi

  echo -e "${GREEN}Launching Claude Code with plugin: $PLUGIN_NAME${NC}"
  echo -e "${YELLOW}Command: claude --plugin-dir $PLUGIN_DIR${NC}"
  echo ""

  exec claude --plugin-dir "$PLUGIN_DIR"
fi
