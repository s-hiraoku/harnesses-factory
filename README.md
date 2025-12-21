# Claude Code Harnesses Factory

A comprehensive collection of Claude Code harness components for enhanced AI-powered development workflows.

## Features

- **Agents** - Specialized AI agents for code review, testing, debugging, performance analysis, and security auditing
- **Skills** - Reusable capabilities for git workflow, code review, testing, and documentation
- **Commands** - Custom slash commands for common development tasks
- **Rules** - Context-specific coding guidelines
- **Hooks** - Auto-formatting and security protections
- **MCP Servers** - External service integrations

## Installation

### Via Claude Code Plugin Marketplace (Recommended)

```bash
# Add the marketplace
/plugin marketplace add s-hiraoku/claude-code-harnesses-factory

# Install the plugin
/plugin install harnesses-factory
```

### Manual Installation

1. Clone this repository:
```bash
git clone https://github.com/s-hiraoku/claude-code-harnesses-factory.git
```

2. Copy the `.claude/` directory to your project:
```bash
cp -r claude-code-harnesses-factory/.claude/ your-project/.claude/
```

3. Copy `CLAUDE.md` and `.mcp.json` as needed:
```bash
cp claude-code-harnesses-factory/CLAUDE.md your-project/
cp claude-code-harnesses-factory/.mcp.json your-project/
```

## Components

### Agents

| Agent | Description |
|-------|-------------|
| `code-reviewer` | Expert code review with quality, security, and maintainability checks |
| `test-engineer` | Comprehensive test suite creation and coverage analysis |
| `debugger` | Systematic bug identification and resolution |
| `performance-profiler` | Performance bottleneck detection and optimization |
| `security-auditor` | Security vulnerability detection and remediation |

### Skills

| Skill | Description |
|-------|-------------|
| `git-workflow` | Git operations, commit messages, and branch management |
| `code-review` | Code review best practices and feedback structure |
| `testing` | Test development patterns and strategies |
| `documentation` | Documentation generation and maintenance |

### Commands

| Command | Description |
|---------|-------------|
| `/generate-tests` | Generate comprehensive test suites |
| `/review-code` | Review code changes |
| `/commit` | Create conventional commit messages |
| `/security-check` | Run security audit |
| `/performance-check` | Analyze performance |

### Rules

| Rule | Scope |
|------|-------|
| `code-style.md` | TypeScript/JavaScript coding standards |
| `security.md` | Security best practices |
| `testing.md` | Testing conventions |

### Hooks

- **PostToolUse** - Auto-format TypeScript/JavaScript files with Prettier
- **PreToolUse** - Block modifications to sensitive files (.env, .pem, .key, secrets/)

### MCP Servers

Pre-configured integrations:
- Memory Bank - AI memory system
- Sequential Thinking - Task decomposition
- Filesystem - File operations
- GitHub - Issue and PR management
- PostgreSQL - Database operations
- Brave Search - Web search

## Usage

After installation, use the components in Claude Code:

```bash
# Use an agent
/agents  # Select from available agents

# Use a command
/generate-tests src/utils/helpers.ts
/review-code
/commit "Add user authentication"
/security-check
/performance-check src/api/endpoints.ts
```

## Project Structure

```
claude-code-harnesses-factory/
├── .claude-plugin/
│   ├── plugin.json         # Plugin manifest
│   └── marketplace.json    # Marketplace configuration
├── agents/                 # AI agents
├── skills/                 # Reusable skills
├── commands/               # Slash commands
├── hooks/                  # Event hooks
├── .claude/                # Claude Code configuration
│   ├── rules/              # Coding rules
│   └── settings.json       # Settings
├── .mcp.json               # MCP server configurations
├── CLAUDE.md               # Project context
└── README.md
```

## Contributing

Contributions are welcome! Please follow the [Conventional Commits](https://www.conventionalcommits.org/) format for commit messages.

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

MIT License - See [LICENSE](LICENSE) for details.

## Credits

Built for use with Claude Code by Anthropic.
