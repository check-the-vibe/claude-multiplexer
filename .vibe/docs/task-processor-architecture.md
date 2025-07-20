# Task Processor System Architecture

## Overview
A 3-step task processing system that receives JSON tasks via curl, validates them, and extracts word statistics.

## System Components

### 1. Task Receiver (HTTP Endpoint)
- **Port**: 8080
- **Endpoint**: POST /task
- **Input**: JSON object with task metadata
- **Output**: Task ID and acknowledgment
- **Storage**: Saves to `output/tasks/pending/`

### 2. Task Validator Process
- **Type**: File watcher daemon
- **Watch Directory**: `output/tasks/pending/`
- **Validation**: JSON schema validation
- **Success Path**: Move to `output/tasks/validated/`
- **Failure Path**: Move to `output/tasks/invalid/`
- **Log**: `output/task-processor.log`

### 3. Word Extractor Process
- **Type**: Batch processor daemon
- **Watch Directory**: `output/tasks/validated/`
- **Processing**: Extract words from task data
- **Output**: Update word counts in `output/words/word_counts.csv`
- **Archive**: Move processed to `output/tasks/processed/`

## Data Flow
```
curl -> HTTP Server -> pending/ -> Validator -> validated/ -> Word Extractor -> word_counts.csv
                                      |
                                      v
                                   invalid/
```

## JSON Task Schema
```json
{
  "id": "string (optional, auto-generated if missing)",
  "title": "string (required)",
  "description": "string (required)",
  "metadata": {
    "priority": "string (optional)",
    "tags": ["array of strings (optional)"]
  },
  "timestamp": "ISO 8601 (optional, auto-generated)"
}
```

## Word Count CSV Format
```csv
word,count,last_updated
hello,5,2025-07-20T12:00:00Z
world,3,2025-07-20T12:00:00Z
```

## Implementation Plan

### Phase 1: HTTP Endpoint (Member 1)
- Python Flask server
- JSON validation
- File persistence
- Basic error handling

### Phase 2: Validator Process (Member 2)
- Python file watcher
- JSON schema validation
- File movement logic
- Logging system

### Phase 3: Word Extractor (Member 3)
- Python batch processor
- Text parsing and tokenization
- CSV file management
- Word count aggregation

## Security Considerations
- Input validation
- File path sanitization
- Rate limiting (optional)
- No execution of user-provided code

## Testing Plan
1. Send valid JSON via curl
2. Send invalid JSON via curl
3. Verify file movement through stages
4. Check word count accuracy
5. Test concurrent requests