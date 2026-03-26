# レビュープロセス 実行例

## ステップ0: ツール利用可否の確認

```bash
command -v codex >/dev/null 2>&1 && echo "CODEX_AVAILABLE" || echo "CODEX_NOT_AVAILABLE"
```

## ステップ1: プロジェクト分析

### codexが利用可能な場合

```bash
# プロジェクト構造を把握
codex analyze

# 依存関係を確認
grep -A 50 '"dependencies"' package.json

# よく使われているパターンを検索
codex search "import.*from" | head -20
```

### codexが利用不可の場合

```bash
# プロジェクト構造を把握（Globツール、LSツールを使用）
find . -maxdepth 2 -type f -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" -o -name "*.py" | head -30

# 依存関係ファイルを確認（Readツールを使用）
grep -A 50 '"dependencies"' package.json

# よく使われているパターンを検索（Grepツールを使用）
grep -rn "^import" --include="*.ts" --include="*.tsx" . | head -20
```

## ステップ2: コードパターンの分析

### codexが利用可能な場合

```bash
# レビュー対象ファイル内の関数・クラスを把握
codex analyze path/to/file.ts

# 重複コードの検出
codex search "similar patterns"

# 依存関係の確認
codex dependencies path/to/file.ts
```

### codexが利用不可の場合

```bash
# レビュー対象ファイル内の関数・クラスを把握（Readツールを使用）
grep -n "function\|class\|const.*=.*=>" path/to/file.ts

# 重複コードの検出（Grepツールでパターン検索）
grep -rn "特定のパターン" --include="*.ts" .

# import文から依存関係を確認
grep -n "^import\|^from" path/to/file.ts
```

## ステップ3: Context7でベストプラクティスを取得

各ライブラリについて:

1. `resolve-library-id` でライブラリIDを取得
2. `query-docs` で関連するドキュメントを検索
3. ベストプラクティスと現在の実装を比較
4. コード分析で検出したパターンをドキュメントと照合

## ステップ4: レビュー結果の生成

出力テンプレート:

```markdown
# コードレビュー結果

## 概要
- レビュー対象: [ファイル/ディレクトリ]
- 主要技術: [検出されたライブラリ]
- レビュー日時: [日時]
- 分析ツール: [codex + Context7 / Context7 + 標準ツール]

## 良い点
- [具体的な良い実装箇所]

## 改善提案

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

## 参考リソース
- [Context7で取得した関連ドキュメントのサマリー]
```
