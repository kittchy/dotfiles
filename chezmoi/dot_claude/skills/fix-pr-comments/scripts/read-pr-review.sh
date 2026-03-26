#!/bin/bash
set -euo pipefail

# jq query to group comments by thread
JQ_QUERY='
# Group by thread ID (use own ID if in_reply_to_id is null)
def thread_id: if .in_reply_to_id then .in_reply_to_id else .id end;

# Group by thread
group_by(thread_id) |
map({
  thread_id: .[0] | thread_id,
  file: .[0].path,
  line: .[0].line,
  position: .[0].position,
  comments: map({
    id: .id,
    user: .user.login,
    body: .body,
    created_at: .created_at,
    is_reply: (if .in_reply_to_id then true else false end)
  }) | sort_by(.created_at)
}) |
sort_by(.file, .line)
'

# Fetch PR comments and format with jq
COMMENTS=$(gh api "repos/:owner/:repo/pulls/$(gh pr view --json number -q .number)/comments")
if [ "$(echo "$COMMENTS" | jq '. | length')" -eq 0 ]; then
    echo "No review comments found."
    exit 0
fi

echo "$COMMENTS" | jq -r "$JQ_QUERY" | jq -r '
.[] |
"📁 \(.file):\(.line) (position: \(.position))",
"🧵 スレッドID: \(.thread_id)",
(.comments[] |
  if .is_reply then
    "  └─ 💬 \(.user): \(.body)"
  else
    "  🟢 \(.user): \(.body)"
  end
),
""
'
