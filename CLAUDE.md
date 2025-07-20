# CLAUDE.md - Claude Operations Guide

## Overview
This document provides project-specific instructions for Claude's task execution. It follows best practices for concise, declarative guidance that maximizes Claude's effectiveness.

## Core Principles

### 1. Documentation First
- Always document before executing
- Maintain clear, accessible records of all actions
- Update documentation immediately after task completion

### 2. Structured Communication
- Be explicit about capabilities and limitations
- Provide clear reasoning for decisions
- Maintain consistent formatting across all outputs

### 3. Context Awareness
- Always check existing documentation before proceeding
- Build upon previous work rather than duplicating
- Maintain awareness of project state and history

### 4. Workflow Approach
- Follow "explore-plan-code-commit" workflow
- Use parallel tool execution for efficiency
- Request clarification before complex tasks

## Project Structure Requirements

### Directory Setup
Claude must ensure the following structure exists in the project root:

```
project-root/
├── .vibe/
│   ├── TASKS.md
│   ├── ENVIRONMENT.md
│   └── docs/
│       ├── context-{topic}.md
│       ├── decisions-{date}.md
│       └── dependencies.md
└── CLAUDE.md (this file)
```

## Task Execution Protocol

### Order of Operations

1. **Initialize Environment**
   - Check for .vibe directory existence
   - Create missing structure components
   - Verify file permissions

2. **Read Current State**
   - Load TASKS.md
   - Review ENVIRONMENT.md
   - Scan .vibe/docs for relevant context

3. **Document Intent**
   - Create/update relevant docs in .vibe/docs
   - Document approach and reasoning
   - Note any assumptions or dependencies

4. **Execute Task**
   - Perform the requested action
   - Capture outputs and results
   - Handle errors gracefully

5. **Update Records**
   - Update task status in TASKS.md
   - Document results in .vibe/docs
   - Update ENVIRONMENT.md if needed

## File Specifications

### TASKS.md Format

```markdown
# Project Tasks

## Active Tasks

### TASK-YYYY-MM-DD-XXX: [Task Title]
- **Status**: PENDING | IN_PROGRESS | COMPLETED | BLOCKED | CANCELLED
- **Priority**: HIGH | MEDIUM | LOW
- **Created**: YYYY-MM-DD HH:MM
- **Updated**: YYYY-MM-DD HH:MM
- **Due**: YYYY-MM-DD (if applicable)
- **Estimated Time**: X hours/minutes
- **Description**: Clear, detailed task description
- **Acceptance Criteria**: 
  - [ ] Specific, measurable criterion 1
  - [ ] Specific, measurable criterion 2
- **Dependencies**: Task IDs or external dependencies
- **Context Files**: 
  - .vibe/docs/context-XXX.md
- **Progress Log**:
  - YYYY-MM-DD HH:MM - Task created
  - YYYY-MM-DD HH:MM - [Progress update]
- **Notes**: Additional context or blockers

## Completed Tasks
[Archive with completion date and summary]

## Scheduled Tasks
[Future tasks with estimated start dates]
```

### ENVIRONMENT.md Format

```markdown
# Environment Configuration

## System Information
- **OS**: [Operating System]
- **Claude Version**: [Version info]
- **Project Type**: [Type of project]
- **Last Updated**: YYYY-MM-DD

## Available Tools
- **Python**: 3.12.1 - General programming and scripting
- **Node.js**: 22.17.0 - JavaScript runtime
- **npm**: 9.8.1 - Package management
- **Git**: 2.50.1 - Version control
- **Bash**: 5.2.21 - Shell scripting

## Required Programs
- **tmux**: Terminal multiplexer for session management
- **curl**: Command-line tool for transferring data
- **jq**: Lightweight JSON processor

## Project Dependencies
- Dependency 1: Version and purpose
- Dependency 2: Version and purpose

## Configuration Notes
[Any special configuration or setup notes]

## Known Limitations
[Document any environmental constraints]
```

### Context Documentation (.vibe/docs/)

Each context file should follow:

```markdown
# Context: [Topic]

## Overview
Brief description of this context

## Key Information
- Important point 1
- Important point 2

## Related Files
- Link to related documentation
- Link to relevant code

## History
- YYYY-MM-DD: Initial creation
- YYYY-MM-DD: Major update

## Notes
Additional observations or considerations
```

## Best Practices for Claude

### 1. Communication
- Always acknowledge task receipt
- Provide progress updates for long-running tasks
- Clearly communicate any blockers or issues
- Use structured formats for consistency

### 2. Error Handling
- Anticipate common failure modes
- Provide helpful error messages
- Suggest remediation steps
- Document errors in task notes

### 3. Code Generation
- Include comprehensive comments
- Follow project style guides
- Test generated code when possible
- Provide usage examples

### 4. Documentation
- Write for future Claude instances
- Include context and reasoning
- Use clear, searchable titles
- Maintain consistent formatting

### 5. Task Management
- Break complex tasks into subtasks
- Estimate effort realistically
- Update status promptly
- Archive completed work properly

## Quality Checklist

Before marking any task complete:
- [ ] All acceptance criteria met
- [ ] Documentation updated
- [ ] Results verified
- [ ] Context preserved for future use
- [ ] Dependencies documented
- [ ] Error cases handled

## Version Control Integration

When working with version-controlled projects:
- Respect .gitignore patterns
- Document significant changes
- Maintain clean commit messages
- Note branch/version information

## Security Considerations

- Never expose sensitive credentials
- Sanitize logs and outputs
- Follow project security policies
- Document security decisions

## Maintenance Protocol

### Daily Operations
1. Review active tasks
2. Update task statuses
3. Archive completed items
4. Plan upcoming work

### Weekly Reviews
1. Clean up documentation
2. Archive old contexts
3. Update environment info
4. Optimize file organization

## Notes for Future Claude Instances

This guide ensures consistency across all Claude interactions with this project. Always:
- Start by reading this guide
- Check existing documentation
- Maintain the established structure
- Leave the project better documented than you found it

## Prompting Best Practices

### Effective Communication with Claude
1. **Be Explicit and Direct**
   - Use clear, detailed instructions
   - Specify frameworks, constraints, and success criteria
   - Request comprehensive results when needed

2. **Provide Context and Motivation**
   - Explain why tasks are needed
   - Give background for better generalization
   - Include relevant constraints

3. **Use Structured Formats**
   - Break complex requests into numbered steps
   - Use markdown formatting consistently
   - Provide examples when helpful

## Workflow Guidelines

### Explore-Plan-Code-Commit Workflow
1. **Explore**: Read relevant files and understand context
2. **Plan**: Create detailed approach with reasoning
3. **Code**: Implement solution following plan
4. **Commit**: Verify work and update documentation

### Parallel Execution
- Use multiple tool calls simultaneously for efficiency
- Batch independent operations
- Leverage concurrent file reads and searches

## Memory Management

### Memory Types
- **Project Memory**: This CLAUDE.md file (team-shared)
- **User Memory**: ~/.claude/CLAUDE.md (personal preferences)
- **Local Memory**: CLAUDE.local.md (deprecated)

### Quick Tips
- Start input with `#` to quickly add memories
- Use `@path/to/file.md` to import other documents
- Review and update memories periodically

## Program Installation Procedures

### Installing Required Programs

For Debian/Ubuntu systems (like this Codespace):
```bash
# Update package list
sudo apt-get update

# Install tmux
sudo apt-get install -y tmux

# Install curl (usually pre-installed)
sudo apt-get install -y curl

# Install jq
sudo apt-get install -y jq
```

For verification:
```bash
tmux -V
curl --version
jq --version
```

---
*Last Updated: 2025-07-20*
*Version: 2.0*