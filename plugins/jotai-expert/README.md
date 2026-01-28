# Jotai Expert Plugin

Jotai状態管理ライブラリのエキスパートスキルを提供するプラグイン。

## Installation

```bash
# Claude Code plugin として追加
/plugin install https://github.com/s-hiraoku/harnesses-factory/plugins/jotai-expert

# または skills CLI で追加
npx skills add s-hiraoku/harnesses-factory/plugins/jotai-expert
```

## Skills

### jotai-expert

Reactアプリケーションでのatom ベースの状態管理を実装する際に使用します。

**発動条件:**
- 「Jotai」「atom」「状態管理」に関する質問や実装依頼をした場合

**対応機能:**
- Jotai の atom 設計・実装
- 派生 atom、非同期 atom、atomFamily の実装
- ベストプラクティスに基づくリファクタリング
- パフォーマンス最適化（selectAtom、splitAtom 等）
- 永続化（localStorage/sessionStorage 連携）
- TypeScript 型定義
- テスト実装

## License

MIT
