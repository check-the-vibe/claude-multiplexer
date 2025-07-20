#!/bin/bash

echo "[SETUP] Starting setup task..."
echo "[SETUP] Checking environment..."
sleep 1

echo "[SETUP] Creating working directory..."
mkdir -p /tmp/tmux_test_workspace
sleep 0.5

echo "[SETUP] Installing dependencies..."
sleep 1

echo "[SETUP] Configuring settings..."
echo "Configuration complete" > /tmp/tmux_test_workspace/config.txt
sleep 0.5

echo "[SETUP] Setup completed successfully!"
echo "[SETUP] Total time: ~3 seconds"