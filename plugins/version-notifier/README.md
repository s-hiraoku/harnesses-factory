# Version Notifier Plugin

Claude Code の新バージョンがリリースされた際に自動通知し、Changelog を Claude に解説させるプラグイン。

## 機能

- セッション開始時にバージョンをチェック
- 新バージョンがある場合、GitHub Releases から Changelog を取得
- Claude が Changelog を分析し、使い方とユースケースを説明

## インストール

```bash
# グローバルインストール
claude plugin install version-notifier@s-hiraoku/claude-code-harnesses-factory

# プロジェクトローカル
claude plugin install version-notifier@s-hiraoku/claude-code-harnesses-factory --scope project
```

## 開発・テスト

```bash
claude --plugin-dir ./plugins/version-notifier
```

## 動作フロー

```
Claude Code 起動
       ↓
SessionStart Hook 実行
       ↓
version-check.sh 実行
       ↓
バージョン比較
├─ 同じ → 何も表示しない
└─ 新バージョンあり → Changelog 取得
       ↓
additionalContext として出力
       ↓
Claude が Changelog を分析・説明
```

## 設定

| 項目 | デフォルト | 説明 |
|------|-----------|------|
| チェック間隔 | 24時間 | スクリプト内の `CHECK_INTERVAL_HOURS` で変更可能 |

## 依存

- `jq` - JSON パース
- `curl` - HTTP リクエスト
- `npm` - バージョン確認

## ライセンス

MIT
