#!/bin/bash

# Tmux Integration Test Suite
# Tests the tmux workflow as documented in CLAUDE.md

echo "=== Tmux Integration Test Suite ==="
echo "Testing tmux workflows for long-running tasks"
echo

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Helper function to run a test
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    echo -n "Testing: $test_name... "
    
    if eval "$test_command"; then
        echo -e "${GREEN}PASSED${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}FAILED${NC}"
        ((TESTS_FAILED++))
    fi
}

# Test 1: Simple HTTP Server (simulates dev server)
test_simple_server() {
    SESSION="claude_dev_$(date +%s)"
    
    # Start server
    tmux new-session -d -s "$SESSION" 'python3 -m http.server 8888'
    sleep 2
    
    # Check if session exists
    if ! tmux has-session -t "$SESSION" 2>/dev/null; then
        return 1
    fi
    
    # Capture output
    OUTPUT=$(tmux capture-pane -t "$SESSION" -p)
    
    # Check for expected output
    if ! echo "$OUTPUT" | grep -q "HTTP"; then
        tmux kill-session -t "$SESSION" 2>/dev/null
        return 1
    fi
    
    # Clean up
    tmux kill-session -t "$SESSION"
    return 0
}

# Test 2: Long-running command with completion
test_long_command() {
    SESSION="claude_build_$(date +%s)"
    
    # Run command that takes a few seconds and keeps session alive
    tmux new-session -d -s "$SESSION" 'sleep 2 && echo "Build complete" && sleep 1'
    
    # Wait for output to appear
    TIMEOUT=5
    START=$(date +%s)
    while true; do
        if [ $(($(date +%s) - START)) -gt $TIMEOUT ]; then
            tmux kill-session -t "$SESSION" 2>/dev/null
            return 1
        fi
        
        # Capture output while session is running
        OUTPUT=$(tmux capture-pane -t "$SESSION" -p 2>/dev/null || echo "")
        
        # Check for completion message
        if echo "$OUTPUT" | grep -q "Build complete"; then
            tmux kill-session -t "$SESSION" 2>/dev/null
            return 0
        fi
        
        # Check if session died unexpectedly
        if ! tmux has-session -t "$SESSION" 2>/dev/null; then
            return 1
        fi
        
        sleep 0.5
    done
}

# Test 3: Session naming and cleanup
test_session_management() {
    # Create multiple sessions
    SESSION1="claude_test_$(date +%s)"
    sleep 0.1
    SESSION2="claude_test_$(date +%s)_2"
    
    tmux new-session -d -s "$SESSION1" 'sleep 10'
    tmux new-session -d -s "$SESSION2" 'sleep 10'
    
    # Check both exist
    if ! tmux has-session -t "$SESSION1" 2>/dev/null || \
       ! tmux has-session -t "$SESSION2" 2>/dev/null; then
        tmux kill-session -t "$SESSION1" 2>/dev/null
        tmux kill-session -t "$SESSION2" 2>/dev/null
        return 1
    fi
    
    # Clean up
    tmux kill-session -t "$SESSION1"
    tmux kill-session -t "$SESSION2"
    
    # Verify cleanup
    if tmux has-session -t "$SESSION1" 2>/dev/null || \
       tmux has-session -t "$SESSION2" 2>/dev/null; then
        return 1
    fi
    
    return 0
}

# Test 4: Output capture
test_output_capture() {
    SESSION="claude_output_$(date +%s)"
    
    # Create session with multiline output
    tmux new-session -d -s "$SESSION" 'echo "Line 1" && echo "Line 2" && echo "Line 3" && sleep 1'
    sleep 0.5
    
    # Capture different amounts
    OUTPUT_FULL=$(tmux capture-pane -t "$SESSION" -p)
    OUTPUT_LAST=$(tmux capture-pane -t "$SESSION" -p -S -1)
    
    # Clean up
    tmux kill-session -t "$SESSION" 2>/dev/null
    
    # Verify captures
    if echo "$OUTPUT_FULL" | grep -q "Line 1" && \
       echo "$OUTPUT_FULL" | grep -q "Line 3" && \
       echo "$OUTPUT_LAST" | grep -q "Line 3"; then
        return 0
    else
        return 1
    fi
}

# Test 5: Error handling
test_error_handling() {
    # Try to capture from non-existent session (should fail silently)
    if tmux capture-pane -t "nonexistent_session" -p 2>/dev/null; then
        return 1
    fi
    
    # Create session with failing command that stays alive
    SESSION="claude_error_$(date +%s)"
    tmux new-session -d -s "$SESSION" 'bash -c "echo Error test; exit 1" || sleep 2'
    sleep 0.5
    
    # Should be able to capture output even with failed command
    OUTPUT=$(tmux capture-pane -t "$SESSION" -p 2>/dev/null || echo "")
    tmux kill-session -t "$SESSION" 2>/dev/null
    
    # Check if we captured the echo before the failure
    if echo "$OUTPUT" | grep -q "Error test"; then
        return 0
    else
        return 1
    fi
}

# Run all tests
echo "Running tests..."
echo

run_test "Simple HTTP server" test_simple_server
run_test "Long-running command" test_long_command
run_test "Session management" test_session_management
run_test "Output capture" test_output_capture
run_test "Error handling" test_error_handling

echo
echo "=== Test Summary ==="
echo "Tests passed: $TESTS_PASSED"
echo "Tests failed: $TESTS_FAILED"
echo

# Clean up any remaining test sessions
tmux list-sessions 2>/dev/null | grep "claude_" | cut -d: -f1 | xargs -r -I {} tmux kill-session -t {}

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed.${NC}"
    exit 1
fi