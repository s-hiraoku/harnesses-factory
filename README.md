# Claude Code Harnesses Factory

A factory toolkit for creating Claude Code harness components: agents, skills, commands, hooks, and MCP servers.

## Installation

### Via Claude Code Plugin Marketplace

```bash
# Add the marketplace
/plugin marketplace add s-hiraoku/claude-code-harnesses-factory

# Install the plugin
/plugin install harnesses-factory
```

### Manual Installation

```bash
git clone https://github.com/s-hiraoku/claude-code-harnesses-factory.git
```

## Components

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

## Usage

After installation, these skills are automatically available when you work on harness development tasks:

```bash
# When you ask Claude to create a skill
"Help me create a new skill for..."
# → skill-creator knowledge is applied

# When you ask Claude to build an agent
"Create an agent that..."
# → agent-development patterns are used

# When you ask Claude to add a command
"Add a slash command for..."
# → command-development structure is followed

# When you ask Claude to set up MCP
"Build an MCP server for..."
# → mcp-builder and mcp-integration are applied
```

## Project Structure

```
claude-code-harnesses-factory/
├── .claude-plugin/
│   ├── plugin.json           # Plugin manifest
│   └── marketplace.json      # Marketplace configuration
├── agents/
│   └── mcp-server-architect.md
├── skills/
│   ├── skill-creator/SKILL.md
│   ├── agent-development/SKILL.md
│   ├── command-development/SKILL.md
│   ├── mcp-builder/SKILL.md
│   └── mcp-integration/SKILL.md
├── hooks/
│   ├── file-backup.json
│   └── change-tracker.json
├── CLAUDE.md
└── README.md
```

## Attribution

Skills are adapted from [claude-code-templates](https://github.com/davila7/claude-code-templates) by Daniel Avila (MIT License).

## License

MIT License - See [LICENSE](LICENSE) for details.
