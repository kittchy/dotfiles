---
allowed-tools: Bash(bq:*), Read, Glob, Grep, AskUserQuestion
description: カレントディレクトリのコードを参照してBigQueryクエリを作成・実行
---

# BigQueryクエリの作成と実行

このコマンドは、カレントディレクトリのコードを参照しながらBigQueryクエリを作成し、`bq`コマンドで実行します。

## 基本動作

1. `$ARGUMENTS` からプロジェクトID/データセット名を取得（指定がなければユーザーに確認）
2. カレントディレクトリのコード（特にスキーマ定義、モデル、既存クエリなど）を分析
3. ユーザーの要望に基づいてBigQueryクエリを作成
4. **実行前に必ずユーザーに確認を取る**（AskUserQuestionを使用）
5. クエリを実行し、結果を表示
6. エラーが発生した場合は修正して再実行

## 重要な要件

- **確認必須**: クエリ実行前に必ずユーザーに確認を取ること
- **コード参照**: カレントディレクトリのスキーマ定義、テーブル構造、既存クエリを参照すること
- **試行錯誤**: エラーが出た場合は原因を分析し、修正案を提示して再実行すること
- **引数の扱い**:
  - `$ARGUMENTS` が空の場合は、プロジェクトIDとデータセット名をAskUserQuestionで確認
  - 形式: `<project_id>.<dataset_name>` または `<project_id>`

## bqコマンドの基本形式

```bash
# 標準SQL（推奨）
bq query --use_legacy_sql=false --project_id=<project_id> 'SELECT ...'

# ドライラン（課金確認）
bq query --use_legacy_sql=false --dry_run 'SELECT ...'

# 結果をテーブルに保存
bq query --use_legacy_sql=false --destination_table=<dataset>.<table> 'SELECT ...'
```

## ワークフロー

1. **コンテキスト収集**
   - カレントディレクトリのスキーマファイル（.sql, .json, schema.* など）を検索
   - モデル定義ファイル（models/, schemas/ など）を確認
   - 既存のクエリファイル（queries/, *.sql）を参照

2. **クエリ作成**
   - ユーザーの要望をヒアリング
   - 参照したコードに基づいてテーブル名、カラム名を正確に使用
   - クエリの目的（集計、JOIN、フィルタリングなど）に応じた最適化

3. **実行確認**
   - 作成したクエリを表示
   - AskUserQuestionでユーザーに確認
   - 必要に応じてドライランで推定コストを表示

4. **実行と結果確認**
   - bqコマンドで実行
   - 結果を確認
   - エラーの場合は原因を分析し修正提案

5. **反復改善**
   - 結果に基づいて追加の質問や修正を受け付ける
   - 必要に応じてクエリを調整して再実行

## 参照すべきファイルパターン例

- スキーマ: `**/*schema*.{sql,json,yaml,yml}`, `**/models/**/*.sql`
- テーブル定義: `**/tables/**/*.sql`, `**/ddl/**/*.sql`
- 既存クエリ: `**/queries/**/*.sql`, `**/*query*.sql`
- ドキュメント: `**/*bigquery*.md`, `**/README.md`

## 注意事項

- **コスト**: 大量データのスキャンはコストが発生するため、WHERE句でパーティション絞り込みを推奨
- **Standard SQL**: 基本的に`--use_legacy_sql=false`を使用（Legacy SQLは非推奨）
- **権限**: 実行ユーザーがプロジェクト/データセットへのアクセス権限を持っていることを前提

