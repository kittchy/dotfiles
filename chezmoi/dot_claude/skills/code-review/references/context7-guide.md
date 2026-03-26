# Context7 活用ガイド

## 概要

Context7はライブラリの最新ドキュメントをリアルタイムで検索できるMCPツール。
レビュー時に公式ドキュメントのベストプラクティスと実装を照合するために使用する。

## ライブラリIDの解決

使用されているライブラリを検出したら、まずライブラリIDを解決する。

**ツール名:**
```
mcp__context7__resolve-library-id または
mcp__plugin_context7_context7__resolve-library-id
```

**パラメータ:**
- `libraryName`: 検出されたライブラリ名（例: "react", "express", "next.js"）
- `query`: レビューコンテキスト（例: "authentication implementation review"）

## ドキュメント検索

解決されたライブラリIDで具体的なドキュメントを取得する。

**ツール名:**
```
mcp__context7__query-docs または
mcp__plugin_context7_context7__query-docs
```

**パラメータ:**
- `libraryId`: 解決されたライブラリID（例: "/facebook/react", "/vercel/next.js"）
- `query`: 具体的な質問（例: "useEffect cleanup best practices", "API route security"）

## 効率的な使用ルール

- 同じライブラリのドキュメント検索は**最大3回**まで
- 検索クエリは具体的で明確にする（曖昧なクエリは無駄になる）
- ライブラリIDの解決は**ライブラリごとに一度のみ**
- Context7のクエリにAPIキー、パスワード、個人情報を含めない

## レビューでの活用パターン

1. `resolve-library-id` でライブラリIDを取得
2. `query-docs` で以下を検索:
   - レビュー対象コードが使用しているAPIのベストプラクティス
   - 非推奨APIの代替手段
   - セキュリティに関する公式推奨事項
3. 取得したドキュメント情報を改善提案の根拠として引用する
