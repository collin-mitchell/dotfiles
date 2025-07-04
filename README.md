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

- `.vscode/settings.json` - VS Code settings including Copilot preferences and MCP server configurations
- `install.sh` - Main installation script
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
- **Simplified Configuration**: Single settings.json file contains all VS Code and MCP settings
- **Package Pre-installation**: Pre-installs common MCP packages for faster startup
- **Robust Error Handling**: Graceful fallbacks if certain features are unavailable

## File Structure

```
dotfiles/
├── .devcontainer/
│   └── devcontainer.json          # Codespace configuration
├── .vscode/
│   ├── settings.json              # VS Code settings with embedded MCP configuration
│   └── tasks.json                 # VS Code tasks
├── install.sh                     # Main installation script
└── README.md                      # This file
```

## Contributing

Feel free to submit issues or pull requests if you have suggestions for improvements!

## License

MIT License - feel free to use and modify as needed.
