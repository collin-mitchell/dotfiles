#!/bin/bash

echo "🔧 Setting up MCP configuration..."

# Create MCP config directory if it doesn't exist
mkdir -p ~/.config

# Check if MCP config already exists and is up to date
if [ -f ~/.config/mcp.json ] && [ -f "$(dirname "$0")/mcp.json" ]; then
    if cmp -s "$(dirname "$0")/mcp.json" ~/.config/mcp.json; then
        echo "✅ MCP configuration is already up to date"
        exit 0
    fi
fi

# Copy MCP configuration
if [ -f "$(dirname "$0")/mcp.json" ]; then
    cp "$(dirname "$0")/mcp.json" ~/.config/mcp.json
    echo "✅ MCP configuration copied to ~/.config/mcp.json"
else
    echo "❌ mcp.json not found in dotfiles directory"
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
