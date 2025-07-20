# Tmux Test Scenarios

**Created:** 2025-07-20
**Purpose:** Test scenarios to verify tmux integration works correctly

## Test Scenario 1: Development Server

**Command:** `python3 -m http.server 8000`

**Expected Behavior:**
1. Server starts in detached tmux session
2. Claude can continue with other tasks
3. Output shows "Serving HTTP on"
4. Session can be killed cleanly

**Test Steps:**
```bash
# Start server
SESSION="claude_dev_$(date +%s)"
tmux new-session -d -s "$SESSION" 'python3 -m http.server 8000'

# Check output
sleep 2
tmux capture-pane -t "$SESSION" -p

# Kill session
tmux kill-session -t "$SESSION"
```

## Test Scenario 2: NPM Install (Simulated)

**Command:** `sleep 5 && echo "Installation complete"`

**Expected Behavior:**
1. Command runs in background
2. Claude waits for completion
3. Full output is captured
4. Session auto-terminates

**Test Steps:**
```bash
# Start build
SESSION="claude_build_$(date +%s)"
tmux new-session -d -s "$SESSION" 'sleep 5 && echo "Installation complete"'

# Wait for completion
while tmux has-session -t "$SESSION" 2>/dev/null; do
    sleep 1
done

# Capture output
tmux capture-pane -t "$SESSION" -p
```

## Test Scenario 3: Interactive Command (Manual)

**Command:** `bash` (simulates interactive installer)

**Expected Behavior:**
1. Session starts detached
2. User gets clear instructions to attach
3. User can interact with session
4. Claude doesn't block

**Test Steps:**
```bash
# Start interactive session
SESSION="claude_interactive_$(date +%s)"
tmux new-session -d -s "$SESSION" 'bash'

# Inform user
echo "Interactive session started: $SESSION"
echo "Attach with: tmux attach -t $SESSION"
echo "Detach with: Ctrl-b d"
echo "Kill when done: tmux kill-session -t $SESSION"
```

## Test Scenario 4: Multiple Concurrent Tasks

**Purpose:** Verify multiple tmux sessions can run simultaneously

**Test Steps:**
```bash
# Start multiple servers
SESSION1="claude_dev_$(date +%s)"
sleep 0.1
SESSION2="claude_dev_$(date +%s)_2"

tmux new-session -d -s "$SESSION1" 'python3 -m http.server 8001'
tmux new-session -d -s "$SESSION2" 'python3 -m http.server 8002'

# Check both running
tmux list-sessions

# Monitor both
tmux capture-pane -t "$SESSION1" -p -S -5
tmux capture-pane -t "$SESSION2" -p -S -5

# Clean up
tmux kill-session -t "$SESSION1"
tmux kill-session -t "$SESSION2"
```

## Test Scenario 5: Error Recovery

**Purpose:** Test handling of tmux errors

**Test Cases:**
1. Invalid command
2. Session name conflict
3. Capture from dead session
4. Kill non-existent session

**Test Steps:**
```bash
# Test 1: Invalid command
SESSION="claude_error_$(date +%s)"
tmux new-session -d -s "$SESSION" 'invalidcommand'
sleep 1
tmux capture-pane -t "$SESSION" -p  # Should show error
tmux kill-session -t "$SESSION"

# Test 2: Duplicate session
SESSION="claude_duplicate"
tmux new-session -d -s "$SESSION" 'sleep 10'
tmux new-session -d -s "$SESSION" 'sleep 10' 2>&1  # Should fail
tmux kill-session -t "$SESSION"

# Test 3: Capture from non-existent
tmux capture-pane -t "nonexistent" -p 2>&1  # Should error

# Test 4: Kill non-existent
tmux kill-session -t "nonexistent" 2>&1  # Should error but not crash
```

## Manual Test: Real npm run dev

**Prerequisites:** Node.js project with package.json

**Steps:**
1. Create simple Express app
2. Run `npm run dev` in tmux
3. Verify server starts
4. Make a request to verify it's running
5. Check logs via tmux capture
6. Gracefully shut down

**Example:**
```bash
# Setup test project
mkdir test-app && cd test-app
npm init -y
npm install express
cat > index.js << 'EOF'
const express = require('express');
const app = express();
app.get('/', (req, res) => res.send('Hello from tmux!'));
app.listen(3000, () => console.log('Server running on port 3000'));
EOF
npm pkg set scripts.dev="node index.js"

# Run in tmux
SESSION="claude_dev_$(date +%s)"
tmux new-session -d -s "$SESSION" 'npm run dev'

# Wait and check
sleep 3
tmux capture-pane -t "$SESSION" -p

# Test server
curl http://localhost:3000

# Check logs again
tmux capture-pane -t "$SESSION" -p

# Shutdown
tmux send-keys -t "$SESSION" C-c
sleep 1
tmux kill-session -t "$SESSION"
```

## Verification Checklist

- [ ] Sessions start detached
- [ ] Output is capturable
- [ ] Multiple sessions work concurrently
- [ ] Sessions clean up properly
- [ ] Errors are handled gracefully
- [ ] Interactive sessions provide clear instructions
- [ ] Long-running processes don't block Claude
- [ ] Ctrl-C works for graceful shutdown