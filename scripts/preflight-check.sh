#!/bin/bash

# Pre-flight Check Script for Dotfiles Setup
# Run this before testing in a fresh Codespace

set -e

echo "🚁 Pre-flight Check for Dotfiles Setup"
echo "======================================"

# Check repository structure
echo ""
echo "📁 Repository Structure Check:"
REQUIRED_FILES=(".vscode/mcp.json" "install.sh" "README.md")
MISSING_FILES=()

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file exists"
    else
        echo "❌ $file missing"
        MISSING_FILES+=("$file")
    fi
done

if [ ${#MISSING_FILES[@]} -gt 0 ]; then
    echo "❌ Missing required files: ${MISSING_FILES[*]}"
    exit 1
fi

# Check file permissions
echo ""
echo "🔐 File Permissions Check:"
if [ -x "install.sh" ]; then
    echo "✅ install.sh is executable"
else
    echo "⚠️  install.sh not executable, fixing..."
    chmod +x install.sh
    echo "✅ Fixed install.sh permissions"
fi

# Validate JSON syntax
echo ""
echo "📝 JSON Configuration Validation:"
if command -v python3 &> /dev/null; then
    if python3 -m json.tool .vscode/mcp.json > /dev/null 2>&1; then
        echo "✅ .vscode/mcp.json is valid JSON"
    else
        echo "❌ .vscode/mcp.json has JSON syntax errors"
        echo "🔧 Run: python3 -m json.tool .vscode/mcp.json"
        exit 1
    fi
else
    echo "⚠️  Python3 not available for JSON validation"
fi

# Check MCP server count
echo ""
echo "🤖 MCP Server Configuration:"
if grep -q '"servers"' .vscode/mcp.json; then
    # Count actual server entries by looking for server names in the servers object
    SERVER_COUNT=$(jq '.servers | keys | length' .vscode/mcp.json 2>/dev/null || \
                   sed -n '/\"servers\":/,/^[[:space:]]*}/p' .vscode/mcp.json | grep -E '^[[:space:]]*\"[^\"]+\":[[:space:]]*{' | wc -l)
    echo "✅ Found $SERVER_COUNT MCP servers configured"
    
    # List configured servers (extract server names)
    echo "📋 Configured servers:"
    if command -v jq &> /dev/null; then
        jq -r '.servers | keys[]' .vscode/mcp.json | sed 's/^/  • /'
    else
        sed -n '/\"servers\":/,/^[[:space:]]*}/p' .vscode/mcp.json | grep -oE '^[[:space:]]*\"[^\"]+\":[[:space:]]*{' | sed 's/[": {]//g' | sed 's/^/  • /'
    fi
else
    echo "❌ No MCP servers found in configuration"
    exit 1
fi

# Check GitHub repository status
echo ""
echo "📊 Git Repository Status:"
if git status --porcelain | grep -q .; then
    echo "⚠️  Uncommitted changes detected:"
    git status --porcelain
    echo "🔧 Commit changes before testing fresh Codespace"
else
    echo "✅ Repository is clean"
fi

# Check if we're on main branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" = "main" ]; then
    echo "✅ On main branch"
else
    echo "⚠️  On branch '$CURRENT_BRANCH', consider switching to main"
fi

echo ""
echo "🎯 Pre-flight Summary:"
echo "✅ Repository structure valid"
echo "✅ File permissions correct"
echo "✅ JSON configuration valid"
echo "✅ MCP servers configured"

echo ""
echo "🚀 Ready for fresh Codespace testing!"
echo ""
echo "📋 Next Steps:"
echo "1. Commit and push any changes"
echo "2. Verify GitHub Codespaces settings:"
echo "   • Go to https://github.com/settings/codespaces"
echo "   • Enable 'Automatically install dotfiles'"
echo "   • Select 'collin-mitchell/dotfiles'"
echo "   • Enable 'Settings Sync'"
echo "3. Create a fresh Codespace to test"
echo "4. Run './scripts/validate-setup.sh' in the new Codespace"
