# Dotfiles for GitHub Codespaces

This repository contains my personal dotfiles optimized for GitHub Codespaces with MCP server support and Copilot configuration.

## Features

- 🤖 **MCP Server Configuration**: Pre-configured MCP servers for enhanced development
- 🧠 **GitHub Copilot**: Optimized Copilot settings and instructions
- ⚡ **Automatic Setup**: Automatically loads in all new Codespaces
- 🔧 **VS Code Settings**: Comprehensive VS Code configuration

## Automatic Installation

This dotfiles repository is designed to work automatically with GitHub Codespaces. Simply:

1. Set this repository as your dotfiles repo in your GitHub Codespaces settings
2. Create a new Codespace - your settings will be automatically applied

## Manual Installation

```bash
git clone https://github.com/collin-mitchell/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

## Configuration Files

- `config/mcp.json` - MCP server configurations
- `.vscode/settings.json` - VS Code settings including Copilot preferences
- `install.sh` - Main installation script
- `setup-mcp.sh` - MCP-specific setup script
- `.devcontainer/devcontainer.json` - Codespace configuration

## MCP Servers Included

- **Time Server**: Trading hours and time zone support
- **Search**: Privacy-focused web search via SearXNG
- **Sequential Thinking**: Enhanced reasoning capabilities
- **Filesystem**: File operations within workspace
- **Git**: Version control operations
- **SQLite**: Local database operations
- **GitHub**: GitHub API integration

## Usage in Codespaces

1. Go to GitHub Settings > Codespaces
2. Set the dotfiles repository to: `collin-mitchell/dotfiles`
3. Set the installation command to: `./install.sh`
4. Create a new Codespace and your settings will be automatically applied

## Key Optimizations

- **Environment Detection**: Automatically detects Codespace vs local environment
- **Settings Merging**: Intelligently merges VS Code settings with existing Codespace configuration
- **Path Consistency**: Uses correct paths for MCP configuration in different environments
- **Package Pre-installation**: Pre-installs common MCP packages for faster startup
- **Robust Error Handling**: Graceful fallbacks if certain features are unavailable

## File Structure

```
dotfiles/
├── .devcontainer/
│   └── devcontainer.json          # Codespace configuration
├── .vscode/
│   ├── settings.json              # VS Code settings
│   └── tasks.json                 # VS Code tasks
├── config/
│   └── mcp.json                   # MCP server configuration
├── install.sh                     # Main installation script
├── setup-mcp.sh                   # MCP setup script
└── README.md                      # This file
```

## Contributing

Feel free to submit issues or pull requests if you have suggestions for improvements!

## License

MIT License - feel free to use and modify as needed.
