---
name: checkout-commit-push-pr
allowed-tools: Bash(gh:*), Bash(git:*)
description: 変更を論理的なコミット単位に分割し、ブランチ作成・コミット・プッシュ・Draft PR作成までを一括実行
---

# Ship: ブランチ作成からDraft PR作成までの一括実行

変更の分析→ブランチ作成→論理的なコミット分割→プッシュ→Draft PR作成を一括で行う。

## ワークフロー

### Step 1: 状態確認

現在の状態を把握する。

```bash
git status
git diff --stat
git log --oneline -10
gh repo view --json "defaultBranchRef" --jq ".defaultBranchRef.name"
```

- 変更がなければ即座に終了し、ユーザーに通知する
- デフォルトブランチ名を取得しておく

### Step 2: ブランチ作成

- **デフォルトブランチ上にいる場合**: `<prefix>/<description>` 形式でブランチを作成
  - prefix例: `feat/`, `fix/`, `refactor/`, `docs/`, `chore/`
  - description: 変更内容を端的に表す英語のケバブケース（例: `feat/add-user-auth`）
- **既にフィーチャーブランチ上にいる場合**: ブランチ作成はスキップ

```bash
git checkout -b <prefix>/<description>
```

### Step 3: 変更のグルーピングとコミット

変更を論理的なまとまりに分割し、個別にコミットする。

#### 分割の優先順位

1. **機能的まとまり**: 同じ機能に関する変更をまとめる（最優先）
2. **変更の性質**: fix / feat / refactor / test / docs など性質が異なるものは分ける
3. **ディレクトリ**: 上記で判断できない場合、ディレクトリ単位で分ける

#### 分割が不要な場合

- 変更が小さく、1つの目的に収まる場合は1コミットで問題ない
- 無理に分割しない

#### コミットプレフィックス

以下のプレフィックスを使用する（git-commit スキル準拠）:

- `[FIX]` : バグや不具合の修正
- `[FEAT]` : 新機能の追加
- `[DOC]` : ドキュメントの更新や改善
- `[STYLE]` : コードフォーマットの修正、UIのみの変更
- `[REFACT]` : パフォーマンスの改善なしのコードの改善
- `[TEST]` : テストの追加や改善
- `[PREF]` : パフォーマンスの改善
- `[CHORE]` : ビルドプロセスの変更や改善
- `[DEL]` : コードの削除

```bash
# ファイル単位でステージングしてコミット
git add <files>
git commit -m "[FEAT] ユーザー認証機能を追加"
```

- `git add .` や `git add -A` は使わず、意図したファイルのみステージングする
- `.env` や credentials 等の機密ファイルは絶対にコミットしない

### Step 4: プッシュ

```bash
git push -u origin <branch_name>
```

- 必ず `-u` オプションでupstreamを設定する

### Step 5: Draft PR作成

```bash
gh pr create --draft --title "タイトル" --body "$(cat <<'EOF'
## 概要
- 変更の要約（1-3行）

## 変更内容
- 主要な変更点を箇条書き

## テスト計画
- [ ] テスト項目
EOF
)"
```

#### PR作成の要件

- **必ず `--draft`** でDraft PRとして作成
- `.github/PULL_REQUEST_TEMPLATE.md` が存在する場合はテンプレートの構造に準拠
- **全て日本語で記述**
- 簡潔さ優先: 重要なポイントのみ3-5項目程度
- `$ARGUMENTS` でマージ先が指定されていれば `--base` で指定。なければデフォルトブランチ

### 完了時

- 作成されたPRのURLを表示する
- コミット一覧を簡潔に表示する
