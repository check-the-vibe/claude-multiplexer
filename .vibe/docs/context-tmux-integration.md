# Context: Tmux Integration for Long-Running Tasks

**Created:** 2025-07-20
**Last Updated:** 2025-07-20
**Related Tasks:** Sprint - Long-running tasks in tmux

## Overview
Research and design for integrating tmux to handle long-running tasks in Claude workflows.

## Problem Statement
Claude currently blocks on long-running commands like `npm run dev` or interactive installers. This prevents Claude from:
- Continuing with other tasks while processes run
- Monitoring output from long-running processes
- Handling interactive prompts effectively

## Tmux Command Research

### Session Management
```bash
# Create new detached session with name
tmux new-session -d -s session_name 'command'

# List sessions
tmux list-sessions

# Check if session exists
tmux has-session -t session_name 2>/dev/null

# Kill session
tmux kill-session -t session_name
```

### Command Execution
```bash
# Send command to session
tmux send-keys -t session_name 'command' Enter

# Run command in new window
tmux new-window -t session_name -n window_name 'command'
```

### Output Capture
```bash
# Capture pane output to file
tmux capture-pane -t session_name -p > output.txt

# Capture with history (-S for start line, -E for end)
tmux capture-pane -t session_name -p -S -1000

# Show pane output in real-time
tmux attach-session -t session_name
```

### Monitoring
```bash
# Check if process is still running
tmux list-panes -t session_name -F '#{pane_pid}'

# Get exit status of last command
tmux display-message -p -t session_name '#{pane_dead_status}'
```

## Proposed Workflow

### For Long-Running Tasks (e.g., npm run dev)
1. Create tmux session with descriptive name
2. Run command in session
3. Detach immediately
4. Periodically check output using capture-pane
5. Kill session when done

### For Interactive Tasks (e.g., create-react-app)
1. Create tmux session
2. Send initial command
3. Monitor output for prompts
4. Send responses via send-keys
5. Capture final state

## Implementation Strategy

### Session Naming Convention
- Format: `claude_[task_type]_[timestamp]`
- Examples: `claude_dev_server_1234567890`, `claude_installer_1234567891`

### Output Management
- Capture output every few seconds for monitoring
- Store in temporary files if needed
- Parse for errors or success indicators

### Error Handling
- Check session existence before operations
- Handle tmux command failures gracefully
- Provide fallback to regular bash execution

## Test Scenarios

1. **Dev Server Test**
   - Start npm run dev in tmux
   - Verify detachment
   - Check output capture
   - Kill session

2. **Interactive Installer Test**
   - Run create-react-app equivalent
   - Handle prompts
   - Verify completion

3. **Multiple Sessions Test**
   - Run multiple long tasks
   - Manage separately
   - Clean up properly

## Benefits
- Non-blocking execution
- Output monitoring capability
- Interactive command support
- Better resource management
- Ability to run multiple tasks

## Considerations
- Session cleanup on errors
- Unique naming to avoid conflicts
- Output buffer limitations
- Permission requirements