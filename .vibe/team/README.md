# Team State Directory

This directory contains the state management files for Claude Code team operations.

## Structure

- **roster.json** - Active team members and their tmux sessions
- **tasks/** - Task assignments (task-XXX.json files)
- **messages/** - Inter-team communication
  - **leader/** - Messages from leader to members
  - **members/** - Messages from members to leader
- **results/** - Work outputs from team members

## Task File Format

```json
{
  "task_id": "task-001",
  "assigned_to": "member-1",
  "created_at": "2025-07-20T12:00:00Z",
  "status": "pending|in_progress|completed|failed",
  "priority": "high|medium|low",
  "description": "Task description",
  "instructions": "Detailed instructions",
  "dependencies": [],
  "results_path": ".vibe/team/results/member-1/task-001/",
  "updates": []
}
```

## Message File Format

```json
{
  "message_id": "msg-001",
  "from": "leader|member-1",
  "to": "member-1|leader",
  "timestamp": "2025-07-20T12:00:00Z",
  "type": "directive|query|status|result",
  "content": "Message content",
  "requires_response": false,
  "response_to": null
}
```

## Roster Format

```json
{
  "leader": {
    "session_id": "claude_leader_XXX",
    "started_at": "2025-07-20T12:00:00Z",
    "status": "active|inactive"
  },
  "members": [
    {
      "member_id": "member-1",
      "session_id": "claude_member_XXX",
      "task_id": "task-001",
      "started_at": "2025-07-20T12:00:00Z",
      "status": "active|inactive|completed",
      "tmux_session": "claude_member_task-001_XXX"
    }
  ],
  "last_updated": "2025-07-20T12:00:00Z"
}
```