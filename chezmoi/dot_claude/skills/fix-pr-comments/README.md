# review-pr-comments スキル

PRのレビューコメントを取得し、各コメントに対して体系的に対応するスキルです。

## 機能

1. **レビューコメントの取得と表示**: PRのすべてのレビューコメントをスレッドごとに整理して表示
2. **自動分析**: 各コメントを分析し、必要な変更を特定
3. **対話的な対応**: ユーザーと確認しながら、各レビューポイントに対応
4. **進捗管理**: Todoリストで対応状況を追跡
5. **まとめと次のステップ**: すべての対応後、変更内容をまとめて次のアクションを提案

## 使い方

現在のブランチに関連付けられたPRのレビューに対応するには：

```bash
/review-pr-comments
```

または、Claude Codeで以下のように依頼します：

```
PRのレビューに対応してください
```

```
レビューコメントを確認して修正してください
```

## 前提条件

1. **GitHub CLI (`gh`) がインストールされていること**

   ```bash
   gh --version
   ```

2. **GitHub CLI が認証されていること**

   ```bash
   gh auth status
   ```

3. **`jq` がインストールされていること**

   ```bash
   jq --version
   ```

   インストールしていない場合：

   ```bash
   # macOS
   brew install jq

   # Ubuntu/Debian
   sudo apt-get install jq
   ```

4. **現在のブランチにPRが関連付けられていること**

   ```bash
   gh pr view
   ```

## 出力形式

スキルは以下の形式でコメントを表示します：

```
📁 ファイルパス:行番号 (position: ポジション番号)
🧵 スレッドID: [スレッドID]
  🟢 [ユーザー名]: [コメント本文]
  └─ 💬 [ユーザー名]: [返信コメント]
  └─ 💬 [ユーザー名]: [返信コメント]

📁 別のファイルパス:行番号 (position: ポジション番号)
🧵 スレッドID: [スレッドID]
  🟢 [ユーザー名]: [コメント本文]

...
```

### 記号の意味

- 📁: ファイルパスと行番号
- 🧵: スレッド（ディスカッション）の識別子
- 🟢: スレッドを開始した最初のコメント
- 💬: 返信コメント（スレッド内の追加コメント）

## トラブルシューティング

### エラー: "no pull requests found"

現在のブランチにPRが関連付けられていません。以下を確認してください：

1. 正しいブランチにいるか確認

   ```bash
   git branch --show-current
   ```

2. PRが作成されているか確認

   ```bash
   gh pr list --head $(git branch --show-current)
   ```

### エラー: "jq: command not found"

`jq` がインストールされていません。上記の「前提条件」を参照してインストールしてください。

### エラー: "gh: command not found"

GitHub CLI がインストールされていません。以下を参照してインストールしてください：
<https://cli.github.com/>

### レビューコメントが表示されない

PRにレビューコメントがまだ投稿されていない可能性があります。以下で確認できます：

```bash
gh pr view --web
```

## ワークフロー例

```
ユーザー: /review-pr-comments

Claude: PRのレビューコメントを取得します...

📁 backend/src/api/routes/capsules.py:45 (position: 123)
🧵 スレッドID: 1234567890
  🟢 reviewer1: エラーハンドリングを追加してください

📁 frontend/src/components/CapsuleCard.tsx:28 (position: 456)
🧵 スレッドID: 1234567891
  🟢 reviewer2: TypeScriptの型定義が不足しています

---

Todoリストを作成しました：
1. ⏳ backend/src/api/routes/capsules.py:45 のレビューに対応
2. ⏳ frontend/src/components/CapsuleCard.tsx:28 のレビューに対応

---

📍 1つ目のレビューに対応します: backend/src/api/routes/capsules.py:45

[ファイルを読み込み、コードを分析...]

現在のコード:
```python
def create_capsule(capsule_data: dict):
    return db.save(capsule_data)
```

レビュー: "エラーハンドリングを追加してください"

提案される変更:

```python
def create_capsule(capsule_data: dict):
    try:
        return db.save(capsule_data)
    except Exception as e:
        logger.error(f"Failed to create capsule: {e}")
        raise HTTPException(status_code=500, detail="Failed to create capsule")
```

この変更を実装してよろしいですか？

ユーザー: はい

Claude: [変更を実装...]
✅ 1つ目のレビューに対応完了

📍 2つ目のレビューに対応します: frontend/src/components/CapsuleCard.tsx:28

[次のレビューに対応...]

---

すべてのレビューに対応しました！

変更内容のまとめ:

- backend/src/api/routes/capsules.py: エラーハンドリングを追加
- frontend/src/components/CapsuleCard.tsx: 型定義を追加

次のステップ:

1. テストを実行して変更を確認
2. GitHubのレビュースレッドに返信
3. 変更をコミット

コミットしますか？

```

## 実装の詳細

このスキルは以下の処理を行います：

### フェーズ1: コメント取得
1. GitHub APIを使用して現在のPRのレビューコメントを取得
2. `jq` を使用してコメントをスレッドIDでグループ化
3. ファイル名と行番号でソート
4. ツリー構造で表示（親コメントと返信を区別）

### フェーズ2: 対応計画
1. 各コメントのファイルと行番号を抽出
2. Todoリストを作成して進捗を追跡

### フェーズ3: 実装
1. 各コメントについて、該当ファイルを読み込み
2. コードのコンテキストを理解
3. レビューコメントに基づいて変更を提案
4. ユーザーの承認を得て実装
5. 次のコメントに進む

### フェーズ4: まとめ
1. すべての変更を要約
2. テストの実行を提案
3. コミットやPRの更新を支援

スレッドの判定：
- `in_reply_to_id` が `null` の場合: 新しいスレッドの開始
- `in_reply_to_id` に値がある場合: 既存スレッドへの返信
