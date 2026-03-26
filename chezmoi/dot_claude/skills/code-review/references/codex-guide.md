# Codex 活用ガイド

## 概要

Codex（OpenAI Codex CLI）はコードベース全体を検索・分析するツール。
利用可能な場合、grep/findよりも高精度なコード分析が可能。

## 利用可否の判定

レビュー開始時に必ず実行する:

```bash
command -v codex >/dev/null 2>&1 && echo "CODEX_AVAILABLE" || echo "CODEX_NOT_AVAILABLE"
```

## コマンドリファレンス

### codex search

コードベース全体からパターンを検索する。

```bash
# 関数やクラスの使用箇所を検索
codex search "functionName"

# 正規表現パターンで検索
codex search "useState.*useEffect"

# import文のパターンを検索
codex search "import.*from" | head -20
```

### codex analyze

ファイルまたはプロジェクト全体の構造を分析する。

```bash
# プロジェクト全体の構造を把握
codex analyze

# 特定ファイルの関数・クラスを一覧表示
codex analyze path/to/file.ts
```

### codex dependencies

依存関係を分析する。

```bash
# プロジェクト全体の依存関係
codex dependencies

# 特定ファイルの依存関係
codex dependencies path/to/file.ts
```

## レビューでの活用ケース

1. **コードパターンの検出**: 同じ実装パターンが複数箇所にある場合、重複コードとして指摘
2. **依存関係の確認**: 特定の関数やクラスがどこで使われているかを把握
3. **命名規則のチェック**: プロジェクト全体で一貫した命名が使われているか確認
4. **未使用コードの検出**: インポートされているが使用されていないコードを特定

## Codex不在時のフォールバック

codexが利用できない場合、以下で代替する:

| codexコマンド | フォールバック |
|---|---|
| `codex search "pattern"` | Grepツール または `grep -rn "pattern" .` |
| `codex analyze file.ts` | Readツール でファイル内容を確認 |
| `codex analyze` | Globツール でプロジェクト構造を把握 |
| `codex dependencies` | 依存関係ファイル（package.json等）をReadツールで確認 |
| `codex dependencies file.ts` | Grepツール で `import`/`require` 文を検索 |
