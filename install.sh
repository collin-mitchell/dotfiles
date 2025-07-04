#!/bin/bash

echo "🏠 Setting up dotfiles for Codespaces..."

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Detect if we're in a Codespace
if [ -n "$CODESPACES" ]; then
    echo "🚀 Detected GitHub Codespace environment"
    VSCODE_CONFIG_DIR="$HOME/.vscode-remote/data/Machine"
else
    echo "💻 Detected local environment"
    VSCODE_CONFIG_DIR="$HOME/.config/Code/User"
fi

# Setup VS Code settings
echo "📝 Setting up VS Code configuration..."
mkdir -p "$VSCODE_CONFIG_DIR"

if [ -f "$DOTFILES_DIR/.vscode/settings.json" ]; then
    # In Codespaces, symlinking is preferred to allow for dynamic updates.
    # The merge logic is complex and can be brittle. A direct symlink
    # ensures that any changes from `git pull` are immediately reflected.
    # We will back up the original settings just in case.
    if [ -f "$VSCODE_CONFIG_DIR/settings.json" ]; then
        echo "Backing up existing settings to settings.json.bak"
        mv "$VSCODE_CONFIG_DIR/settings.json" "$VSCODE_CONFIG_DIR/settings.json.bak"
    fi
    
    echo "🔗 Symlinking VS Code settings..."
    ln -sf "$DOTFILES_DIR/.vscode/settings.json" "$VSCODE_CONFIG_DIR/settings.json"
    echo "✅ VS Code settings symlinked"
else
    echo "❌ VS Code settings not found"
fi

# Setup MCP configuration
echo "🤖 Setting up MCP servers..."
"$DOTFILES_DIR/setup-mcp.sh"

# Setup additional Codespace-specific configurations
if [ -n "$CODESPACES" ]; then
    echo "⚙️  Setting up Codespace-specific configurations..."
    
    # Ensure Node.js tools are available
    if ! command -v npx >/dev/null 2>&1; then
        echo "📦 Installing Node.js tools..."
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi
    
    # Pre-install common MCP packages to speed up startup
    echo "📦 Pre-installing MCP packages..."
    npx -y @modelcontextprotocol/server-filesystem --help >/dev/null 2>&1 &
    npx -y @modelcontextprotocol/server-git --help >/dev/null 2>&1 &
    npx -y @modelcontextprotocol/server-sequential-thinking --help >/dev/null 2>&1 &
    npx -y mcp-searxng --help >/dev/null 2>&1 &
    wait
fi

echo "✅ Dotfiles installation complete!"

# Restart VS Code server if in Codespace to pick up new settings
if [ -n "$CODESPACES" ]; then
    echo "🔄 Restarting VS Code server to apply settings..."
    # This will be picked up by the Codespace automatically
fi
