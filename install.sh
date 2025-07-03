#!/bin/bash

echo "🏠 Setting up dotfiles..."

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Setup VS Code settings if VS Code is available
if command -v code >/dev/null 2>&1; then
    echo "📝 Setting up VS Code configuration..."
    
    # Create VS Code user settings directory
    mkdir -p ~/.config/Code/User
    
    # Copy VS Code settings
    if [ -f "$DOTFILES_DIR/.vscode/settings.json" ]; then
        cp "$DOTFILES_DIR/.vscode/settings.json" ~/.config/Code/User/settings.json
        echo "✅ VS Code settings copied"
    fi
fi

# Setup MCP configuration
echo "🤖 Setting up MCP servers..."
"$DOTFILES_DIR/setup-mcp.sh"

echo "✅ Dotfiles installation complete!"
