#!/bin/bash

# Start a Claude Code team member for a specific task

if [ $# -lt 1 ]; then
    echo "Usage: $0 <task-id> [member-id]"
    echo "Example: $0 task-001 member-1"
    exit 1
fi

TASK_ID="$1"
MEMBER_ID="${2:-member-$(date +%s)}"
TASK_FILE=".vibe/team/tasks/${TASK_ID}.json"

# Check if task file exists
if [ ! -f "$TASK_FILE" ]; then
    echo "Error: Task file not found: $TASK_FILE"
    exit 1
fi

# Create unique session name
SESSION="claude_member_${TASK_ID}_$(date +%s)"

echo "Starting team member..."
echo "  Task ID: $TASK_ID"
echo "  Member ID: $MEMBER_ID"
echo "  Session: $SESSION"

# Update task assignment
jq --arg member "$MEMBER_ID" '.assigned_to = $member' "$TASK_FILE" > "${TASK_FILE}.tmp" && mv "${TASK_FILE}.tmp" "$TASK_FILE"

# Start Claude Code in tmux with environment variables
tmux new-session -d -s "$SESSION" \
    "CLAUDE_ROLE=MEMBER CLAUDE_TASK_ID=$TASK_ID CLAUDE_MEMBER_ID=$MEMBER_ID claude"

# Update roster
ROSTER_FILE=".vibe/team/roster.json"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Add member to roster
jq --arg member "$MEMBER_ID" \
   --arg session "$SESSION" \
   --arg task "$TASK_ID" \
   --arg time "$TIMESTAMP" \
   '.members += [{
     "member_id": $member,
     "session_id": $session,
     "task_id": $task,
     "started_at": $time,
     "status": "active",
     "tmux_session": $session
   }] | .last_updated = $time' "$ROSTER_FILE" > "${ROSTER_FILE}.tmp" && mv "${ROSTER_FILE}.tmp" "$ROSTER_FILE"

echo "Team member started successfully!"
echo "To view the session: tmux attach -t $SESSION"