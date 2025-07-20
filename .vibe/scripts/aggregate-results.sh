#!/bin/bash

# Aggregate results from all team members

echo "=== Team Results Aggregation ==="
echo "Time: $(date)"
echo ""

RESULTS_DIR=".vibe/team/results"
TASKS_DIR=".vibe/team/tasks"
OUTPUT_FILE=".vibe/team/aggregated-results.md"

# Initialize output file
cat > "$OUTPUT_FILE" << EOF
# Aggregated Team Results
Generated: $(date)

## Summary

EOF

# Count completed tasks
TOTAL_TASKS=$(find "$TASKS_DIR" -name "*.json" 2>/dev/null | wc -l)
COMPLETED_TASKS=$(find "$TASKS_DIR" -name "*.json" -exec jq -r 'select(.status == "completed") | .task_id' {} \; 2>/dev/null | wc -l)

echo "Total Tasks: $TOTAL_TASKS" | tee -a "$OUTPUT_FILE"
echo "Completed: $COMPLETED_TASKS" | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"

# Process each task
echo "## Task Results" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

find "$TASKS_DIR" -name "*.json" | sort | while read -r task_file; do
    TASK_ID=$(basename "$task_file" .json)
    TASK_DATA=$(jq '.' "$task_file")
    
    STATUS=$(echo "$TASK_DATA" | jq -r '.status')
    DESCRIPTION=$(echo "$TASK_DATA" | jq -r '.description')
    ASSIGNED_TO=$(echo "$TASK_DATA" | jq -r '.assigned_to // "unassigned"')
    RESULTS_PATH=$(echo "$TASK_DATA" | jq -r '.results_path // empty')
    
    echo "### $TASK_ID" | tee -a "$OUTPUT_FILE"
    echo "- **Status**: $STATUS" | tee -a "$OUTPUT_FILE"
    echo "- **Description**: $DESCRIPTION" | tee -a "$OUTPUT_FILE"
    echo "- **Assigned To**: $ASSIGNED_TO" | tee -a "$OUTPUT_FILE"
    
    # Check for results
    if [ -n "$RESULTS_PATH" ] && [ -d "$RESULTS_PATH" ]; then
        echo "- **Results**:" | tee -a "$OUTPUT_FILE"
        
        # List result files
        find "$RESULTS_PATH" -type f | while read -r result_file; do
            REL_PATH=$(realpath --relative-to="$RESULTS_PATH" "$result_file")
            echo "  - $REL_PATH" | tee -a "$OUTPUT_FILE"
        done
        
        # Check for summary file
        SUMMARY_FILE="$RESULTS_PATH/summary.md"
        if [ -f "$SUMMARY_FILE" ]; then
            echo "" >> "$OUTPUT_FILE"
            echo "#### Summary" >> "$OUTPUT_FILE"
            cat "$SUMMARY_FILE" >> "$OUTPUT_FILE"
        fi
    else
        echo "- **Results**: No results directory found" | tee -a "$OUTPUT_FILE"
    fi
    
    echo "" | tee -a "$OUTPUT_FILE"
done

echo "## Messages Log" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Include recent messages
MESSAGES_DIR=".vibe/team/messages"
if [ -d "$MESSAGES_DIR" ]; then
    echo "### Recent Communications" >> "$OUTPUT_FILE"
    find "$MESSAGES_DIR" -name "*.json" -mtime -1 | sort -r | head -10 | while read -r msg_file; do
        MSG_DATA=$(jq '.' "$msg_file")
        FROM=$(echo "$MSG_DATA" | jq -r '.from')
        TO=$(echo "$MSG_DATA" | jq -r '.to')
        TYPE=$(echo "$MSG_DATA" | jq -r '.type')
        TIME=$(echo "$MSG_DATA" | jq -r '.timestamp')
        
        echo "- **$TIME** [$TYPE] $FROM → $TO" >> "$OUTPUT_FILE"
    done
fi

echo "" | tee -a "$OUTPUT_FILE"
echo "Results aggregated to: $OUTPUT_FILE"