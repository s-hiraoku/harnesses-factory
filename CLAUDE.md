# Claude Code Harnesses Factory

A factory toolkit for creating Claude Code harness components.

## Purpose

This plugin provides skills, agents, and hooks to help you build:
- **Agents** - Autonomous AI specialists
- **Skills** - Reusable capability packages
- **Commands** - Custom slash commands
- **Hooks** - Event-driven automation
- **MCP Servers** - External service integrations

## Available Components

### Skills

| Skill | Purpose |
|-------|---------|
| `skill-creator` | Guide for creating new skills |
| `agent-development` | Guide for building agents |
| `command-development` | Guide for creating commands |
| `mcp-builder` | Guide for building MCP servers |
| `mcp-integration` | Guide for integrating MCP servers |

### Agents

| Agent | Purpose |
|-------|---------|
| `mcp-server-architect` | Expert for MCP server design and implementation |

### Hooks

| Hook | Purpose |
|------|---------|
| `file-backup` | Auto-backup files before editing |
| `change-tracker` | Log all file changes |

## Usage

When creating new harness components, Claude will automatically use these skills to guide you through:

1. **Creating a skill**: Invoke `skill-creator` knowledge
2. **Building an agent**: Use `agent-development` patterns
3. **Making a command**: Follow `command-development` structure
4. **Setting up MCP**: Apply `mcp-builder` and `mcp-integration`

## File Structure Reference

```
# Skill
skills/my-skill/SKILL.md

# Agent
agents/my-agent.md

# Command
commands/my-command.md

# Hook
hooks/my-hook.json

# MCP Configuration
.mcp.json
```

## Attribution

Skills sourced from [claude-code-templates](https://github.com/davila7/claude-code-templates) (MIT License).
