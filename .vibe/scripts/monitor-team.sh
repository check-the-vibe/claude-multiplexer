#!/bin/bash

# Monitor active team members and their tasks

echo "=== Team Status Monitor ==="
echo "Time: $(date)"
echo ""

ROSTER_FILE=".vibe/team/roster.json"
TASKS_DIR=".vibe/team/tasks"

# Check roster file
if [ ! -f "$ROSTER_FILE" ]; then
    echo "No team roster found."
    exit 1
fi

# Display leader status
echo "LEADER STATUS:"
LEADER_STATUS=$(jq -r '.leader.status // "inactive"' "$ROSTER_FILE")
LEADER_SESSION=$(jq -r '.leader.session_id // "none"' "$ROSTER_FILE")
echo "  Status: $LEADER_STATUS"
echo "  Session: $LEADER_SESSION"
echo ""

# Display member status
echo "TEAM MEMBERS:"
MEMBER_COUNT=$(jq '.members | length' "$ROSTER_FILE")

if [ "$MEMBER_COUNT" -eq 0 ]; then
    echo "  No active team members"
else
    jq -r '.members[] | "  \(.member_id):"' "$ROSTER_FILE" | while read -r member_line; do
        MEMBER_ID=$(echo "$member_line" | cut -d: -f1 | tr -d ' ')
        
        # Get member details
        MEMBER_DATA=$(jq -r --arg id "$MEMBER_ID" '.members[] | select(.member_id == $id)' "$ROSTER_FILE")
        TASK_ID=$(echo "$MEMBER_DATA" | jq -r '.task_id')
        SESSION=$(echo "$MEMBER_DATA" | jq -r '.tmux_session')
        STATUS=$(echo "$MEMBER_DATA" | jq -r '.status')
        
        echo "$member_line"
        echo "    Task: $TASK_ID"
        echo "    Session: $SESSION"
        echo "    Status: $STATUS"
        
        # Check if tmux session is still active
        if tmux has-session -t "$SESSION" 2>/dev/null; then
            echo "    Tmux: Active"
            
            # Get last 3 lines from session
            echo "    Recent output:"
            tmux capture-pane -t "$SESSION" -p -S -3 | sed 's/^/      /'
        else
            echo "    Tmux: Inactive (session ended)"
        fi
        
        # Check task status
        TASK_FILE="$TASKS_DIR/${TASK_ID}.json"
        if [ -f "$TASK_FILE" ]; then
            TASK_STATUS=$(jq -r '.status' "$TASK_FILE")
            echo "    Task Status: $TASK_STATUS"
            
            # Show last update
            LAST_UPDATE=$(jq -r '.updates[-1] // empty' "$TASK_FILE")
            if [ -n "$LAST_UPDATE" ]; then
                UPDATE_TIME=$(echo "$LAST_UPDATE" | jq -r '.timestamp')
                UPDATE_MSG=$(echo "$LAST_UPDATE" | jq -r '.message')
                echo "    Last Update: $UPDATE_TIME - $UPDATE_MSG"
            fi
        fi
        
        echo ""
    done
fi

echo "---"
echo "To attach to a session: tmux attach -t <session-name>"
echo "To refresh: $0"