# Collin's Dotfiles for GitHub Codespaces

> **Optimized for GitHub Codespaces with Model Context Protocol (MCP) Support**

This repository contains my personal development environment configuration, specifically designed for GitHub Codespaces with comprehensive MCP server integration for enhanced AI-powered development workflows.

## 🚀 Quick Start

1. **Fork this repository** to your GitHub account
2. **Enable in Codespaces**: Go to [GitHub Settings > Codespaces](https://github.com/settings/codespaces)
   - ✅ Enable "Automatically install dotfiles"
   - ✅ Select your forked dotfiles repository
   - ✅ Enable "Settings Sync" for user-level VS Code preferences
3. **Create a new Codespace** - your environment will be automatically configured!

## 🤖 MCP Servers Configuration

This dotfiles repo includes 5 pre-configured MCP servers for enhanced AI capabilities:

| Server | Type | Purpose | Setup |
|--------|------|---------|-------|
| **sequential-thinking** | npx | Advanced reasoning & problem solving | ✅ Auto |
| **github-copilot-mcp** | API | GitHub integration & PR management | ⚠️ Needs token |
| **playwright** | npx | Browser automation & testing | ✅ Auto |
| **fetch** | Python | Web content retrieval & HTTP requests | ✅ Auto |
| **Context7** | npx | Up-to-date documentation lookup | ✅ Auto |

### � MCP Configuration Architecture

```
📁 Workspace-level (via dotfiles)
├── .vscode/mcp.json          # MCP server definitions
└── install.sh                # Dependency installation

⚙️ User-level (via Settings Sync)
├── Copilot Chat preferences
├── Extension settings
└── UI preferences
```

## � Configuration Persistence Strategy

### **What Goes in Dotfiles (Workspace-level)**
- ✅ **MCP server configurations** (`.vscode/mcp.json`)
- ✅ **Workspace settings** (`.vscode/settings.json`)
- ✅ **Setup scripts** (`install.sh`)
- ✅ **Environment-specific configs**

### **What Goes in Settings Sync (User-level)**
- ✅ **Copilot Chat agent mode**
- ✅ **Extension preferences**
- ✅ **Keybindings**
- ✅ **Theme & UI settings**
- ✅ **User snippets**

> **💡 Critical Rule for Future Agents**: Use dotfiles for project/workspace configurations that should be consistent across repositories. Use Settings Sync for personal preferences that should persist across all VS Code instances.

## 🔄 Settings Sync vs Dotfiles Decision Matrix

| Configuration Type | Method | Location | Scope | Persistence |
|-------------------|--------|----------|-------|-------------|
| **MCP Servers** | Dotfiles | `.vscode/mcp.json` | Workspace | ✅ Repository |
| **Copilot Chat Agent Mode** | Settings Sync | User Settings | Global | ✅ GitHub Account |
| **Project Dependencies** | Dotfiles | `install.sh` | Workspace | ✅ Repository |
| **VS Code Theme** | Settings Sync | User Settings | Global | ✅ GitHub Account |
| **Workspace Tasks** | Dotfiles | `.vscode/tasks.json` | Workspace | ✅ Repository |
| **Extension Settings** | Settings Sync | User Settings | Global | ✅ GitHub Account |
| **Launch Configs** | Dotfiles | `.vscode/launch.json` | Workspace | ✅ Repository |
| **Keybindings** | Settings Sync | User Settings | Global | ✅ GitHub Account |

## 🛠️ Manual Setup (if needed)

### GitHub Token Configuration
For the `github-copilot-mcp` server:
1. Create a [Personal Access Token](https://github.com/settings/tokens)
2. In VS Code, when prompted for `github_token`, paste your token
3. Token will be saved securely in Codespace

### Verify Installation
```bash
# Check MCP servers status
ls -la .vscode/mcp.json

# Verify Python dependencies
python -m mcp_server_fetch --help

# Test Node.js dependencies
npx @modelcontextprotocol/server-sequential-thinking --help
```

## 🔍 Troubleshooting

### MCP Servers Not Loading
1. **Restart VS Code window**: `Ctrl+Shift+P` → "Developer: Reload Window"
2. **Check installation logs**: `/workspaces/.codespaces/.persistedshare/creation.log`
3. **Verify dependencies**: Run `./install.sh` manually
4. **Check GitHub token**: Ensure token is provided for GitHub MCP server

### Settings Not Persisting
- **Workspace settings**: Ensure changes are in dotfiles and committed
- **User settings**: Verify Settings Sync is enabled in GitHub settings
- **MCP configs**: Check both workspace and user-level configs are synchronized

### Dependencies Missing
```bash
# Reinstall Python dependencies
pip install --user mcp-server-fetch

# Verify Node.js environment
node --version && npm --version
```

## 🎯 Usage Guidelines for AI Agents

### **When Working with This Environment**

1. **MCP Tools Available**:
   - Use `#mcp_sequential-th_sequentialthinking` for complex reasoning
   - Use `#mcp_fetch_fetch` for web content retrieval
   - Use Context7 by adding "use context7" to prompts for documentation
   - Use Playwright tools for browser automation tasks

2. **Configuration Changes**:
   - **Workspace-level changes** → Modify files in dotfiles repo and commit
   - **User-level changes** → Use VS Code settings UI (syncs automatically)

3. **Adding New MCP Servers**:
   - Add to `.vscode/mcp.json` in dotfiles
   - Update `install.sh` if dependencies needed
   - Test in current Codespace, then commit changes

### **Do's and Don'ts for Future Agents**

#### ✅ DO: Use Dotfiles For
- **MCP server configurations** (`.vscode/mcp.json`)
- **Workspace-specific settings** (`.vscode/settings.json`)
- **Project dependencies** (`install.sh`)
- **Development tools setup** (language runtimes, CLI tools)
- **Repository-specific configurations**
- **Build/task configurations** (`.vscode/tasks.json`)

#### ❌ DON'T: Use Dotfiles For  
- **User-level VS Code preferences** (use Settings Sync instead)
- **Personal UI customizations** (themes, keybindings)
- **Extension settings** (synced automatically)
- **Copilot Chat preferences** (user-level, use Settings Sync)
- **Personal snippets** (use Settings Sync)

## 🔄 Updating This Configuration

### Adding New MCP Servers
1. Edit `.vscode/mcp.json`
2. Add dependencies to `install.sh` if needed
3. Test in current Codespace
4. Commit and push changes
5. New Codespaces will automatically include changes

### Modifying Existing Servers
1. Update configuration in `.vscode/mcp.json`
2. Restart VS Code window to reload
3. Commit changes for future Codespaces

## � Repository Structure

```
dotfiles/
├── .vscode/
│   └── mcp.json                 # MCP server configuration (workspace-level)
├── install.sh                  # Dependency installation script
└── README.md                   # This comprehensive documentation
```

## 🎉 What You Get Out of the Box

- **5 powerful MCP servers** ready to use immediately
- **Automatic dependency installation** via `install.sh`
- **Consistent environment** across all new Codespaces
- **Personal preferences synced** via GitHub Settings Sync
- **Comprehensive documentation** for troubleshooting and maintenance
- **Clear separation** between workspace and user-level configurations

## 🤝 Best Practices Summary

### For Development Workflow
- **Workspace settings** → Commit to dotfiles repository
- **User preferences** → Let Settings Sync handle automatically
- **Dependencies** → Install via `install.sh` script
- **Documentation** → Keep README.md updated

### For AI Agent Integration
- **Follow the decision matrix** above for proper configuration placement
- **Test all changes** in a fresh Codespace before committing
- **Update documentation** when adding new tools or servers
- **Maintain clear separation** between workspace and user-level settings

---

**💡 Pro Tip**: This dual approach (dotfiles + Settings Sync) ensures maximum compatibility and persistence across all GitHub Codespace environments while maintaining proper separation of concerns. Always test changes in a new Codespace to verify the complete setup workflow.