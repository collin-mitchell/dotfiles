# GitHub Codespaces Settings Verification Guide

## 🔧 Required GitHub Settings for Dotfiles

**CRITICAL**: These settings must be configured in your GitHub account for the dotfiles to work automatically in new Codespaces.

### 📋 Step-by-Step Setup

1. **Go to GitHub Codespaces Settings**
   - Navigate to: https://github.com/settings/codespaces
   - Or: GitHub → Settings → Codespaces (in left sidebar)

2. **Enable Dotfiles**
   - ✅ Check "Automatically install dotfiles"
   - 📁 Repository: Select `collin-mitchell/dotfiles`
   - 🔧 Installation command: Leave default or set to `./install.sh`

3. **Enable Settings Sync**
   - ✅ Check "Settings Sync"
   - This syncs VS Code user preferences across all Codespaces

4. **Optional: Trusted Repositories**
   - Add repositories where you want these dotfiles applied
   - Leave empty to apply to all Codespaces

### 🔍 Verification Checklist

After configuring settings, verify:

- [ ] **Dotfiles enabled**: ✅ "Automatically install dotfiles" checked
- [ ] **Repository selected**: `collin-mitchell/dotfiles` 
- [ ] **Settings Sync enabled**: ✅ "Settings Sync" checked
- [ ] **Installation command**: `./install.sh` (or default)

### 🧪 Testing Process

1. **Save GitHub settings** (they auto-save)
2. **Create a test Codespace** from any repository
3. **Wait for dotfiles installation** (check terminal output)
4. **Run validation**: `./scripts/validate-setup.sh`
5. **Test MCP tools** in Copilot Chat

### ⚠️ Common Issues

**Issue: Dotfiles not installing**
- ✅ Verify settings at https://github.com/settings/codespaces
- ✅ Check repository is public or you have access
- ✅ Ensure `install.sh` is executable in repository

**Issue: Settings not syncing**
- ✅ Enable Settings Sync in GitHub settings
- ✅ Enable Settings Sync in VS Code (Ctrl+Shift+P → "Settings Sync: Turn On")
- ✅ Sign in to same GitHub account in VS Code

**Issue: MCP servers not loading**
- ✅ Wait for dotfiles installation to complete
- ✅ Restart VS Code window (Ctrl+Shift+P → "Developer: Reload Window")
- ✅ Check VS Code Output panel for errors

### 🎉 Success Indicators

When everything is working correctly:

1. **Codespace starts** with dotfiles installation messages
2. **MCP servers load** (5 servers: sequential-thinking, github-copilot-mcp, playwright, fetch, Context7)
3. **Copilot Chat** can use MCP tools (try `#mcp_fetch_fetch`)
4. **User preferences** are synced (themes, keybindings, etc.)

### 🆘 Troubleshooting

If issues persist:

1. **Check Codespace creation logs**: `/workspaces/.codespaces/.persistedshare/creation.log`
2. **Re-run setup**: `./install.sh`
3. **Validate setup**: `./scripts/validate-setup.sh`
4. **Check VS Code Output**: Look for MCP-related errors
5. **Restart VS Code**: Reload window to refresh MCP connections

---

**💡 Pro Tip**: Test these settings with a simple repository first before using in important projects. The settings apply globally to all your Codespaces.
