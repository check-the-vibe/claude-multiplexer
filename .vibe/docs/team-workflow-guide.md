# Team Workflow Guide

## Overview
This guide documents the complete workflow for Claude Code team-based operations.

## Team Leader Workflow

### 1. Initial Setup
When starting as a TEAM LEADER:

```bash
# Set environment
export CLAUDE_ROLE=LEADER

# Start Claude Code
claude
```

The leader will:
1. Check `.vibe/team/` structure
2. Load existing roster and tasks
3. Enter orchestration mode

### 2. Task Planning Phase

#### Breaking Down User Requirements
1. Analyze the user's request
2. Identify discrete, parallelizable tasks
3. Determine dependencies between tasks
4. Estimate complexity and duration

#### Creating Task Assignments
```json
{
  "task_id": "task-001",
  "description": "Implement user authentication",
  "instructions": "1. Create login endpoint\n2. Add JWT validation\n3. Write tests",
  "priority": "high",
  "context": {
    "relevant_files": ["src/auth/"],
    "dependencies": [],
    "constraints": ["Use existing JWT library"]
  }
}
```

### 3. Team Assembly

#### Starting Team Members
```bash
# Use helper script
.vibe/scripts/start-team-member.sh task-001

# Or manually
SESSION="claude_member_task-001_$(date +%s)"
tmux new-session -d -s "$SESSION" \
  "CLAUDE_ROLE=MEMBER CLAUDE_TASK_ID=task-001 claude"
```

#### Monitoring Active Members
```bash
# Use monitoring script
.vibe/scripts/monitor-team.sh

# Or check roster
jq '.members[] | select(.status == "active")' .vibe/team/roster.json
```

### 4. Coordination Phase

#### Handling Member Queries
1. Poll message directory: `.vibe/team/messages/leader/`
2. Read query messages
3. Create response in `.vibe/team/messages/members/`
4. Update task if needed

#### Managing Dependencies
- Track task completion order
- Hold dependent tasks until prerequisites complete
- Update task files with dependency status

### 5. Results Collection

#### Monitoring Progress
```bash
# Check task statuses
for task in .vibe/team/tasks/*.json; do
  echo "$(basename $task): $(jq -r .status $task)"
done
```

#### Aggregating Results
```bash
# Run aggregation script
.vibe/scripts/aggregate-results.sh

# Review aggregated report
cat .vibe/team/aggregated-results.md
```

### 6. Reporting to User
1. Summarize completed work
2. Highlight key achievements
3. Report any issues or blockers
4. Suggest next steps

## Team Member Workflow

### 1. Startup and Task Discovery
When starting as a TEAM MEMBER:

```bash
# Environment will be set by leader
# CLAUDE_ROLE=MEMBER
# CLAUDE_TASK_ID=task-001

# Member checks for task
if [ "$CLAUDE_ROLE" = "MEMBER" ]; then
  TASK_FILE=".vibe/team/tasks/${CLAUDE_TASK_ID}.json"
  # Read and parse task
fi
```

### 2. Task Execution

#### Understanding Assignment
1. Read task description and instructions
2. Review context (files, dependencies, constraints)
3. Plan approach
4. Create results directory

#### Progress Reporting
```bash
# Update task status
jq '.status = "in_progress" | 
    .updates += [{
      "timestamp": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'",
      "status": "in_progress",
      "message": "Starting implementation"
    }]' task.json > task.tmp && mv task.tmp task.json
```

### 3. Resource Management

#### Creating Sub-Sessions
For long-running operations within a task:
```bash
# Member creates own tmux session
SUB_SESSION="claude_sub_${TASK_ID}_$(date +%s)"
tmux new-session -d -s "$SUB_SESSION" 'npm run build'
```

#### Writing Results
```bash
# Create results structure
RESULTS_DIR=".vibe/team/results/${CLAUDE_MEMBER_ID}/${CLAUDE_TASK_ID}"
mkdir -p "$RESULTS_DIR"

# Write outputs
echo "Implementation complete" > "$RESULTS_DIR/summary.md"
cp src/feature.js "$RESULTS_DIR/"
```

### 4. Communication

#### Sending Messages to Leader
```json
{
  "message_id": "msg-$(date +%s)",
  "from": "member-1",
  "to": "leader",
  "timestamp": "2025-07-20T12:00:00Z",
  "type": "query",
  "content": "Need clarification on API endpoint format",
  "requires_response": true
}
```

#### Polling for Responses
```bash
# Check for new messages
INBOX=".vibe/team/messages/members/${CLAUDE_MEMBER_ID}"
find "$INBOX" -name "*.json" -newer .last_check
```

### 5. Task Completion

#### Final Status Update
1. Set task status to "completed"
2. Write final summary
3. Document any issues encountered
4. Clean up temporary resources

#### Session Cleanup
```bash
# Kill any sub-sessions created
tmux kill-session -t "$SUB_SESSION" 2>/dev/null

# Final task update
jq '.status = "completed"' task.json > task.tmp && mv task.tmp task.json
```

## Communication Protocol

### Message Types

1. **Directive**: Leader → Member
   - New instructions
   - Priority changes
   - Clarifications

2. **Query**: Member → Leader
   - Questions
   - Blockers
   - Resource requests

3. **Status**: Bidirectional
   - Progress updates
   - Milestone achievements
   - Health checks

4. **Result**: Member → Leader
   - Task completion
   - Deliverable locations
   - Summary reports

### Message Flow
```
Leader                          Member
  |                               |
  |-------- Task Assignment ----->|
  |                               |
  |<------- Status Update --------|
  |                               |
  |<--------- Query --------------|
  |                               |
  |-------- Response ------------>|
  |                               |
  |<------- Final Result ---------|
```

## Best Practices

### For Leaders
1. **Clear Task Definition**: Provide comprehensive instructions
2. **Reasonable Scope**: Keep tasks focused and achievable
3. **Active Monitoring**: Check member progress regularly
4. **Quick Response**: Address queries promptly
5. **Resource Management**: Don't overload the system

### For Members
1. **Immediate Start**: Begin work promptly after assignment
2. **Regular Updates**: Report progress frequently
3. **Early Escalation**: Raise blockers immediately
4. **Clean Output**: Organize results clearly
5. **Complete Cleanup**: Remove temporary resources

## Error Handling

### Common Issues and Solutions

1. **Member Session Crashes**
   - Leader detects via monitoring
   - Restart member with same task
   - Member resumes from last checkpoint

2. **Task Deadlock**
   - Circular dependencies detected
   - Leader reorganizes task order
   - Manual intervention if needed

3. **Resource Exhaustion**
   - Monitor system resources
   - Limit concurrent members
   - Queue additional tasks

4. **Communication Failure**
   - File locking issues
   - Use atomic operations
   - Implement retry logic

## Testing the System

### Simple Test Scenario
1. Leader creates 3 tasks:
   - Task A: Create a file
   - Task B: Modify the file
   - Task C: Validate the file

2. Start members for each task
3. Monitor progress
4. Aggregate results
5. Verify output

### Complex Test Scenario
1. Web application with:
   - Frontend task
   - Backend task
   - Database task
   - Testing task

2. Dependencies:
   - Testing depends on all others
   - Frontend depends on Backend API

3. Parallel execution where possible
4. Serial execution for dependencies

## Troubleshooting

### Checking System State
```bash
# List all Claude tmux sessions
tmux ls | grep claude_

# Check task statuses
find .vibe/team/tasks -name "*.json" -exec jq -r '{file: input_filename, status: .status}' {} \;

# View recent messages
find .vibe/team/messages -name "*.json" -mmin -10
```

### Recovery Procedures
1. **Orphaned Sessions**: Kill and restart
2. **Corrupted State**: Restore from backups
3. **Locked Files**: Clear locks and retry
4. **Missing Results**: Check member logs

## Performance Considerations

### Scaling Limits
- Recommended: 3-5 concurrent members
- Maximum tested: 10 members
- Factors: System resources, task complexity

### Optimization Tips
1. Use task queuing for many tasks
2. Implement health checks
3. Monitor resource usage
4. Archive old results
5. Clean up completed sessions

## Future Enhancements

### Planned Features
1. Web UI for monitoring
2. Advanced scheduling
3. Resource allocation
4. Performance metrics
5. Automated testing

### Extension Points
1. Custom message types
2. Plugin architecture
3. External integrations
4. Advanced workflows
5. Multi-project support