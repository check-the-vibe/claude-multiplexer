# Tmux Workflow Design for Claude

**Created:** 2025-07-20
**Related Tasks:** Sprint - Long-running tasks in tmux

## Workflow Categories

### 1. Development Servers (npm run dev, python manage.py runserver, etc.)

**Characteristics:**
- Long-running, non-terminating
- Continuous output (logs, errors)
- Need to monitor for startup completion
- May need to be stopped/restarted

**Workflow:**
```bash
# 1. Start server in tmux
SESSION_NAME="claude_dev_$(date +%s)"
tmux new-session -d -s "$SESSION_NAME" 'npm run dev'

# 2. Wait for startup (check for success indicators)
sleep 3
tmux capture-pane -t "$SESSION_NAME" -p | grep -q "Server running" && echo "Server started"

# 3. Monitor periodically
tmux capture-pane -t "$SESSION_NAME" -p -S -10  # Last 10 lines

# 4. Clean shutdown when needed
tmux send-keys -t "$SESSION_NAME" C-c
sleep 1
tmux kill-session -t "$SESSION_NAME"
```

### 2. Build/Install Commands (npm install, pip install, make, etc.)

**Characteristics:**
- Finite duration
- Progress indicators
- Exit codes matter
- May have warnings to capture

**Workflow:**
```bash
# 1. Start build in tmux
SESSION_NAME="claude_build_$(date +%s)"
tmux new-session -d -s "$SESSION_NAME" 'npm install'

# 2. Wait for completion with timeout
TIMEOUT=300  # 5 minutes
START_TIME=$(date +%s)
while tmux list-sessions | grep -q "$SESSION_NAME"; do
    if [ $(($(date +%s) - START_TIME)) -gt $TIMEOUT ]; then
        echo "Build timeout"
        tmux kill-session -t "$SESSION_NAME"
        break
    fi
    sleep 2
done

# 3. Capture final output
tmux capture-pane -t "$SESSION_NAME" -p > build_output.txt
```

### 3. Interactive Installers (create-react-app, vue create, etc.)

**Characteristics:**
- Require user input
- Multiple prompts
- Variable paths based on choices
- Need to parse prompts

**Workflow:**
```bash
# 1. Start interactive process
SESSION_NAME="claude_interactive_$(date +%s)"
tmux new-session -d -s "$SESSION_NAME" 'npx create-react-app myapp'

# 2. Monitor for prompts
while true; do
    OUTPUT=$(tmux capture-pane -t "$SESSION_NAME" -p -S -5)
    
    # Check for specific prompts
    if echo "$OUTPUT" | grep -q "Would you like to"; then
        tmux send-keys -t "$SESSION_NAME" 'y' Enter
    elif echo "$OUTPUT" | grep -q "Choose a template"; then
        tmux send-keys -t "$SESSION_NAME" '1' Enter
    elif echo "$OUTPUT" | grep -q "Happy hacking"; then
        break
    fi
    
    sleep 1
done
```

## Implementation Guidelines for CLAUDE.md

### Decision Tree for Command Execution

1. **Is it a long-running server?**
   - YES → Use tmux with monitoring
   - NO → Continue to #2

2. **Does it take > 30 seconds?**
   - YES → Use tmux with completion check
   - NO → Continue to #3

3. **Is it interactive?**
   - YES → Use tmux with prompt handling
   - NO → Use regular bash execution

### Tmux Session Management Rules

1. **Naming Convention**
   - Pattern: `claude_[type]_[timestamp]`
   - Types: dev, build, test, interactive
   - Always use timestamps to ensure uniqueness

2. **Cleanup Protocol**
   - Always kill sessions after use
   - Check for orphaned sessions on startup
   - Implement timeout mechanisms

3. **Output Handling**
   - Capture incrementally for long processes
   - Store full output for completed processes
   - Parse for errors and success indicators

4. **Error Recovery**
   - Check session existence before operations
   - Fallback to regular execution on tmux errors
   - Log all tmux-related failures

### Code Templates for CLAUDE.md

#### Template 1: Long-Running Server
```bash
# For commands like: npm run dev, python manage.py runserver
run_in_tmux_server() {
    local cmd="$1"
    local session="claude_dev_$(date +%s)"
    
    tmux new-session -d -s "$session" "$cmd"
    echo "Started in tmux session: $session"
    
    # Initial output check
    sleep 3
    tmux capture-pane -t "$session" -p -S -20
}
```

#### Template 2: Build Process
```bash
# For commands like: npm install, make, cargo build
run_in_tmux_build() {
    local cmd="$1"
    local session="claude_build_$(date +%s)"
    
    tmux new-session -d -s "$session" "$cmd"
    
    # Wait for completion
    while tmux has-session -t "$session" 2>/dev/null; do
        sleep 2
    done
    
    # Capture and display output
    tmux capture-pane -t "$session" -p
}
```

#### Template 3: Interactive Process
```bash
# For commands like: npm init, create-react-app
run_in_tmux_interactive() {
    local cmd="$1"
    local session="claude_interactive_$(date +%s)"
    
    echo "Starting interactive process in tmux session: $session"
    echo "User should attach with: tmux attach -t $session"
    tmux new-session -d -s "$session" "$cmd"
}
```

## Testing Strategy

### Test Cases

1. **Simple Dev Server**
   - Command: `python -m http.server 8000`
   - Verify: Starts, captures output, kills cleanly

2. **Node Dev Server**
   - Command: `npm run dev` (needs test project)
   - Verify: Handles startup, monitors logs

3. **Long Installation**
   - Command: `npm install` (large package.json)
   - Verify: Completes, captures output

4. **Interactive Setup**
   - Command: `npm init`
   - Verify: User can attach and complete

5. **Error Scenarios**
   - Invalid commands
   - Tmux failures
   - Timeout handling

### Success Criteria

- No blocking on long-running commands
- Output accessible after detachment
- Clean session management
- Graceful error handling
- Clear user guidance for interactive tasks