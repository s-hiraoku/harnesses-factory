# Contributing to Claude Code Harnesses Factory

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## How to Contribute

### Adding New Components

#### Agents

Create a new file in `.claude/agents/` with the following format:

```markdown
---
name: your-agent-name
description: Brief description of when and how to use this agent
tools: Tool1, Tool2, Tool3
model: sonnet
---

Your agent system prompt here.
```

#### Skills

Create a new directory in `.claude/skills/` with a `SKILL.md` file:

```markdown
---
name: your-skill-name
description: Brief description of what this skill does
---

# Skill Name

## Instructions
Step-by-step guidance for using this skill.

## Examples
Concrete examples of usage.
```

#### Commands

Create a new file in `.claude/commands/`:

```markdown
---
description: Brief description of the command
argument-hint: [optional arguments]
---

Command instructions here.
```

#### Rules

Create a new file in `.claude/rules/`:

```markdown
---
paths: **/*.{ts,tsx}
---

# Rule Name

Your rules and guidelines here.
```

### Submission Process

1. **Fork** the repository
2. **Create a branch** for your feature:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes** following the formats above
4. **Test your changes** in Claude Code
5. **Commit** using Conventional Commits:
   ```bash
   git commit -m "feat(agents): add new debugging agent"
   ```
6. **Push** to your fork
7. **Create a Pull Request** with:
   - Clear description of the component
   - Use case examples
   - Any special requirements

## Code Standards

- Follow existing file naming conventions
- Use clear, descriptive names
- Include comprehensive descriptions
- Test components before submitting

## Questions?

Open an issue if you have questions or need help.
