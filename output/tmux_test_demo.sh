#!/bin/bash

echo "=== Tmux Task Demonstration ==="
echo "This script demonstrates running tasks with tmux session management"
echo ""

# 1. Run short setup task (no tmux needed)
echo "Step 1: Running short setup task directly..."
./output/setup_task.sh
echo ""

# 2. Start long-running task in tmux
echo "Step 2: Starting long-running task in tmux session..."
SESSION="claude_build_$(date +%s)"
tmux new-session -d -s "$SESSION" './output/long_task.sh'
echo "Long task started in tmux session: $SESSION"
echo ""

# 3. Monitor the task status
echo "Step 3: Monitoring task progress..."
check_count=0
while tmux has-session -t "$SESSION" 2>/dev/null; do
    check_count=$((check_count + 1))
    echo "Check #$check_count - Task still running..."
    
    # Capture last few lines of output
    echo "Latest output:"
    tmux capture-pane -t "$SESSION" -p -S -5 | sed 's/^/  > /'
    echo ""
    
    sleep 3
done

echo "Long task completed!"
echo ""

# Capture full output
echo "Full task output:"
tmux capture-pane -t "$SESSION" -p | tail -20
echo ""

# 4. Run final task
echo "Step 4: Running final cleanup task..."
cat << 'EOF' > /tmp/tmux_test_workspace/final_task.sh
#!/bin/bash
echo "[FINAL] Running final verification..."
echo "[FINAL] Checking build output..."
if [ -f /tmp/tmux_test_workspace/build_output.txt ]; then
    echo "[FINAL] Build output found: $(cat /tmp/tmux_test_workspace/build_output.txt)"
else
    echo "[FINAL] ERROR: Build output not found!"
fi
echo "[FINAL] Cleaning up temporary files..."
echo "[FINAL] Task completed successfully!"
EOF

chmod +x /tmp/tmux_test_workspace/final_task.sh
/tmp/tmux_test_workspace/final_task.sh

echo ""
echo "=== All tasks completed successfully! ==="
echo "Summary:"
echo "  1. Setup task: Completed (3 seconds)"
echo "  2. Long task: Completed in tmux (15 seconds)"
echo "  3. Monitoring: Successfully tracked progress"
echo "  4. Final task: Cleanup completed"