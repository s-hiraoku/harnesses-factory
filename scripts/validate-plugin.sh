#!/bin/bash

# Validate plugin structure and configuration
# Usage: ./scripts/validate-plugin.sh [plugin-name]
#
# If no plugin name is provided, validates all plugins

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

error() {
  echo -e "  ${RED}✗ ERROR: $1${NC}"
  ((ERRORS++))
}

warning() {
  echo -e "  ${YELLOW}⚠ WARNING: $1${NC}"
  ((WARNINGS++))
}

success() {
  echo -e "  ${GREEN}✓ $1${NC}"
}

info() {
  echo -e "  ${BLUE}ℹ $1${NC}"
}

validate_plugin() {
  local plugin_dir="$1"
  local plugin_name=$(basename "$plugin_dir")

  echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BLUE}  Validating: $plugin_name${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

  # Check .claude-plugin directory
  if [ ! -d "$plugin_dir/.claude-plugin" ]; then
    error ".claude-plugin directory not found"
  else
    success ".claude-plugin directory exists"
  fi

  # Check plugin.json
  local plugin_json="$plugin_dir/.claude-plugin/plugin.json"
  if [ ! -f "$plugin_json" ]; then
    error "plugin.json not found"
  else
    success "plugin.json exists"

    # Validate JSON syntax
    if ! jq . "$plugin_json" >/dev/null 2>&1; then
      error "plugin.json is not valid JSON"
    else
      success "plugin.json is valid JSON"

      # Check required fields
      local name=$(jq -r '.name // empty' "$plugin_json")
      if [ -z "$name" ]; then
        error "plugin.json missing required field: name"
      else
        success "plugin.json has name: $name"
      fi

      local version=$(jq -r '.version // empty' "$plugin_json")
      if [ -z "$version" ]; then
        warning "plugin.json missing version"
      else
        success "plugin.json has version: $version"
      fi

      local description=$(jq -r '.description // empty' "$plugin_json")
      if [ -z "$description" ]; then
        warning "plugin.json missing description"
      else
        success "plugin.json has description"
      fi
    fi
  fi

  # Check hooks
  local hooks_json="$plugin_dir/hooks/hooks.json"
  if [ -f "$hooks_json" ]; then
    success "hooks/hooks.json exists"

    if ! jq . "$hooks_json" >/dev/null 2>&1; then
      error "hooks.json is not valid JSON"
    else
      success "hooks.json is valid JSON"

      # Check for script references
      local scripts=$(jq -r '.. | .command? // empty' "$hooks_json" 2>/dev/null | grep -v '^$' || true)
      if [ -n "$scripts" ]; then
        while IFS= read -r script_ref; do
          # Replace ${CLAUDE_PLUGIN_ROOT} with actual path
          local script_path=$(echo "$script_ref" | sed "s|\${CLAUDE_PLUGIN_ROOT}|$plugin_dir|g")
          if [ -f "$script_path" ]; then
            success "Referenced script exists: $(basename "$script_path")"
            if [ -x "$script_path" ]; then
              success "Script is executable: $(basename "$script_path")"
            else
              warning "Script is not executable: $(basename "$script_path")"
            fi
          else
            error "Referenced script not found: $script_ref"
          fi
        done <<< "$scripts"
      fi
    fi
  else
    info "No hooks/hooks.json (optional)"
  fi

  # Check commands
  if [ -d "$plugin_dir/commands" ]; then
    local cmd_count=$(find "$plugin_dir/commands" -name "*.md" | wc -l | tr -d ' ')
    success "commands/ directory exists with $cmd_count command(s)"
  else
    info "No commands/ directory (optional)"
  fi

  # Check skills
  if [ -d "$plugin_dir/skills" ]; then
    local skill_count=$(find "$plugin_dir/skills" -name "SKILL.md" | wc -l | tr -d ' ')
    success "skills/ directory exists with $skill_count skill(s)"
  else
    info "No skills/ directory (optional)"
  fi

  # Check README
  if [ -f "$plugin_dir/README.md" ]; then
    success "README.md exists"
  else
    warning "README.md not found"
  fi

  echo ""
}

# Main
echo -e "\n${GREEN}Plugin Validator${NC}"
echo -e "${GREEN}=================${NC}"

if [ -n "$1" ]; then
  # Validate specific plugin
  PLUGIN_DIR="$ROOT_DIR/plugins/$1"
  if [ ! -d "$PLUGIN_DIR" ]; then
    echo -e "${RED}Error: Plugin '$1' not found${NC}"
    exit 1
  fi
  validate_plugin "$PLUGIN_DIR"
else
  # Validate all plugins
  for dir in "$ROOT_DIR/plugins"/*/; do
    if [ -d "$dir" ]; then
      validate_plugin "$dir"
    fi
  done
fi

# Summary
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Summary${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
  echo -e "\n${GREEN}✓ All validations passed!${NC}\n"
  exit 0
elif [ $ERRORS -eq 0 ]; then
  echo -e "\n${YELLOW}⚠ Validation completed with $WARNINGS warning(s)${NC}\n"
  exit 0
else
  echo -e "\n${RED}✗ Validation failed with $ERRORS error(s) and $WARNINGS warning(s)${NC}\n"
  exit 1
fi
