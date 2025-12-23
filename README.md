# Claude Code Harnesses Factory

A marketplace for Claude Code plugins.

## Plugins

| Plugin | Description | Status |
|--------|-------------|--------|
| [`cc-version-updater`](./plugins/cc-version-updater/) | Notifies and explains changelog on new version releases | Available |
| `context-advisor` | Analyzes and optimizes context window usage | Planned |

## Installation

### Add as Marketplace

```bash
# Add marketplace
/plugin marketplace add s-hiraoku/claude-code-harnesses-factory

# Check available plugins
/plugin search

# Install plugin
/plugin install cc-version-updater
```

### Install Individual Plugin

```bash
/plugin install cc-version-updater@s-hiraoku/claude-code-harnesses-factory
```

## Project Structure

```
claude-code-harnesses-factory/
├── .claude-plugin/
│   └── marketplace.json      # Marketplace configuration
├── .claude/                   # Development tools (repo-local)
│   ├── agents/                # Toolkit agents (committed)
│   ├── skills/                # Toolkit skills (committed)
│   ├── settings.json          # Generated from plugins/ (gitignored)
│   └── commands/              # Generated from plugins/ (gitignored)
├── plugins/                   # Distributable plugins
│   ├── cc-version-updater/
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json
│   │   ├── hooks/
│   │   │   └── hooks.json
│   │   ├── commands/
│   │   ├── skills/
│   │   ├── scripts/
│   │   └── README.md
│   └── context-advisor/       # (planned)
├── scripts/                   # Development scripts
└── README.md
```

## Development

This repository is a **Plugin Factory**. The `plugins/` directory contains production-ready plugins that should NOT be modified for debugging purposes.

### Setup

```bash
# Generate .claude/ files from plugins/
./scripts/dev-setup.sh

# Check current status
./scripts/dev-setup.sh --status

# Clean up generated files
./scripts/dev-setup.sh --clean
```

**How it works:**
- Generates `.claude/settings.json` from `plugins/*/hooks/hooks.json`
- Generates `.claude/commands/` from `plugins/*/commands/`
- Replaces `${CLAUDE_PLUGIN_ROOT}` with `${PWD}/plugins/<name>`

After running `dev-setup.sh`, start `claude` to debug plugins.

### Workflow

```bash
# 1. Initial setup
./scripts/dev-setup.sh

# 2. Modify files in plugins/
vim plugins/cc-version-updater/scripts/version-check.sh

# 3. Regenerate .claude/ files
./scripts/dev-setup.sh

# 4. Test with claude
claude
```

### Testing

```bash
# Validate plugin structure
./scripts/validate-plugin.sh cc-version-updater

# Test hook script
./scripts/test-hook.sh cc-version-updater
```

### Creating a New Plugin

1. Create plugin directory:
   ```bash
   mkdir -p plugins/my-plugin/.claude-plugin
   mkdir -p plugins/my-plugin/hooks
   mkdir -p plugins/my-plugin/scripts
   ```

2. Create `plugin.json`:
   ```json
   {
     "name": "my-plugin",
     "version": "1.0.0",
     "description": "My awesome plugin",
     "hooks": "./hooks/hooks.json"
   }
   ```

3. Run dev-setup and test:
   ```bash
   ./scripts/dev-setup.sh
   claude
   ```

## Attribution

Skills in `.claude/` are adapted from [claude-code-templates](https://github.com/davila7/claude-code-templates) by Daniel Avila (MIT License).

## License

MIT License - See [LICENSE](LICENSE) for details.
