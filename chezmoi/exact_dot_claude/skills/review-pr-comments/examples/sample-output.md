# Sample Output

## Step 1: Fetch PR Comments

```
📁 backend/src/api/routes/capsules.py:45 (position: 123)
🧵 スレッドID: 1234567890
  🟢 reviewer1: This function should handle edge cases better
  └─ 💬 author: Good point, I'll add validation

📁 frontend/src/components/Header.tsx:12 (position: 456)
🧵 スレッドID: 1234567891
  🟢 reviewer2: Consider using useMemo here for performance
```

## Step 2: Todo List Created

```
✅ Todo list created with 2 items
```

## Step 3: Address Comments

```
📍 Working on: backend/src/api/routes/capsules.py:45
[Reading file...]
[Analyzing comment: "This function should handle edge cases better"]

現在のコード:
def create_capsule(capsule_data):
    return db.save(capsule_data)

レビューコメント: "This function should handle edge cases better"

提案される変更:
- capsule_data のバリデーションを追加
- エラーハンドリングを実装

この変更を実装してよろしいですか？

[User approves]

[Implementing changes...]
✅ Changes implemented
✅ Todo item completed
```

## Example: Rejecting Invalid Suggestion

```
📍 Working on: frontend/src/components/Header.tsx:12

現在のコード:
const SITE_TITLE = "My App";

レビューコメント: "Consider using useMemo here for performance"

評価結果:
- この値は静的な文字列定数であり、再計算は発生しません
- useMemoの追加はオーバーヘッドになり、むしろパフォーマンスが悪化します

結論: このコメントは技術的に不適切と判断されます。

✅ Todo item marked as completed (not implemented - justified)
📝 Note: Will suggest user to reply explaining why useMemo is not appropriate here
```
