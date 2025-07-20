# CLAUDE.md - Claude Operations Guide

## Overview
This document provides project-specific instructions for Claude's task execution. It follows best practices for concise, declarative guidance that maximizes Claude's effectiveness.

## Startup Behavior

On startup, Claude must:
1. Check environment variable `CLAUDE_ROLE` to determine operating mode
2. If `CLAUDE_ROLE=LEADER`, operate as Team Leader (see Team-Based Execution Mode)
3. If `CLAUDE_ROLE=MEMBER`, check `CLAUDE_TASK_ID` and operate as Team Member
4. If neither is set, operate in traditional single-instance mode

For team operations, immediately consult the "Team-Based Execution Mode" section below.

## Core Principles

### 1. Documentation First
- Always document before executing
- Maintain clear, accessible records of all actions
- Update documentation immediately after task completion

### 2. Structured Communication
- Be explicit about capabilities and limitations
- Provide clear reasoning for decisions
- Maintain consistent formatting across all outputs

### 3. Context Awareness
- Always check existing documentation before proceeding
- Build upon previous work rather than duplicating
- Maintain awareness of project state and history

### 4. Workflow Approach
- Follow "explore-plan-code-commit" workflow
- Use parallel tool execution for efficiency
- Request clarification before complex tasks

## Project Structure Requirements

### Directory Setup
Claude must ensure the following structure exists in the project root:

```
project-root/
├── .vibe/
│   ├── TASKS.md
│   ├── ENVIRONMENT.md
│   └── docs/
│       ├── context-{topic}.md
│       ├── decisions-{date}.md
│       └── dependencies.md
└── CLAUDE.md (this file)
```

## Task Execution Protocol

### Order of Operations

1. **Initialize Environment**
   - Check for .vibe directory existence
   - Create missing structure components
   - Verify file permissions

2. **Read Current State**
   - Load TASKS.md
   - Review ENVIRONMENT.md
   - Scan .vibe/docs for relevant context

3. **Document Intent**
   - Create/update relevant docs in .vibe/docs
   - Document approach and reasoning
   - Note any assumptions or dependencies

4. **Execute Task**
   - Perform the requested action
   - Capture outputs and results
   - Handle errors gracefully

5. **Update Records**
   - Update task status in TASKS.md
   - Document results in .vibe/docs
   - Update ENVIRONMENT.md if needed

## File Specifications

### TASKS.md Format

```markdown
# Project Tasks

## Active Tasks

### TASK-YYYY-MM-DD-XXX: [Task Title]
- **Status**: PENDING | IN_PROGRESS | COMPLETED | BLOCKED | CANCELLED
- **Priority**: HIGH | MEDIUM | LOW
- **Created**: YYYY-MM-DD HH:MM
- **Updated**: YYYY-MM-DD HH:MM
- **Due**: YYYY-MM-DD (if applicable)
- **Estimated Time**: X hours/minutes
- **Description**: Clear, detailed task description
- **Acceptance Criteria**: 
  - [ ] Specific, measurable criterion 1
  - [ ] Specific, measurable criterion 2
- **Dependencies**: Task IDs or external dependencies
- **Context Files**: 
  - .vibe/docs/context-XXX.md
- **Progress Log**:
  - YYYY-MM-DD HH:MM - Task created
  - YYYY-MM-DD HH:MM - [Progress update]
- **Notes**: Additional context or blockers

## Completed Tasks
[Archive with completion date and summary]

## Scheduled Tasks
[Future tasks with estimated start dates]
```

### ENVIRONMENT.md Format

```markdown
# Environment Configuration

## System Information
- **OS**: [Operating System]
- **Claude Version**: [Version info]
- **Project Type**: [Type of project]
- **Last Updated**: YYYY-MM-DD

## Available Tools
- **Python**: 3.12.1 - General programming and scripting
- **Node.js**: 22.17.0 - JavaScript runtime
- **npm**: 9.8.1 - Package management
- **Git**: 2.50.1 - Version control
- **Bash**: 5.2.21 - Shell scripting

## Required Programs
- **tmux**: Terminal multiplexer for session management
- **curl**: Command-line tool for transferring data
- **jq**: Lightweight JSON processor

## Project Dependencies
- Dependency 1: Version and purpose
- Dependency 2: Version and purpose

## Configuration Notes
[Any special configuration or setup notes]

## Known Limitations
[Document any environmental constraints]
```

### Context Documentation (.vibe/docs/)

Each context file should follow:

```markdown
# Context: [Topic]

## Overview
Brief description of this context

## Key Information
- Important point 1
- Important point 2

## Related Files
- Link to related documentation
- Link to relevant code

## History
- YYYY-MM-DD: Initial creation
- YYYY-MM-DD: Major update

## Notes
Additional observations or considerations
```

## Best Practices for Claude

### 1. Communication
- Always acknowledge task receipt
- Provide progress updates for long-running tasks
- Clearly communicate any blockers or issues
- Use structured formats for consistency

### 2. Error Handling
- Anticipate common failure modes
- Provide helpful error messages
- Suggest remediation steps
- Document errors in task notes

### 3. Code Generation
- Include comprehensive comments
- Follow project style guides
- Test generated code when possible
- Provide usage examples

### 4. Documentation
- Write for future Claude instances
- Include context and reasoning
- Use clear, searchable titles
- Maintain consistent formatting

### 5. Task Management
- Break complex tasks into subtasks
- Estimate effort realistically
- Update status promptly
- Archive completed work properly

## Quality Checklist

Before marking any task complete:
- [ ] All acceptance criteria met
- [ ] Documentation updated
- [ ] Results verified
- [ ] Context preserved for future use
- [ ] Dependencies documented
- [ ] Error cases handled

## Version Control Integration

When working with version-controlled projects:
- Respect .gitignore patterns
- Document significant changes
- Maintain clean commit messages
- Note branch/version information

## Security Considerations

- Never expose sensitive credentials
- Sanitize logs and outputs
- Follow project security policies
- Document security decisions

## Maintenance Protocol

### Daily Operations
1. Review active tasks
2. Update task statuses
3. Archive completed items
4. Plan upcoming work

### Weekly Reviews
1. Clean up documentation
2. Archive old contexts
3. Update environment info
4. Optimize file organization

## Notes for Future Claude Instances

This guide ensures consistency across all Claude interactions with this project. Always:
- Start by reading this guide
- Check existing documentation
- Maintain the established structure
- Leave the project better documented than you found it

## Prompting Best Practices

### Effective Communication with Claude
1. **Be Explicit and Direct**
   - Use clear, detailed instructions
   - Specify frameworks, constraints, and success criteria
   - Request comprehensive results when needed

2. **Provide Context and Motivation**
   - Explain why tasks are needed
   - Give background for better generalization
   - Include relevant constraints

3. **Use Structured Formats**
   - Break complex requests into numbered steps
   - Use markdown formatting consistently
   - Provide examples when helpful

## Workflow Guidelines

### Explore-Plan-Code-Commit Workflow
1. **Explore**: Read relevant files and understand context
2. **Plan**: Create detailed approach with reasoning
3. **Code**: Implement solution following plan
4. **Commit**: Verify work and update documentation

### Parallel Execution
- Use multiple tool calls simultaneously for efficiency
- Batch independent operations
- Leverage concurrent file reads and searches

## Memory Management

### Memory Types
- **Project Memory**: This CLAUDE.md file (team-shared)
- **User Memory**: ~/.claude/CLAUDE.md (personal preferences)
- **Local Memory**: CLAUDE.local.md (deprecated)

### Quick Tips
- Start input with `#` to quickly add memories
- Use `@path/to/file.md` to import other documents
- Review and update memories periodically

## Long-Running Task Management with Tmux

### Decision Criteria for Tmux Usage

Use tmux for commands that:
1. Run indefinitely (dev servers, watch processes)
2. Take > 30 seconds to complete
3. Require interactive input
4. Block the terminal

### Tmux Workflow Guidelines

#### 1. Development Servers (npm run dev, python manage.py runserver)
```bash
# Start server in detached tmux session
SESSION="claude_dev_$(date +%s)"
tmux new-session -d -s "$SESSION" 'npm run dev'

# Check output after startup
sleep 3
tmux capture-pane -t "$SESSION" -p -S -20

# Monitor periodically
tmux capture-pane -t "$SESSION" -p -S -10

# Clean shutdown
tmux send-keys -t "$SESSION" C-c
sleep 1
tmux kill-session -t "$SESSION"
```

#### 2. Long-Running Builds (npm install, make)
```bash
# Start build in tmux
SESSION="claude_build_$(date +%s)"
tmux new-session -d -s "$SESSION" 'npm install'

# Wait for completion
while tmux has-session -t "$SESSION" 2>/dev/null; do
    sleep 2
done

# Capture output
tmux capture-pane -t "$SESSION" -p
```

#### 3. Interactive Commands (create-react-app, npm init)
```bash
# Start interactive process
SESSION="claude_interactive_$(date +%s)"
tmux new-session -d -s "$SESSION" 'npx create-react-app myapp'

# Inform user how to attach
echo "Interactive session started. User can attach with:"
echo "tmux attach -t $SESSION"
```

### Tmux Session Rules

1. **Always use unique session names**: `claude_[type]_[timestamp]`
2. **Always clean up sessions** after use
3. **Check session existence** before operations
4. **Capture output** before killing sessions
5. **Handle tmux errors** gracefully

### Output Monitoring

For long-running processes, check output periodically:
```bash
# Last 10 lines of output
tmux capture-pane -t "$SESSION" -p -S -10

# Full pane content
tmux capture-pane -t "$SESSION" -p

# Save to file
tmux capture-pane -t "$SESSION" -p > output.log
```

## Team-Based Execution Mode

### Overview
Claude Code can operate in two distinct modes:
- **TEAM LEADER**: Orchestrates, delegates, and coordinates team activities
- **TEAM MEMBER**: Executes specific tasks assigned by the leader

### Role Detection
Claude determines its role on startup by checking:
1. Environment variable `CLAUDE_ROLE` (LEADER or MEMBER)
2. Environment variable `CLAUDE_TASK_ID` (for members)
3. Default behavior: Single-instance mode (traditional)

### Team Structure
```
.vibe/
├── team/
│   ├── roster.json          # Active team members and sessions
│   ├── tasks/               # Task assignments
│   │   └── task-XXX.json
│   ├── messages/            # Inter-team communication
│   │   ├── leader/
│   │   └── members/
│   └── results/             # Member work outputs
```

### TEAM LEADER Responsibilities

1. **Task Planning**
   - Analyze user requirements
   - Break down complex tasks
   - Determine team composition
   - Create task assignments

2. **Team Management (MANDATORY PARALLEL EXECUTION)**
   - **MUST** start actual team members as separate Claude instances in tmux sessions
   - **MUST NOT** simulate team work - always spawn real Claude processes
   - **MUST** execute team members in parallel, not sequentially
   - Monitor member progress via tmux output capture
   - Handle member queries via message files
   - Coordinate dependencies between parallel workers

3. **Communication**
   - Relay user instructions to members
   - Aggregate member results
   - Report status to user
   - Handle exceptions

4. **Orchestration Workflow**
   ```bash
   # Create task assignment
   echo '{"task_id":"task-001",...}' > .vibe/team/tasks/task-001.json
   
   # Start team member
   SESSION="claude_member_task-001_$(date +%s)"
   tmux new-session -d -s "$SESSION" \
     "CLAUDE_ROLE=MEMBER CLAUDE_TASK_ID=task-001 claude"
   
   # Monitor progress
   while [ "$(jq -r .status .vibe/team/tasks/task-001.json)" != "completed" ]; do
     sleep 5
   done
   ```

### TEAM MEMBER Responsibilities

1. **Task Execution**
   - Read assigned task on startup
   - Execute task instructions
   - Update progress regularly
   - Write results to designated location

2. **Communication**
   - Report status updates
   - Request clarification when needed
   - Signal completion or failure
   - Document findings

3. **Resource Management**
   - Create own tmux sessions for long tasks
   - Clean up temporary resources
   - Manage task-specific state

4. **Member Workflow**
   ```bash
   # On startup, check role
   if [ "$CLAUDE_ROLE" = "MEMBER" ]; then
     # Read task assignment
     TASK_FILE=".vibe/team/tasks/${CLAUDE_TASK_ID}.json"
     
     # Execute task
     # Update status
     # Write results
   fi
   ```

### Task File Format
```json
{
  "task_id": "task-001",
  "created_at": "2025-07-20T12:00:00Z",
  "assigned_to": "member-1",
  "status": "pending|in_progress|completed|failed",
  "priority": "high|medium|low",
  "description": "Clear task description",
  "instructions": "Detailed step-by-step instructions",
  "context": {
    "relevant_files": [],
    "dependencies": [],
    "constraints": []
  },
  "results_path": ".vibe/team/results/member-1/task-001/",
  "updates": [
    {
      "timestamp": "2025-07-20T12:05:00Z",
      "status": "in_progress",
      "message": "Started implementation"
    }
  ]
}
```

### Message Protocol
Members and leaders communicate via JSON files:
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

### Best Practices for Team Operations

1. **Task Decomposition**
   - Keep member tasks focused and specific
   - Provide clear success criteria
   - Include all necessary context
   - Avoid overlapping responsibilities

2. **Communication**
   - Use structured message formats
   - Poll for messages regularly
   - Acknowledge receipt of directives
   - Document decisions and rationale

3. **Error Handling**
   - Members should fail gracefully
   - Leader monitors for timeouts
   - Implement retry mechanisms
   - Escalate blockers promptly

4. **Resource Management**
   - Limit concurrent team members
   - Monitor system resources
   - Clean up completed sessions
   - Archive results systematically

### Team Startup Checklist

#### For TEAM LEADER:
- [ ] Check .vibe/team/ structure exists
- [ ] Load current roster state
- [ ] Review pending tasks
- [ ] Plan team composition
- [ ] Start monitoring loops

#### For TEAM MEMBER:
- [ ] Verify CLAUDE_TASK_ID is set
- [ ] Load task assignment
- [ ] Create results directory
- [ ] Begin task execution
- [ ] Set up status reporting

### Helper Scripts Location
Team management scripts are available in:
- `.vibe/scripts/start-team-member.sh`
- `.vibe/scripts/monitor-team.sh`
- `.vibe/scripts/aggregate-results.sh`

## Program Installation Procedures

### Installing Required Programs

For Debian/Ubuntu systems (like this Codespace):
```bash
# Update package list
sudo apt-get update

# Install tmux
sudo apt-get install -y tmux

# Install curl (usually pre-installed)
sudo apt-get install -y curl

# Install jq
sudo apt-get install -y jq
```

For verification:
```bash
tmux -V
curl --version
jq --version
```

---
*Last Updated: 2025-07-20*
*Version: 3.0*