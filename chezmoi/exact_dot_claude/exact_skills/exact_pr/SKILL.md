---
allowed-tools: Bash(gh:*), Bash(git:*)
description: PRの説明を生成し、GitHubで自動的にプルリクエストを作成
---

# プルリクエストの作成

このコマンドは、GitHubでプルリクエストを作成します。テンプレートに従った説明文を生成し、Draft PRとして作成します。

## 基本動作

1. @.github/PULL_REQUEST_TEMPLATE.md または @.github/pull_request_template.md のテンプレートを読み込む（存在する場合）
2. 現在のブランチの変更内容を分析（`git status`, `git diff`, `git log`）
3. 簡潔で要点を押さえた日本語のPR説明文を生成
4. `gh pr create --draft` でDraft PRを作成

## 重要な要件

- **Draft作成**: 必ず `--draft` オプションを使用してDraft PRとして作成すること
- **push設定**: push時は `git push -u origin <branch_name>` のように `--set-upstream` を指定すること
- **マージ先**: `$ARGUMENTS` で指定されたブランチにマージすること。指定がなければデフォルトブランチに向けること
- **テンプレート準拠**: PRテンプレートがある場合は構造を守り、全て日本語で記述すること
- **簡潔さ優先**: 冗長な説明を避け、重要なポイントのみを3-5項目程度で記載すること

## コマンド例

```bash
# default branchの特定方法
gh repo view --json "defaultBranchRef" --jq ".defaultBranchRef.name"

# 基本的な使用方法
gh pr create --draft --title "タイトル" --body "本文"

# マージ先を指定
gh pr create --draft --base develop --title "タイトル" --body "本文"

# ヒアドキュメントを使用した本文の指定
gh pr create --draft --title "タイトル" --body "$(cat <<'EOF'
本文内容
EOF
)"
```

## 生成される説明文の要件

1. **簡潔さ**: 1文で要約できる変更内容をタイトルに、本文は3-5項目の箇条書きで
2. **重要なポイント**: 何を変更したか（What）、なぜ変更したか（Why）に焦点を当てる
3. **読みやすさ**: 後から見返した時に変更の意図がすぐわかる程度の情報量
4. **日本語**: 全ての内容を日本語で記述
5. **過度な詳細を避ける**: 実装の細かい手順ではなく、変更の本質を伝える
