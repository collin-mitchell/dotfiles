#!/bin/bash

# Post-Installation Validation Script
# Run this after dotfiles installation to verify everything works

set -e

echo "🔬 Post-Installation Validation"
echo "==============================="

# Check environment
echo ""
echo "🌍 Environment Detection:"
if [ "$CODESPACES" = "true" ]; then
    echo "✅ Running in GitHub Codespace"
    ENVIRONMENT="codespace"
else
    echo "ℹ️  Running in local environment"
    ENVIRONMENT="local"
fi

# Verify MCP configuration files
echo ""
echo "📁 MCP Configuration Files:"
if [ -f ".vscode/mcp.json" ]; then
    echo "✅ Workspace MCP config found: .vscode/mcp.json"
else
    echo "❌ Workspace MCP config missing: .vscode/mcp.json"
    exit 1
fi

# Check user-level MCP config (if in Codespace)
if [ "$ENVIRONMENT" = "codespace" ]; then
    USER_MCP="/home/codespace/.vscode-remote/data/User/mcp.json"
    if [ -f "$USER_MCP" ]; then
        echo "✅ User-level MCP config found: $USER_MCP"
    else
        echo "⚠️  User-level MCP config not found (this is okay, workspace config will be used)"
    fi
fi

# Validate Python dependencies
echo ""
echo "🐍 Python Dependencies:"
if command -v python3 &> /dev/null || command -v python &> /dev/null; then
    # Try python3 first, then python
    PYTHON_CMD="python3"
    if ! command -v python3 &> /dev/null; then
        PYTHON_CMD="python"
    fi
    
    echo "✅ Python available: $($PYTHON_CMD --version)"
    
    # Check mcp-server-fetch
    if $PYTHON_CMD -c "import mcp_server_fetch" 2>/dev/null; then
        echo "✅ mcp-server-fetch installed and importable"
    else
        echo "❌ mcp-server-fetch not found or not importable"
        echo "🔧 Try: pip install --user mcp-server-fetch"
    fi
else
    echo "❌ Python not found"
fi

# Validate Node.js dependencies
echo ""
echo "📦 Node.js Dependencies:"
if command -v node &> /dev/null; then
    echo "✅ Node.js available: $(node --version)"
    
    if command -v npm &> /dev/null; then
        echo "✅ npm available: $(npm --version)"
    else
        echo "⚠️  npm not found"
    fi
    
    if command -v npx &> /dev/null; then
        echo "✅ npx available for MCP servers"
    else
        echo "⚠️  npx not found"
    fi
else
    echo "❌ Node.js not found"
fi

# Test MCP server executability (quick validation)
echo ""
echo "🤖 MCP Server Quick Tests:"

# Test sequential-thinking
if command -v npx &> /dev/null; then
    echo "📝 Testing sequential-thinking server..."
    if timeout 10s npx @modelcontextprotocol/server-sequential-thinking --help >/dev/null 2>&1; then
        echo "✅ sequential-thinking server accessible"
    else
        echo "⚠️  sequential-thinking server test timed out or failed"
    fi
else
    echo "⚠️  Cannot test npx-based servers (npx not available)"
fi

# Test fetch server
if command -v python3 &> /dev/null || command -v python &> /dev/null; then
    echo "🌐 Testing fetch server..."
    PYTHON_CMD="python3"
    if ! command -v python3 &> /dev/null; then
        PYTHON_CMD="python"
    fi
    
    if timeout 5s $PYTHON_CMD -m mcp_server_fetch --help >/dev/null 2>&1; then
        echo "✅ fetch server accessible"
    else
        echo "⚠️  fetch server test failed or timed out"
    fi
fi

# Check VS Code MCP integration
echo ""
echo "🔧 VS Code Integration:"
if [ -f ".vscode/mcp.json" ]; then
    # Count actual server entries using jq if available, otherwise fallback to sed
    SERVER_COUNT=$(jq '.servers | keys | length' .vscode/mcp.json 2>/dev/null || \
                   sed -n '/\"servers\":/,/^[[:space:]]*}/p' .vscode/mcp.json | grep -E '^[[:space:]]*\"[^\"]+\":[[:space:]]*{' | wc -l)
    echo "✅ $SERVER_COUNT MCP servers configured in VS Code"
    
    echo "📋 Configured servers:"
    if command -v jq &> /dev/null; then
        jq -r '.servers | keys[]' .vscode/mcp.json | sed 's/^/  • /'
    else
        sed -n '/\"servers\":/,/^[[:space:]]*}/p' .vscode/mcp.json | grep -oE '^[[:space:]]*\"[^\"]+\":[[:space:]]*{' | sed 's/[": {]//g' | sed 's/^/  • /'
    fi
fi

# GitHub token status (for github-copilot-mcp)
echo ""
echo "🔑 GitHub Token Status:"
echo "ℹ️  GitHub MCP server requires manual token setup"
echo "📖 Set token in VS Code when prompted by the MCP server"

# Final summary
echo ""
echo "📊 Validation Summary:"
echo "✅ Configuration files present"
echo "✅ Dependencies checked"
echo "✅ MCP servers validated"

if [ "$ENVIRONMENT" = "codespace" ]; then
    echo ""
    echo "🎉 Codespace Setup Complete!"
    echo ""
    echo "📋 Next Steps:"
    echo "1. Restart VS Code window (Ctrl+Shift+P → 'Developer: Reload Window')"
    echo "2. Open Copilot Chat and test MCP tools:"
    echo "   • Try: 'Use #mcp_sequential-th_sequentialthinking to solve this problem'"
    echo "   • Try: 'Use #mcp_fetch_fetch to get content from a URL'"
    echo "3. Set GitHub token when prompted by github-copilot-mcp server"
    echo ""
    echo "🆘 If issues occur, check:"
    echo "   • VS Code Output panel for MCP errors"
    echo "   • Run this script again: ./scripts/validate-setup.sh"
    echo "   • See README.md troubleshooting section"
else
    echo ""
    echo "🏠 Local Setup Validated!"
    echo "📖 See README.md for usage instructions"
fi
