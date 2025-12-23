#!/bin/bash
#
# dev-setup.sh
# Plugin Factory Development Environment Setup
#
# Generates .claude/ development files from plugins/.
# Replaces ${CLAUDE_PLUGIN_ROOT} with ${PWD}/plugins/<name> so you can
# debug production plugins locally without modifying them.
#
# Usage:
#   ./scripts/dev-setup.sh           # Setup (generate)
#   ./scripts/dev-setup.sh --status  # Show status
#   ./scripts/dev-setup.sh --clean   # Remove generated files
#

set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PLUGINS_DIR="$REPO_ROOT/plugins"
CLAUDE_DIR="$REPO_ROOT/.claude"
COMMANDS_DIR="$CLAUDE_DIR/commands"

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ===== i18n Support =====
# Detect language from LANG environment variable
detect_lang() {
  case "${LANG:-en}" in
    ja*) echo "ja" ;;
    *)   echo "en" ;;
  esac
}

LANG_CODE=$(detect_lang)

# Message function for multilingual support
msg() {
  local key="$1"
  shift
  local args=("$@")

  case "$LANG_CODE" in
    ja)
      case "$key" in
        "title")           echo "Plugin Factory 開発環境セットアップ" ;;
        "status_title")    echo "Plugin Factory ステータス" ;;
        "help_title")      echo "Plugin Factory 開発環境セットアップ" ;;
        "help_usage")      echo "使い方: $0 [OPTIONS]" ;;
        "help_options")    echo "オプション:" ;;
        "help_none")       echo "  (なし)     plugins/ から .claude/ ファイルを生成" ;;
        "help_status")     echo "  --status   現在のセットアップ状態を表示" ;;
        "help_clean")      echo "  --clean    生成ファイルを削除" ;;
        "help_help")       echo "  --help     このヘルプを表示" ;;
        "help_generated")  echo "生成されるファイル:" ;;
        "plugins")         echo "プラグイン:" ;;
        "generated_files") echo "生成ファイル:" ;;
        "hooks_found")     echo "フック: 検出" ;;
        "commands_files")  printf "コマンド: %s ファイル" "${args[0]}" ;;
        "skills_count")    printf "スキル: %s 個" "${args[0]}" ;;
        "not_generated")   echo "未生成" ;;
        "generating_settings") echo ".claude/settings.json を生成中..." ;;
        "generating_commands") echo ".claude/commands/ を生成中..." ;;
        "processing")      printf "処理中: %s" "${args[0]}" ;;
        "created")         printf "作成: %s" "${args[0]}" ;;
        "added")           printf "+ %s (%s より)" "${args[0]}" "${args[1]}" ;;
        "setup_complete")  echo "セットアップ完了！" ;;
        "generated_list")  echo "生成されたファイル:" ;;
        "run_claude")      echo "'claude' を実行してプラグインをデバッグしてください。" ;;
        "after_modify")    echo "plugins/ を変更後、このスクリプトを再実行してください。" ;;
        "cleaning")        echo "生成ファイルを削除中..." ;;
        "removed")         printf "- %s" "${args[0]}" ;;
        "done")            echo "完了！" ;;
        "unknown_option")  printf "不明なオプション: %s" "${args[0]}" ;;
        *)                 echo "$key" ;;
      esac
      ;;
    *)
      case "$key" in
        "title")           echo "Plugin Factory Development Setup" ;;
        "status_title")    echo "Plugin Factory Status" ;;
        "help_title")      echo "Plugin Factory Development Setup" ;;
        "help_usage")      echo "Usage: $0 [OPTIONS]" ;;
        "help_options")    echo "Options:" ;;
        "help_none")       echo "  (none)     Generate .claude/ files from plugins/" ;;
        "help_status")     echo "  --status   Show current setup status" ;;
        "help_clean")      echo "  --clean    Remove generated files" ;;
        "help_help")       echo "  --help     Show this help" ;;
        "help_generated")  echo "Generated files:" ;;
        "plugins")         echo "Plugins:" ;;
        "generated_files") echo "Generated files:" ;;
        "hooks_found")     echo "hooks: found" ;;
        "commands_files")  printf "commands: %s file(s)" "${args[0]}" ;;
        "skills_count")    printf "skills: %s skill(s)" "${args[0]}" ;;
        "not_generated")   echo "not generated" ;;
        "generating_settings") echo "Generating .claude/settings.json..." ;;
        "generating_commands") echo "Generating .claude/commands/..." ;;
        "processing")      printf "Processing: %s" "${args[0]}" ;;
        "created")         printf "Created: %s" "${args[0]}" ;;
        "added")           printf "+ %s (from %s)" "${args[0]}" "${args[1]}" ;;
        "setup_complete")  echo "Setup complete!" ;;
        "generated_list")  echo "Generated files:" ;;
        "run_claude")      echo "Run 'claude' to start debugging plugins." ;;
        "after_modify")    echo "After modifying plugins/, run this script again." ;;
        "cleaning")        echo "Cleaning generated files..." ;;
        "removed")         printf "- %s" "${args[0]}" ;;
        "done")            echo "Done!" ;;
        "unknown_option")  printf "Unknown option: %s" "${args[0]}" ;;
        *)                 echo "$key" ;;
      esac
      ;;
  esac
}

# Help
show_help() {
  echo -e "${CYAN}$(msg help_title)${NC}"
  echo ""
  msg "help_usage"
  echo ""
  msg "help_options"
  msg "help_none"
  msg "help_status"
  msg "help_clean"
  msg "help_help"
  echo ""
  msg "help_generated"
  echo "  .claude/settings.json  - Merged hooks from all plugins"
  echo "  .claude/commands/      - Commands from all plugins"
}

# Status check
show_status() {
  echo -e "${CYAN}$(msg status_title)${NC}"
  echo ""

  # Plugin list
  echo -e "${BLUE}$(msg plugins)${NC}"
  for plugin_dir in "$PLUGINS_DIR"/*/; do
    if [ -d "$plugin_dir" ]; then
      plugin_name=$(basename "$plugin_dir")
      echo -e "  ${GREEN}✓${NC} $plugin_name"

      # hooks
      if [ -f "$plugin_dir/hooks/hooks.json" ]; then
        echo -e "    └─ $(msg hooks_found)"
      fi

      # commands
      cmd_count=$(find "$plugin_dir/commands" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
      if [ "$cmd_count" -gt 0 ]; then
        echo -e "    └─ $(msg commands_files "$cmd_count")"
      fi

      # skills
      skill_count=$(find "$plugin_dir/skills" -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
      if [ "$skill_count" -gt 0 ]; then
        echo -e "    └─ $(msg skills_count "$skill_count")"
      fi
    fi
  done

  echo ""
  echo -e "${BLUE}$(msg generated_files)${NC}"

  # settings.json
  if [ -f "$CLAUDE_DIR/settings.json" ]; then
    echo -e "  ${GREEN}✓${NC} .claude/settings.json"
  else
    echo -e "  ${RED}✗${NC} .claude/settings.json ($(msg not_generated))"
  fi

  # commands
  if [ -d "$COMMANDS_DIR" ]; then
    cmd_count=$(find "$COMMANDS_DIR" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    echo -e "  ${GREEN}✓${NC} .claude/commands/ ($cmd_count file(s))"
  else
    echo -e "  ${RED}✗${NC} .claude/commands/ ($(msg not_generated))"
  fi
}

# Generate settings.json
generate_settings() {
  echo -e "${BLUE}$(msg generating_settings)${NC}"

  # Collect hooks from each plugin
  local all_hooks='{"hooks":{}}'

  for plugin_dir in "$PLUGINS_DIR"/*/; do
    if [ -d "$plugin_dir" ]; then
      plugin_name=$(basename "$plugin_dir")
      hooks_file="$plugin_dir/hooks/hooks.json"

      if [ -f "$hooks_file" ]; then
        echo -e "  $(msg processing "$plugin_name")"

        # Read hooks.json and replace ${CLAUDE_PLUGIN_ROOT}
        plugin_hooks=$(cat "$hooks_file" | sed "s|\${CLAUDE_PLUGIN_ROOT}|\${PWD}/plugins/$plugin_name|g")

        # Extract and merge hooks for each event type (SessionStart, etc.)
        for event in $(echo "$plugin_hooks" | jq -r '.hooks | keys[]' 2>/dev/null); do
          event_hooks=$(echo "$plugin_hooks" | jq ".hooks[\"$event\"]")
          all_hooks=$(echo "$all_hooks" | jq ".hooks[\"$event\"] += $event_hooks")
        done
      fi
    fi
  done

  # Output to settings.json
  mkdir -p "$CLAUDE_DIR"
  echo "$all_hooks" | jq '.' > "$CLAUDE_DIR/settings.json"
  echo -e "  ${GREEN}✓${NC} $(msg created ".claude/settings.json")"
}

# Generate commands
generate_commands() {
  echo -e "${BLUE}$(msg generating_commands)${NC}"

  mkdir -p "$COMMANDS_DIR"

  for plugin_dir in "$PLUGINS_DIR"/*/; do
    if [ -d "$plugin_dir" ]; then
      plugin_name=$(basename "$plugin_dir")
      plugin_commands="$plugin_dir/commands"

      if [ -d "$plugin_commands" ]; then
        for cmd_file in "$plugin_commands"/*.md; do
          if [ -f "$cmd_file" ]; then
            cmd_name=$(basename "$cmd_file")

            # Replace ${CLAUDE_PLUGIN_ROOT} and copy
            sed "s|\${CLAUDE_PLUGIN_ROOT}|\${PWD}/plugins/$plugin_name|g" "$cmd_file" > "$COMMANDS_DIR/$cmd_name"
            echo -e "  ${GREEN}$(msg added "$cmd_name" "$plugin_name")${NC}"
          fi
        done
      fi
    fi
  done
}

# Run setup
run_setup() {
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${CYAN}$(msg title)${NC}"
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""

  generate_settings
  echo ""
  generate_commands

  echo ""
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${GREEN}$(msg setup_complete)${NC}"
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  msg "generated_list"
  echo "  - .claude/settings.json"
  echo "  - .claude/commands/"
  echo ""
  msg "run_claude"
  msg "after_modify"
}

# Cleanup
run_clean() {
  echo -e "${BLUE}$(msg cleaning)${NC}"

  if [ -f "$CLAUDE_DIR/settings.json" ]; then
    rm "$CLAUDE_DIR/settings.json"
    echo -e "  ${RED}$(msg removed ".claude/settings.json")${NC}"
  fi

  if [ -d "$COMMANDS_DIR" ]; then
    rm -rf "$COMMANDS_DIR"
    echo -e "  ${RED}$(msg removed ".claude/commands/")${NC}"
  fi

  echo ""
  echo -e "${GREEN}$(msg done)${NC}"
}

# Main
case "${1:-}" in
  --help|-h)
    show_help
    ;;
  --status|-s)
    show_status
    ;;
  --clean|-c)
    run_clean
    ;;
  "")
    run_setup
    ;;
  *)
    echo -e "${RED}$(msg unknown_option "$1")${NC}"
    show_help
    exit 1
    ;;
esac
