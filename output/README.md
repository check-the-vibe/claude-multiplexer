# Tmux Test Demonstration

This directory contains a test suite demonstrating tmux session management for handling various types of tasks.

## Files

- **setup_task.sh** - A short-running setup task (~3 seconds)
- **long_task.sh** - A long-running build simulation (~15 seconds)
- **tmux_test_demo.sh** - Main orchestration script that demonstrates the workflow

## Running the Test

Simply execute:
```bash
./output/tmux_test_demo.sh
```

## What the Test Demonstrates

1. **Short Task** - Runs directly without tmux (setup_task.sh)
2. **Long Task** - Runs in a detached tmux session (long_task.sh)
3. **Monitoring** - Periodically checks the tmux session status and captures output
4. **Final Task** - Runs a cleanup task after the long task completes

## Key Tmux Commands Used

- `tmux new-session -d -s "$SESSION"` - Create detached session
- `tmux has-session -t "$SESSION"` - Check if session exists
- `tmux capture-pane -t "$SESSION" -p` - Capture session output
- `tmux kill-session -t "$SESSION"` - Clean up session

## Expected Output

The demo will show:
- Setup task completing in ~3 seconds
- Long task starting in tmux
- Multiple status checks showing progress
- Final verification and cleanup

Total runtime: ~20 seconds