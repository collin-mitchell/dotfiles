#!/bin/bash

echo "🔧 Setting up MCP configuration..."

# Create MCP config directory if it doesn't exist
mkdir -p ~/.config

# Check if MCP config already exists and is up to date
if [ -f ~/.config/mcp.json ] && [ -f "$(dirname "$0")/config/mcp.json" ]; then
    if cmp -s "$(dirname "$0")/config/mcp.json" ~/.config/mcp.json; then
        echo "✅ MCP configuration is already up to date"
        exit 0
    fi
fi

# Copy MCP configuration
if [ -f "$(dirname "$0")/config/mcp.json" ]; then
    # Remove existing file or link and create a new symlink
    ln -sf "$(dirname "$0")/config/mcp.json" ~/.config/mcp.json
    echo "✅ MCP configuration symlinked to ~/.config/mcp.json"
else
    echo "❌ config/mcp.json not found in dotfiles directory"
    exit 1
fi

# Ensure proper permissions
chmod 600 ~/.config/mcp.json

# Verify the configuration
if [ -f ~/.config/mcp.json ]; then
    echo "✅ MCP configuration installed successfully!"
    echo "📍 Location: ~/.config/mcp.json"
else
    echo "❌ MCP configuration installation failed"
    exit 1
fi
