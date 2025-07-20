#!/bin/bash

echo "[LONG TASK] Starting long-running process..."
echo "[LONG TASK] This will simulate a build process that takes ~15 seconds"

total_steps=15
current_step=0

while [ $current_step -lt $total_steps ]; do
    current_step=$((current_step + 1))
    percentage=$((current_step * 100 / total_steps))
    
    echo "[LONG TASK] Progress: $percentage% ($current_step/$total_steps)"
    echo "[LONG TASK] Processing chunk $current_step..."
    
    if [ $current_step -eq 5 ]; then
        echo "[LONG TASK] Compiling sources..."
    elif [ $current_step -eq 10 ]; then
        echo "[LONG TASK] Running tests..."
    elif [ $current_step -eq 13 ]; then
        echo "[LONG TASK] Optimizing output..."
    fi
    
    sleep 1
done

echo "[LONG TASK] Build completed successfully!"
echo "[LONG TASK] Output saved to: /tmp/tmux_test_workspace/build_output.txt"
echo "Build completed at $(date)" > /tmp/tmux_test_workspace/build_output.txt