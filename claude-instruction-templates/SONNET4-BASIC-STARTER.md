# CLAUDE.md - Claude Usage Guide and Workflow System

## Overview

This document establishes best practices for working with Claude and defines a structured workflow system for project management, task execution, and context management. Following these guidelines ensures consistent, efficient, and well-documented interactions with Claude.

## Best Practices for Claude Usage

### Effective Prompting Techniques

1. **Be Clear and Specific**
   - Provide detailed instructions with clear expected outcomes
   - Include examples when possible
   - Specify desired format, length, and structure

2. **Use Structured Communication**
   - Break complex requests into clear steps
   - Use numbered lists for sequential tasks
   - Employ bullet points for related but non-sequential items

3. **Provide Context**
   - Include relevant background information
   - Reference previous work or decisions
   - Explain constraints and requirements

4. **Request Step-by-Step Reasoning**
   - Ask Claude to show its work for complex problems
   - Request explanations of decision-making processes
   - Use phrases like "think through this step by step"

5. **Use Positive and Negative Examples**
   - Show what you want: "Do this..."
   - Show what you don't want: "Don't do this..."
   - Provide sample outputs when possible

## Project Structure Requirements

Claude must establish and maintain the following directory structure in any project:

```
project-root/
├── CLAUDE.md (this file)
├── TASKS.md
├── ENVIRONMENT.md
└── .vibe/
    └── docs/
        ├── context-001.md
        ├── context-002.md
        └── [additional context files]
```

### Core Files

#### TASKS.md
Master task list containing all current and scheduled tasks, queries, and commands.

#### ENVIRONMENT.md
Documentation of the current environment, including:
- Operating system and version
- Installed applications and tools
- Available scripts and utilities
- Configuration details
- Usage instructions for tools

#### .vibe/docs/
Context repository containing markdown files that provide relevant project context, decisions, specifications, and reference materials.

## Task Management System

### TASKS.md Format

Each task in TASKS.md must follow this standardized format:

```markdown
## Task ID: TASK-YYYY-MM-DD-XXX

**Status:** [PENDING|IN_PROGRESS|COMPLETED|BLOCKED|CANCELLED]
**Priority:** [HIGH|MEDIUM|LOW]
**Created:** YYYY-MM-DD HH:MM
**Due:** YYYY-MM-DD (if applicable)
**Assigned:** Claude
**Estimated Time:** X hours/minutes

### Description
[Clear, detailed description of the task]

### Requirements
- [ ] Requirement 1
- [ ] Requirement 2
- [ ] Requirement 3

### Context Files
- .vibe/docs/context-XXX.md
- .vibe/docs/reference-YYY.md

### Progress Log
- YYYY-MM-DD HH:MM - Task created
- YYYY-MM-DD HH:MM - [Progress update]

### Completion Criteria
[Specific, measurable criteria for task completion]

### Notes
[Additional notes, considerations, or dependencies]

---
```

### Task Status Definitions

- **PENDING**: Task is queued and ready to begin
- **IN_PROGRESS**: Task is currently being worked on
- **COMPLETED**: Task has been finished and meets all completion criteria
- **BLOCKED**: Task cannot proceed due to dependencies or obstacles
- **CANCELLED**: Task has been cancelled and will not be completed

## Claude Execution Workflow

### Order of Operations

When approaching any new task, Claude must follow this sequence:

1. **Initialize Project Structure**
   - Create .vibe folder if it doesn't exist
   - Ensure TASKS.md, ENVIRONMENT.md exist
   - Verify .vibe/docs directory exists

2. **Read Current State**
   - Read TASKS.md completely
   - Identify the current task to work on
   - Review task requirements and context files

3. **Context Preparation**
   - Create or update relevant context files in .vibe/docs
   - Document any new information relevant to the current task
   - Read all referenced context files into working memory

4. **Task Execution**
   - Update task status to IN_PROGRESS
   - Log start time in task progress log
   - Execute the task according to requirements
   - Document progress and decisions

5. **Task Completion**
   - Verify all completion criteria are met
   - Update task status to COMPLETED
   - Log completion time and results
   - Create summary documentation if needed

6. **Documentation Update**
   - Update relevant context files with new information
   - Add any lessons learned or important decisions to .vibe/docs
   - Update ENVIRONMENT.md if environment changes occurred

### Context Management Guidelines

#### Creating Context Files

- Use descriptive filenames: `context-authentication-system.md`, `context-database-schema.md`
- Include creation date and last updated timestamp
- Reference related tasks and decisions
- Use consistent markdown formatting

#### Context File Structure

```markdown
# Context: [Topic Name]

**Created:** YYYY-MM-DD
**Last Updated:** YYYY-MM-DD
**Related Tasks:** TASK-YYYY-MM-DD-XXX, TASK-YYYY-MM-DD-YYY

## Overview
[Brief summary of the context]

## Key Information
[Detailed information, specifications, decisions]

## References
[Links to external resources, documentation]

## Related Files
[List of related context files or project files]
```

## Error Handling and Recovery

### When Tasks Cannot Be Completed

1. Update task status to BLOCKED
2. Document the specific obstacle in the progress log
3. Create or update context files with troubleshooting information
4. Propose alternative approaches or next steps

### When Information Is Missing

1. Document what information is needed in .vibe/docs
2. Update task with dependencies
3. Request clarification or additional resources
4. Continue with available information where possible

## Quality Assurance

### Before Task Completion

- [ ] All requirements have been met
- [ ] Documentation is complete and accurate
- [ ] Context files have been updated
- [ ] Progress has been logged
- [ ] No errors or warnings exist

### Documentation Standards

- Use clear, concise language
- Include examples where helpful
- Maintain consistent formatting
- Date all entries and updates
- Cross-reference related materials

## Integration with Development Workflow

### Version Control Integration

- Commit changes to .vibe/ directory regularly
- Use meaningful commit messages referencing task IDs
- Include TASKS.md updates in commits

### Code Documentation

- Reference relevant context files in code comments
- Link code changes to specific tasks
- Update ENVIRONMENT.md when adding new tools or dependencies

## Continuous Improvement

### Regular Reviews

- Weekly review of completed tasks
- Monthly review of context documentation
- Quarterly review of workflow effectiveness

### Feedback Integration

- Document workflow improvements in .vibe/docs
- Update this CLAUDE.md file as needed
- Share successful patterns and practices

---

## Quick Reference Commands

### Initialize New Project
1. Create .vibe directory
2. Create TASKS.md with initial structure
3. Create ENVIRONMENT.md with current environment details
4. Create .vibe/docs directory

### Start New Task
1. Read TASKS.md
2. Create/update context files
3. Update task status to IN_PROGRESS
4. Begin execution

### Complete Task
1. Verify completion criteria
2. Update task status to COMPLETED
3. Log completion details
4. Update relevant documentation

---

*This document should be regularly updated to reflect new best practices and workflow improvements. All changes should be documented in the version control system with clear commit messages.*