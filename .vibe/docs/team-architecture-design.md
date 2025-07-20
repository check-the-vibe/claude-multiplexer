# Claude Code Team Architecture Design

## Overview
This document outlines the architecture for running Claude Code in a team-based mode with LEADER and MEMBER roles.

## Key Design Decisions

### 1. Execution Model
Based on research, we'll use:
- **Shared Project Root**: All Claude instances run against the same project root
- **Tmux Sessions**: Each MEMBER runs in a dedicated tmux session
- **Shared State Directory**: `.vibe/team/` for inter-process communication
- **Role-based CLAUDE.md**: Different instructions based on role

### 2. Communication Architecture

#### State Management
```
.vibe/
├── team/
│   ├── roster.json          # Active team members and their sessions
│   ├── tasks/               # Task assignments and status
│   │   ├── task-001.json
│   │   └── task-002.json
│   ├── messages/            # Inter-team communication
│   │   ├── leader/
│   │   └── members/
│   └── results/             # Member work outputs
│       ├── member-1/
│       └── member-2/
```

#### Message Protocol
- File-based messaging using JSON files
- Polling mechanism for checking new messages
- Structured message format with timestamps and routing

### 3. Role Definitions

#### TEAM LEADER
- Orchestrates and assigns tasks
- Monitors team progress
- Handles user interaction
- Collates results
- Makes strategic decisions

#### TEAM MEMBER
- Executes assigned tasks
- Reports progress and results
- Can spawn own tmux sessions for long tasks
- Follows specific task instructions
- Writes results to designated areas

### 4. Workflow Patterns

#### Task Assignment Flow
1. Leader creates task file in `.vibe/team/tasks/`
2. Leader starts member in tmux with task ID
3. Member reads task and begins execution
4. Member updates task status periodically
5. Member writes results when complete
6. Leader monitors and collates results

#### Communication Flow
1. Members poll for messages in their inbox
2. Leader can send directives via message files
3. Members can request clarification
4. All communication is logged

### 5. Implementation Approach

#### Starting a Team Member
```bash
# Create unique session name
SESSION="claude_member_${TASK_ID}_$(date +%s)"

# Start Claude Code with specific parameters
tmux new-session -d -s "$SESSION" \
  "CLAUDE_ROLE=MEMBER CLAUDE_TASK_ID=${TASK_ID} claude"
```

#### Member Discovery on Startup
1. Check environment variables for role
2. Read task assignment if MEMBER
3. Configure behavior based on role
4. Start appropriate workflow

### 6. Benefits of This Approach

1. **No Code Conflicts**: Shared filesystem with coordination
2. **Scalable**: Can run many members in parallel
3. **Observable**: All communication through files
4. **Resumable**: State persists across restarts
5. **Debuggable**: Clear audit trail of all actions

### 7. Challenges and Solutions

#### Challenge: Race Conditions
**Solution**: Use atomic file operations and unique IDs

#### Challenge: Member Failures  
**Solution**: Health checks and status monitoring

#### Challenge: Resource Limits
**Solution**: Configurable member limits and queuing

## Next Steps
1. Update CLAUDE.md with role detection
2. Create helper scripts for team management
3. Implement message passing system
4. Test with simple scenario