# Claude Code Harnesses Factory

A plugin marketplace and development toolkit for Claude Code.

## Repository Roles

| Role | Description |
|------|-------------|
| **Marketplace** | Distribute multiple plugins. Users can install only what they need |
| **Development Tools** | `harnesses-factory` plugin supports agents/skills/hooks development |
| **Plugin Collection** | Individual plugins stored under `plugins/` directory |

## Installation

### Add as Marketplace

```bash
# Add the marketplace
/plugin marketplace add s-hiraoku/claude-code-harnesses-factory

# Search available plugins
/plugin search harnesses

# Install plugins
/plugin install harnesses-factory
/plugin install version-notifier
```

### Manual Installation

```bash
git clone https://github.com/s-hiraoku/claude-code-harnesses-factory.git
```

## Plugins

Individual installable plugins stored in `plugins/` directory.

| Plugin | Description | Status |
|--------|-------------|--------|
| [`version-notifier`](./plugins/version-notifier/) | Notify and explain changelog on new version release | Available |
| `context-advisor` | Analyze and optimize context window usage | Planned |

### version-notifier

Plugin that checks for new Claude Code versions at session start and has Claude explain the changelog.

```bash
/plugin install version-notifier@s-hiraoku/claude-code-harnesses-factory
```

## Development Tools (harnesses-factory)

Tools for plugin developers.

### Skills

| Skill | Description |
|-------|-------------|
| `skill-creator` | Guide for creating modular skill packages |
| `agent-development` | Guide for building autonomous agents |
| `command-development` | Guide for creating slash commands |
| `mcp-builder` | Guide for building MCP servers |
| `mcp-integration` | Guide for integrating MCP servers into plugins |

### Agents

| Agent | Description |
|-------|-------------|
| `mcp-server-architect` | Expert for MCP server design and implementation |

### Hooks

| Hook | Description |
|------|-------------|
| `file-backup` | Automatically backup files before editing |
| `change-tracker` | Log file changes to ~/.claude/changes.log |

## Project Structure

```
claude-code-harnesses-factory/
├── .claude-plugin/
│   ├── plugin.json           # Plugin manifest
│   └── marketplace.json      # Marketplace configuration
├── plugins/                  # Individual plugins
│   ├── version-notifier/     # Version notification plugin
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json
│   │   ├── hooks/
│   │   │   └── hooks.json
│   │   ├── scripts/
│   │   │   └── version-check.sh
│   │   └── README.md
│   └── context-advisor/      # Context advisor (planned)
├── agents/                   # Development support agents
│   └── mcp-server-architect.md
├── skills/                   # Development support skills
│   ├── skill-creator/SKILL.md
│   ├── agent-development/SKILL.md
│   ├── command-development/SKILL.md
│   ├── mcp-builder/SKILL.md
│   └── mcp-integration/SKILL.md
├── hooks/                    # Development support hooks
│   ├── file-backup.json
│   └── change-tracker.json
├── CLAUDE.md
└── README.md
```

## Usage

### Using Development Tools

```bash
# When creating a skill
"Help me create a new skill for..."
# → skill-creator knowledge is applied

# When building an agent
"Create an agent that..."
# → agent-development patterns are used

# When adding a command
"Add a slash command for..."
# → command-development structure is followed

# When setting up MCP
"Build an MCP server for..."
# → mcp-builder and mcp-integration are applied
```

## Attribution

Skills are adapted from [claude-code-templates](https://github.com/davila7/claude-code-templates) by Daniel Avila (MIT License).

## License

MIT License - See [LICENSE](LICENSE) for details.
