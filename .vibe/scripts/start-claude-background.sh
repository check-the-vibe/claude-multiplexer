#!/bin/bash
# Wrapper script to start Claude in background and exit immediately

# Run claude in background and redirect output
nohup claude > /tmp/claude_${CLAUDE_TASK_ID}.log 2>&1 &

# Get the PID
CLAUDE_PID=$!

# Save PID to file for monitoring
echo $CLAUDE_PID > /tmp/claude_${CLAUDE_TASK_ID}.pid

# Exit immediately to return control
exit 0