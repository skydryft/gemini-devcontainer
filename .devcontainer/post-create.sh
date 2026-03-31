#!/bin/bash
# post-create.sh — Runs once after container creation (including rebuilds).
# Installs Gemini CLI, Claude Code, and project dependencies.
set -e

echo "==> Setting up Gemini CLI dev environment..."

# --- Named volume ownership ---
# Docker creates named volumes as root. Fix ownership for the vscode user.
sudo chown vscode:vscode node_modules 2>/dev/null || true
sudo chown -R vscode:vscode /home/vscode/.gemini 2>/dev/null || true

# --- Install Gemini CLI ---
echo "==> Installing Gemini CLI..."
npm install -g @google/gemini-cli@latest

# --- Install Claude Code ---
echo "==> Installing Claude Code..."
CI=true curl -fsSL https://claude.ai/install.sh | CI=true bash

# Ensure ~/.local/bin is on PATH
if ! grep -q 'local/bin' ~/.bashrc 2>/dev/null; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi
export PATH="$HOME/.local/bin:$PATH"

# --- Claude Code credential persistence helper ---
# Creates a 'persist-claude-auth' command that saves credentials to the
# shared Docker named volume (claude-credentials -> /home/vscode/.claude-auth).
cat > ~/.local/bin/persist-claude-auth << 'SCRIPT'
#!/bin/bash
set -e
VOLUME_PATH="/home/vscode/.claude-auth"
if [ ! -d "$VOLUME_PATH" ]; then
  echo "Error: Claude credentials volume not mounted at $VOLUME_PATH"
  exit 1
fi
if [ -f ~/.claude/.credentials.json ]; then
  cp ~/.claude/.credentials.json "$VOLUME_PATH/credentials.json"
  echo "Saved Claude credentials to persistent volume."
else
  echo "No Claude credentials found. Run 'claude login' first."
  exit 1
fi
if [ -f ~/.claude.json ]; then
  cp ~/.claude.json "$VOLUME_PATH/claude.json"
fi
SCRIPT
chmod +x ~/.local/bin/persist-claude-auth

# --- Install project dependencies ---
if [ -f "package.json" ]; then
  echo "==> Installing project dependencies..."
  npm install
fi

# --- Copy template files if they don't exist ---
# .geminiignore: Critical for startup performance in containers.
if [ ! -f ".geminiignore" ] && [ -f ".geminiignore.template" ]; then
  cp .geminiignore.template .geminiignore
  echo "==> Copied .geminiignore template (startup optimization)."
fi

# .gemini/settings.json: Optimized defaults for container environment.
# The project-level .gemini/ dir has optimized settings; the named volume at
# ~/.gemini/ is for user-level config (OAuth tokens, preferences).
if [ ! -f "$HOME/.gemini/settings.json" ] && [ -f ".gemini/settings.json" ]; then
  cp .gemini/settings.json "$HOME/.gemini/settings.json"
  echo "==> Copied optimized settings.json to user config."
fi

# --- Status report ---
echo ""
echo "=== Setup complete ==="
echo "  Gemini CLI: $(gemini --version 2>/dev/null || echo 'installed (checking...)')"
echo "  Claude Code: $(claude --version 2>/dev/null || echo 'installed (checking...)')"
echo "  Node.js: $(node --version)"
echo ""
echo "First time? Run 'claude login' then 'persist-claude-auth' to save credentials."
echo "For Gemini, set GEMINI_API_KEY or use OAuth: run 'gemini' and follow /auth prompts."
