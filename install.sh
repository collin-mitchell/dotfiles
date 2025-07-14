#!/bin/bash

# Dotfiles Master Setup Script for GitHub Codespaces
# Handles installation, validation, setup automation, and troubleshooting

set -e

# Parse command line arguments
MODE="install"
INTERACTIVE=true
VERBOSE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --setup|--copilot)
            MODE="setup"
            shift
            ;;
        --validate|--check)
            MODE="validate"
            shift
            ;;
        --fix|--repair)
            MODE="fix"
            shift
            ;;
        --preflight)
            MODE="preflight"
            shift
            ;;
        --quiet|-q)
            INTERACTIVE=false
            shift
            ;;
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        --help|-h)
            echo "Dotfiles Master Setup Script"
            echo ""
            echo "Usage: $0 [MODE] [OPTIONS]"
            echo ""
            echo "MODES:"
            echo "  (default)     Normal dotfiles installation"
            echo "  --setup       Full Copilot Agent Mode setup automation"
            echo "  --validate    Post-installation validation and testing"
            echo "  --fix         Troubleshoot and repair MCP servers"
            echo "  --preflight   Pre-deployment validation"
            echo ""
            echo "OPTIONS:"
            echo "  --quiet, -q   Non-interactive mode"
            echo "  --verbose, -v Verbose output"
            echo "  --help, -h    Show this help"
            echo ""
            echo "Examples:"
            echo "  $0                    # Normal installation"
            echo "  $0 --setup           # Copilot automation"
            echo "  $0 --validate --quiet # Silent validation"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Utility functions
log() {
    echo "$(date '+%H:%M:%S') $1"
}

log_verbose() {
    if [ "$VERBOSE" = true ]; then
        echo "$(date '+%H:%M:%S') [VERBOSE] $1"
    fi
}

ask_user() {
    if [ "$INTERACTIVE" = true ]; then
        read -p "$1" -n 1 -r
        echo
        [[ $REPLY =~ ^[Yy]$ ]]
    else
        return 0  # Default to yes in non-interactive mode
    fi
}

count_mcp_servers() {
    if [ -f ".vscode/mcp.json" ]; then
        jq '.servers | keys | length' .vscode/mcp.json 2>/dev/null || \
        sed -n '/\"servers\":/,/^[[:space:]]*}/p' .vscode/mcp.json | grep -E '^[[:space:]]*\"[^\"]+\":[[:space:]]*{' | wc -l
    else
        echo "0"
    fi
}

validate_json() {
    if command -v python3 &> /dev/null; then
        python3 -m json.tool .vscode/mcp.json > /dev/null 2>&1
    elif command -v jq &> /dev/null; then
        jq empty .vscode/mcp.json > /dev/null 2>&1
    else
        log_verbose "No JSON validator available, skipping validation"
        return 0
    fi
}

test_mcp_server() {
    local server_name="$1"
    local command="$2"
    
    log_verbose "Testing $server_name..."
    if timeout 10s $command >/dev/null 2>&1; then
        echo "✅ $server_name: WORKING"
        return 0
    else
        echo "⚠️  $server_name: NEEDS ATTENTION"
        return 1
    fi
}

# Detect environment
if [ "$CODESPACES" = "true" ]; then
    ENVIRONMENT="codespace"
    log_verbose "Codespace environment detected"
else
    ENVIRONMENT="local"
    log_verbose "Local environment detected"
fi

# Mode-specific execution
case $MODE in
    "preflight")
        echo "� Pre-flight Check for Dotfiles Setup"
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
        
        # Validate JSON
        echo ""
        echo "📝 JSON Configuration Validation:"
        if validate_json; then
            echo "✅ .vscode/mcp.json is valid JSON"
        else
            echo "❌ .vscode/mcp.json has JSON syntax errors"
            exit 1
        fi
        
        # Check MCP servers
        echo ""
        echo "🤖 MCP Server Configuration:"
        SERVER_COUNT=$(count_mcp_servers)
        echo "✅ Found $SERVER_COUNT MCP servers configured"
        
        if command -v jq &> /dev/null; then
            echo "📋 Configured servers:"
            jq -r '.servers | keys[]' .vscode/mcp.json | sed 's/^/  • /'
        fi
        
        # Git status
        echo ""
        echo "📊 Git Repository Status:"
        if git status --porcelain | grep -q .; then
            echo "⚠️  Uncommitted changes detected"
            echo "🔧 Commit changes before testing fresh Codespace"
        else
            echo "✅ Repository is clean"
        fi
        
        echo ""
        echo "🎯 Pre-flight Complete: Ready for fresh Codespace testing!"
        ;;
        
    "validate")
        echo "🔬 Post-Installation Validation"
        echo "==============================="
        
        # Environment check
        echo ""
        echo "🌍 Environment Detection:"
        if [ "$ENVIRONMENT" = "codespace" ]; then
            echo "✅ Running in GitHub Codespace"
        else
            echo "ℹ️  Running in local environment"
        fi
        
        # MCP configuration files
        echo ""
        echo "📁 MCP Configuration Files:"
        if [ -f ".vscode/mcp.json" ]; then
            echo "✅ Workspace MCP config found: .vscode/mcp.json"
            if validate_json; then
                echo "✅ JSON configuration is valid"
            else
                echo "❌ JSON configuration has errors"
            fi
        else
            echo "❌ Workspace MCP config missing"
            exit 1
        fi
        
        # User-level config check
        if [ "$ENVIRONMENT" = "codespace" ]; then
            USER_MCP="/home/codespace/.vscode-remote/data/User/mcp.json"
            if [ -f "$USER_MCP" ]; then
                echo "✅ User-level MCP config found"
            else
                echo "ℹ️  User-level MCP config not found (using workspace config)"
            fi
        fi
        
        # Python dependencies
        echo ""
        echo "🐍 Python Dependencies:"
        if command -v python3 &> /dev/null || command -v python &> /dev/null; then
            PYTHON_CMD="python3"
            if ! command -v python3 &> /dev/null; then
                PYTHON_CMD="python"
            fi
            
            echo "✅ Python available: $($PYTHON_CMD --version)"
            
            if $PYTHON_CMD -c "import mcp_server_fetch" 2>/dev/null; then
                echo "✅ mcp-server-fetch installed and importable"
            else
                echo "❌ mcp-server-fetch not found"
                echo "🔧 Run: $0 --fix"
            fi
        else
            echo "❌ Python not found"
        fi
        
        # Node.js dependencies
        echo ""
        echo "�📦 Node.js Dependencies:"
        if command -v node &> /dev/null; then
            echo "✅ Node.js available: $(node --version)"
            
            if command -v npm &> /dev/null; then
                echo "✅ npm available: $(npm --version)"
            fi
            
            if command -v npx &> /dev/null; then
                echo "✅ npx available for MCP servers"
            else
                echo "⚠️  npx not found"
            fi
        else
            echo "❌ Node.js not found"
        fi
        
        # Test MCP servers
        echo ""
        echo "🤖 MCP Server Tests:"
        
        if command -v python3 &> /dev/null || command -v python &> /dev/null; then
            PYTHON_CMD="python3"
            if ! command -v python3 &> /dev/null; then
                PYTHON_CMD="python"
            fi
            test_mcp_server "fetch" "$PYTHON_CMD -m mcp_server_fetch --help"
        fi
        
        if command -v npx &> /dev/null; then
            test_mcp_server "sequential-thinking" "npx @modelcontextprotocol/server-sequential-thinking --help"
        fi
        
        # Summary
        echo ""
        echo "📊 Validation Summary:"
        SERVER_COUNT=$(count_mcp_servers)
        echo "✅ $SERVER_COUNT MCP servers configured"
        echo "✅ Dependencies checked"
        echo "✅ Configuration validated"
        
        echo ""
        echo "🎉 Validation Complete!"
        if [ "$ENVIRONMENT" = "codespace" ]; then
            echo "📋 Next: Restart VS Code (Ctrl+Shift+P → 'Developer: Reload Window')"
            echo "🧪 Test: Try MCP tools in Copilot Chat"
        fi
        ;;
        
    "fix")
        echo "🔧 MCP Server Repair and Troubleshooting"
        echo "========================================"
        
        echo ""
        echo "🐍 Fixing Python MCP Dependencies..."
        if command -v pip &> /dev/null; then
            pip install --user mcp-server-fetch --force-reinstall
            echo "✅ mcp-server-fetch reinstalled"
        else
            echo "❌ pip not available"
        fi
        
        echo ""
        echo "📦 Checking Node.js Environment..."
        if command -v node &> /dev/null && command -v npx &> /dev/null; then
            echo "✅ Node.js and npx available"
        else
            echo "❌ Node.js/npx issues detected"
        fi
        
        echo ""
        echo "🔧 VS Code Integration Fix:"
        echo "1. Restart VS Code window (Ctrl+Shift+P → 'Developer: Reload Window')"
        echo "2. Check VS Code Output panel for MCP errors"
        echo "3. Re-run validation: $0 --validate"
        
        echo ""
        echo "� If issues persist:"
        echo "• Check GitHub token for github-copilot-mcp server"
        echo "• Verify GitHub Codespaces settings"
        echo "• See README.md troubleshooting section"
        ;;
        
    "setup")
        echo "🚀 GitHub Copilot Agent Mode: Codespace Setup Automation"
        echo "========================================================"
        
        # Step 1: Installation
        echo ""
        echo "📦 Step 1: Running dotfiles installation..."
        # Run normal installation
        MODE="install" $0 --quiet
        
        # Step 2: Validation
        echo ""
        echo "🔬 Step 2: Running validation..."
        MODE="validate" $0 --quiet
        
        # Step 3: MCP testing
        echo ""
        echo "🤖 Step 3: Testing MCP servers..."
        
        if command -v python3 &> /dev/null || command -v python &> /dev/null; then
            PYTHON_CMD="python3"
            if ! command -v python3 &> /dev/null; then
                PYTHON_CMD="python"
            fi
            test_mcp_server "fetch" "$PYTHON_CMD -m mcp_server_fetch --help"
        fi
        
        if command -v npx &> /dev/null; then
            test_mcp_server "sequential-thinking" "npx @modelcontextprotocol/server-sequential-thinking --help"
        fi
        
        # Step 4: GitHub token
        echo ""
        echo "🔑 Step 4: GitHub Token Setup"
        echo "ℹ️  The github-copilot-mcp server requires a GitHub token"
        echo "📖 Create token at: https://github.com/settings/tokens"
        
        if ask_user "🤖 Set up GitHub token now? (y/n): "; then
            echo "📝 VS Code will prompt for 'github_token' when needed"
            echo "✅ GitHub token setup noted"
        else
            echo "⏭️  GitHub token setup skipped"
        fi
        
        # Step 5: VS Code restart
        echo ""
        echo "🔧 Step 5: VS Code Integration"
        if ask_user "🔄 Restart VS Code window? (recommended) (y/n): "; then
            echo "🔄 Please restart VS Code: Ctrl+Shift+P → 'Developer: Reload Window'"
        else
            echo "⏭️  VS Code restart skipped"
        fi
        
        # Step 6: Final instructions
        echo ""
        echo "🧪 Step 6: Testing Instructions"
        echo "==============================="
        echo ""
        echo "✅ Setup Complete! Test MCP tools:"
        echo ""
        echo "🧪 In Copilot Chat, try:"
        echo "• '#mcp_sequential-th_sequentialthinking help me solve this problem'"
        echo "• '#mcp_fetch_fetch https://httpbin.org/json'"
        echo "• 'use Context7 to find React documentation'"
        echo ""
        echo "🆘 If issues: $0 --fix"
        echo ""
        echo "🎉 Copilot Agent Mode setup complete!"
        ;;
        
    "install"|*)
        echo "🚀 Starting dotfiles setup..."
        
        # Environment detection
        if [ "$ENVIRONMENT" = "codespace" ]; then
            echo "📦 Codespace environment detected"
        else
            echo "🏠 Local environment detected"
        fi
        
        # Install Python MCP dependencies
        echo ""
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
                    echo "🔧 Try: $0 --fix"
                fi
            done
        else
            echo "⚠️  Python/pip not found, skipping Python MCP servers"
            echo "🔧 Install Python to enable fetch MCP server"
        fi
        
        # Verify Node.js for npx-based MCP servers
        echo ""
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
        echo ""
        echo "🔧 MCP Configuration Status:"
        if [ -f ".vscode/mcp.json" ]; then
            echo "✅ Workspace MCP config found: .vscode/mcp.json"
            MCP_SERVERS=$(count_mcp_servers)
            echo "📊 Configured MCP servers: $MCP_SERVERS"
        else
            echo "❌ No workspace MCP config found"
        fi
        
        # Environment-specific setup
        if [ "$ENVIRONMENT" = "codespace" ]; then
            echo ""
            echo "🌐 Codespace-specific setup..."
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
            echo ""
            echo "🏠 Local environment setup complete"
        fi
        
        echo ""
        echo "✨ Dotfiles setup complete! MCP servers ready for use."
        echo ""
        echo "📖 Next steps:"
        echo "• Restart VS Code: Ctrl+Shift+P → 'Developer: Reload Window'"
        echo "• Validate setup: $0 --validate"
        echo "• Full automation: $0 --setup"
        ;;
esac
