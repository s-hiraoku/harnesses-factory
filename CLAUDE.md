# Claude Code Harnesses Factory

This project provides a comprehensive collection of Claude Code harness components including agents, skills, commands, rules, settings, hooks, and MCP configurations.

## Project Structure

```
claude-code-harnesses-factory/
├── .claude/
│   ├── agents/           # Specialized AI agents
│   ├── skills/           # Reusable capabilities
│   ├── commands/         # Custom slash commands
│   ├── rules/            # Context-specific rules
│   └── settings.json     # Claude Code settings
├── .mcp.json             # MCP server configurations
├── CLAUDE.md             # This file
└── README.md             # Project documentation
```

## Available Components

### Agents
- `code-reviewer` - Expert code review specialist
- `test-engineer` - Test creation and coverage specialist
- `debugger` - Systematic bug identification
- `performance-profiler` - Performance analysis expert
- `security-auditor` - Security vulnerability detection

### Skills
- `git-workflow` - Git operations and commit messages
- `code-review` - Code review best practices
- `testing` - Test development guidance
- `documentation` - Documentation generation

### Commands
- `/generate-tests` - Generate test suites
- `/review-code` - Review code changes
- `/commit` - Create git commits
- `/security-check` - Run security audit
- `/performance-check` - Analyze performance

## Development Standards

### Code Quality
- Write clean, readable, and maintainable code
- Use consistent naming conventions
- Keep functions small and focused
- Follow single responsibility principle

### Git Workflow
- Use atomic commits with descriptive messages
- Follow Conventional Commits format
- Create feature branches for new work
- Keep commits focused and reviewable

### Testing
- Write tests for all new features
- Maintain 80%+ code coverage on critical paths
- Use descriptive test names
- Follow AAA pattern (Arrange, Act, Assert)

### Security
- Never commit secrets or credentials
- Use environment variables for sensitive data
- Validate all inputs
- Keep dependencies updated

## Commands Reference

```bash
# Run tests
npm test

# Lint code
npm run lint

# Build project
npm run build

# Type check
npm run typecheck
```

## Review Checklist

Before completing any task:
- [ ] Code follows project conventions
- [ ] Tests pass and coverage is adequate
- [ ] No security vulnerabilities introduced
- [ ] Documentation updated if needed
- [ ] Git commit message is descriptive
