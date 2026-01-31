---
allowed-tools: mcp__context7__*, mcp__plugin_context7_context7__*, Bash(grep:*), Bash(find:*), Bash(codex:*)
description: Context7を活用してコードレビューを実行し、ベストプラクティスに基づいた改善提案を提供
---

# コードレビュー（Context7統合）

このスキルは、Context7のドキュメント検索機能を活用して、プロジェクトのコードを包括的にレビューします。

## 基本動作

1. レビュー対象のファイルまたはディレクトリを特定
2. 使用されているライブラリ・フレームワークを識別
3. Context7で各ライブラリの最新ドキュメントとベストプラクティスを取得
4. コードをドキュメントと照合してレビュー
5. 具体的な改善提案を提供

## レビュー観点

### 1. ベストプラクティス準拠

- Context7で取得した公式ドキュメントのベストプラクティスとの照合
- 推奨されるパターンと実装の比較
- 非推奨APIや古い手法の検出

### 2. コード品質

- 可読性: 命名規則、コメント、構造
- 保守性: モジュール化、重複コード、複雑度
- 一貫性: プロジェクト内のコーディングスタイル

### 3. セキュリティ

- 一般的な脆弱性パターン（OWASP Top 10）
- 入力検証とサニタイゼーション
- 認証・認可の実装

### 4. パフォーマンス

- 非効率なアルゴリズムやクエリ
- メモリリークの可能性
- 不要な再レンダリングや再計算

### 5. エラーハンドリング

- 適切な例外処理
- エラーメッセージの品質
- リソースのクリーンアップ

## Codexの活用方法

### コードベースの検索と分析

レビュー対象のコードを理解するために、codexを使用してコードベース全体を検索・分析:

```bash
# 特定の関数やクラスの使用箇所を検索
codex search "functionName"

# 特定のパターンを持つコードを検索
codex search "useState.*useEffect"

# ファイル内の関数定義を一覧表示
codex analyze file.ts

# プロジェクト全体の依存関係を分析
codex dependencies
```

### 主な使用ケース

1. **コードパターンの検出**: 同じような実装パターンが複数箇所にある場合、重複コードとして指摘
2. **依存関係の確認**: 特定の関数やクラスがどこで使われているかを把握
3. **命名規則のチェック**: プロジェクト全体で一貫した命名が使われているか確認
4. **未使用コードの検出**: インポートされているが使用されていないコードを特定

## Context7の活用方法

### ライブラリIDの解決

使用されているライブラリを検出したら、Context7でライブラリIDを解決:

```
mcp__context7__resolve-library-id または
mcp__plugin_context7_context7__resolve-library-id
```

パラメータ:

- `libraryName`: 検出されたライブラリ名（例: "react", "express", "next.js"）
- `query`: レビューコンテキスト（例: "authentication implementation review"）

### ドキュメント検索

解決されたライブラリIDで具体的なドキュメントを取得:

```
mcp__context7__query-docs または
mcp__plugin_context7_context7__query-docs
```

パラメータ:

- `libraryId`: 解決されたライブラリID（例: "/facebook/react", "/vercel/next.js"）
- `query`: 具体的な質問（例: "useEffect cleanup best practices", "API route security"）

## レビュープロセス

### ステップ1: プロジェクト分析

```bash
# codexでプロジェクト構造を把握
codex analyze

# package.jsonから依存関係を確認
cat package.json | grep -A 50 '"dependencies"'

# または requirements.txt, go.mod, Cargo.toml など

# codexでよく使われているパターンを検索
codex search "import.*from" | head -20
```

### ステップ2: ライブラリの識別とコードパターンの分析

**A. 依存関係の識別**

検出された主要なライブラリをリストアップ:

- フレームワーク（React, Vue, Express, Django等）
- 状態管理（Redux, Zustand, Pinia等）
- UI/スタイリング（MUI, Tailwind, styled-components等）
- データフェッチング（React Query, SWR, Axios等）

**B. codexでコードパターンを分析**

```bash
# レビュー対象ファイル内の関数・クラスを把握
codex analyze path/to/file.ts

# 重複コードの検出
codex search "similar patterns"

# 依存関係の確認
codex dependencies path/to/file.ts
```

### ステップ3: Context7でベストプラクティスを取得

各ライブラリについて:

1. `resolve-library-id`でライブラリIDを取得
2. `query-docs`で関連するドキュメントを検索
3. ベストプラクティスと現在の実装を比較
4. codexで検出したコードパターンをドキュメントと照合

### ステップ4: レビュー結果の生成

以下の形式でレビュー結果を提示:

```markdown
# コードレビュー結果

## 📋 概要
- レビュー対象: [ファイル/ディレクトリ]
- 主要技術: [検出されたライブラリ]
- レビュー日時: [日時]

## ✅ 良い点
- [具体的な良い実装箇所]

## ⚠️ 改善提案

### 高優先度
1. **[問題点のタイトル]**
   - 場所: `file.js:123`
   - 問題: [問題の説明]
   - 推奨: [Context7のドキュメントに基づく改善策]
   - 参考: [ライブラリの公式ドキュメントへの言及]

### 中優先度
[同様の形式]

### 低優先度（提案）
[同様の形式]

## 📚 参考リソース
- [Context7で取得した関連ドキュメントのサマリー]
```

## 使用例

### 特定ファイルのレビュー

```
/review src/components/UserAuth.tsx
```

### ディレクトリ全体のレビュー

```
/review src/api/
```

### 特定の観点に絞ったレビュー

```
/review src/ --focus=security
/review src/ --focus=performance
```

## 重要な注意事項

1. **Codexの効率的な使用**
   - プロジェクト構造の把握には `codex analyze` を最初に実行
   - 大規模なコードベースでは検索範囲を絞り込む
   - 具体的な検索パターンを使用して効率的に検索
   - `grep` や `find` よりも `codex` を優先的に使用

2. **Context7の効率的な使用**
   - 同じライブラリのドキュメント検索は最大3回まで
   - 検索クエリは具体的で明確に
   - ライブラリIDの解決は一度のみ

3. **センシティブ情報の保護**
   - Context7のクエリにAPI キー、パスワード、個人情報を含めない
   - レビュー結果にも機密情報を含めない

4. **建設的なフィードバック**
   - 問題点だけでなく、具体的な改善案を提示
   - コードの良い点も積極的に評価
   - 優先度を明確に示す

5. **コンテキストの考慮**
   - プロジェクトの既存パターンを尊重
   - 過度なリファクタリングを提案しない
   - 実際の影響を評価してから提案

## 出力形式

- レビュー結果は日本語で記述
- コードスニペットと改善例を含める
- ファイル名と行番号を明記（例: `src/app.ts:42`）
- codexで検出したパターンや依存関係を明記
- Context7で取得した情報の出典を示す
