---
allowed-tools: Bash(bq show:*), Bash(bq ls:*), Read, Glob, Grep, AskUserQuestion
description: カレントディレクトリのコードを参照してBigQueryクエリを生成（実行はしない）
---

# BigQueryクエリ生成

カレントディレクトリのコードを参照し、BigQuery Standard SQLクエリを生成する。クエリの実行は行わない。

## 禁止事項

- `bq query` の実行は禁止。allowed-toolsに含まれていないため構造的に実行不可
- クエリ結果をLLMコンテキストに取り込むことは禁止

## ワークフロー

### 1. 引数の取得

- `$ARGUMENTS` からプロジェクトID・データセット名・クエリの目的を取得
- 不足があれば `AskUserQuestion` で確認
- 形式例: `<project_id>.<dataset_name> <クエリの目的>`

### 2. コード分析

カレントディレクトリから以下のファイルを探索し、テーブル構造・スキーマ情報を収集する:

- スキーマ定義: `**/*schema*.{sql,json,yaml,yml}`
- dbtモデル: `**/models/**/*.sql`, `**/dbt_project.yml`
- DDL: `**/tables/**/*.sql`, `**/ddl/**/*.sql`, `**/migrations/**/*.sql`
- Terraform: `**/*.tf` (google_bigquery_table リソース)
- ORM定義: `**/models/**/*.py`, `**/models/**/*.go`
- 既存クエリ: `**/queries/**/*.sql`, `**/*query*.sql`
- ドキュメント: `**/*bigquery*.md`, `**/README.md`

### 3. メタデータ補完

コードだけでは情報が不足する場合、`bq show` / `bq ls` でメタデータを取得する:

```bash
# データセット内のテーブル一覧
bq ls --project_id=<project_id> <dataset_name>

# テーブルスキーマの確認
bq show --project_id=<project_id> --schema <dataset_name>.<table_name>

# テーブル詳細（パーティション情報等）
bq show --project_id=<project_id> <dataset_name>.<table_name>
```

### 4. クエリ生成・提示

以下の形式で出力する:

> **クエリの目的**: <何を取得・集計するか>
>
> **対象テーブル**: <使用するテーブルの一覧>
>
> **注意事項**:
> - パーティション: <パーティションカラムとフィルタ推奨事項>
> - 推定スキャン量: <わかる範囲で>
> - その他留意点

```sql
-- <クエリの目的を1行コメント>
SELECT ...
FROM ...
WHERE ...
```

実行方法:

```bash
bq query --use_legacy_sql=false --project_id=<project_id> '<クエリ>'
```

## クエリ作成のベストプラクティス

- **Standard SQL** を使用（Legacy SQLは非推奨）
- **パーティション絞り込み**: パーティションテーブルでは必ずWHERE句でパーティションカラムを指定し、スキャン量を最小化
- **SELECT *の回避**: 必要なカラムのみを明示的に指定
- **コスト意識**: 大量データのスキャンを避けるクエリ設計
- **可読性**: CTEを活用し、複雑なクエリは段階的に構築
