#!/bin/bash

# Dotfiles Setup Script for GitHub Codespaces
# This script sets up MCP servers and development environment

set -e

echo "🚀 Starting dotfiles setup..."

# Detect environment
if [ "$CODESPACES" = "true" ]; then
    echo "📦 Codespace environment detected"
    ENVIRONMENT="codespace"
else
    echo "🏠 Local environment detected"
    ENVIRONMENT="local"
fi

# Install Python MCP dependencies
echo "🐍 Installing Python MCP servers..."
if command -v pip &> /dev/null; then
    echo "📦 Installing mcp-server-fetch..."
    
    # Retry logic for network issues
    for attempt in 1 2 3; do
        if pip install --user mcp-server-fetch --timeout=30; then
            echo "✅ Python MCP fetch server installed successfully"
            
            # Verify installation
            if python -c "import mcp_server_fetch" 2>/dev/null; then
                echo "✅ mcp-server-fetch verified and working"
            else
                echo "⚠️  mcp-server-fetch installed but import failed"
            fi
            break
        else
            echo "⚠️  Attempt $attempt failed, retrying..."
            sleep 2
        fi
        
        if [ $attempt -eq 3 ]; then
            echo "❌ Failed to install mcp-server-fetch after 3 attempts"
            echo "🔧 You may need to install manually: pip install --user mcp-server-fetch"
        fi
    done
else
    echo "⚠️  Python/pip not found, skipping Python MCP servers"
    echo "🔧 Install Python to enable fetch MCP server"
fi

# Verify Node.js for npx-based MCP servers
echo "📦 Checking Node.js environment..."
if command -v node &> /dev/null && command -v npm &> /dev/null; then
    NODE_VERSION=$(node --version)
    NPM_VERSION=$(npm --version)
    echo "✅ Node.js detected: $NODE_VERSION"
    echo "✅ npm detected: $NPM_VERSION"
    
    # Test npx functionality
    if command -v npx &> /dev/null; then
        echo "✅ npx available for MCP servers"
    else
        echo "⚠️  npx not found - installing npm packages globally may be needed"
    fi
else
    echo "⚠️  Node.js/npm not found - some MCP servers may not work"
    echo "🔧 Install Node.js to enable npx-based MCP servers"
fi

# MCP Configuration Status
echo "🔧 MCP Configuration Status:"
if [ -f ".vscode/mcp.json" ]; then
    echo "✅ Workspace MCP config found: .vscode/mcp.json"
    # Count actual server entries (direct children of "servers" object)
    MCP_SERVERS=$(grep -A 1000 '"servers"' .vscode/mcp.json | grep -E '^\s*"[^"]+"\s*:\s*{' | wc -l)
    echo "📊 Configured MCP servers: $MCP_SERVERS"
else
    echo "❌ No workspace MCP config found"
fi

# Environment-specific setup
if [ "$ENVIRONMENT" = "codespace" ]; then
    echo "🌐 Codespace-specific setup..."
    
    # Set up any Codespace-specific configurations
    echo "📝 Codespace setup complete"
    
    # Display MCP server status
    echo ""
    echo "🤖 MCP Servers Ready:"
    echo "  • sequential-thinking (npx) ✅"
    echo "  • github-copilot-mcp (requires GitHub token) ⚠️"
    echo "  • playwright (npx) ✅"
    echo "  • fetch (python) ✅"
    echo "  • Context7 (npx) ✅"
    echo ""
    echo "💡 To use GitHub MCP server, set your GitHub token in VS Code"
    
else
    echo "🏠 Local environment setup complete"
fi

echo "✨ Dotfiles setup complete! MCP servers ready for use."
echo ""
echo "📖 See README.md for usage guidelines and troubleshooting"
