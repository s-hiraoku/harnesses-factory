#!/bin/bash

set -e

# ===== 設定 =====
PLUGIN_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CACHE_DIR="${PLUGIN_DIR}/.cache"
CACHE_FILE="${CACHE_DIR}/version-cache.json"
LAST_CHECK_FILE="${CACHE_DIR}/last-check"
CHECK_INTERVAL_HOURS=24

# ===== 初期化 =====
mkdir -p "$CACHE_DIR"

# ===== キャッシュチェック =====
should_check_version() {
  if [ ! -f "$LAST_CHECK_FILE" ]; then
    return 0
  fi

  local last_check=$(cat "$LAST_CHECK_FILE" 2>/dev/null || echo "0")
  local now=$(date +%s)
  local interval_seconds=$((CHECK_INTERVAL_HOURS * 3600))
  local elapsed=$((now - last_check))

  [ "$elapsed" -ge "$interval_seconds" ]
}

# ===== バージョン取得 =====
get_current_version() {
  claude --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1
}

get_latest_version() {
  npm show @anthropic-ai/claude-code version 2>/dev/null
}

# ===== Changelog 取得 =====
get_changelog() {
  local release_info=$(curl -s "https://api.github.com/repos/anthropics/claude-code/releases/latest" 2>/dev/null)

  if [ -n "$release_info" ]; then
    echo "$release_info" | jq -r '.body // "Changelog not available"' 2>/dev/null | head -100
  else
    echo "Changelog not available. Please check: https://github.com/anthropics/claude-code/releases"
  fi
}

# ===== メイン処理 =====
main() {
  # キャッシュチェック
  if ! should_check_version; then
    if [ -f "$CACHE_FILE" ]; then
      cat "$CACHE_FILE"
    else
      echo '{}'
    fi
    return
  fi

  # バージョン取得
  local CURRENT_VERSION=$(get_current_version)
  local LATEST_VERSION=$(get_latest_version)

  # チェック時刻を記録
  date +%s > "$LAST_CHECK_FILE"

  # バージョン比較
  if [ -z "$LATEST_VERSION" ] || [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
    echo '{}' > "$CACHE_FILE"
    echo '{}'
    return
  fi

  # 新バージョンあり
  local CHANGELOG=$(get_changelog)

  local MESSAGE="## 🆕 Claude Code 新バージョンが利用可能です！

**現在のバージョン:** v${CURRENT_VERSION}
**最新バージョン:** v${LATEST_VERSION}

### 📋 変更内容（Changelog）

${CHANGELOG}

---

**👆 上記の Changelog を分析して、以下の形式で説明してください：**

1. **🎯 主要な新機能**（箇条書きで簡潔に）
2. **💡 使い方の例**（具体的なコマンドや使用例）
3. **🚀 おすすめの活用シーン**
4. **⚠️ 注意点・破壊的変更**（あれば）

### アップデート方法
\`\`\`bash
npm install -g @anthropic-ai/claude-code@latest
\`\`\`"

  # JSON 出力を構築
  local OUTPUT=$(jq -n \
    --arg msg "$MESSAGE" \
    '{
      "hookSpecificOutput": {
        "hookEventName": "SessionStart",
        "additionalContext": $msg
      }
    }')

  # キャッシュに保存
  echo "$OUTPUT" > "$CACHE_FILE"

  # 出力
  echo "$OUTPUT"
}

main
