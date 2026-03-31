#!/bin/bash
# post-create.sh — Runs once after container creation (including rebuilds).
# Installs Gemini CLI GT and project dependencies.
set -e

echo "==> Setting up Gemini CLI dev environment..."

# --- Named volume ownership ---
# Docker creates named volumes as root. Fix ownership for the vscode user.
sudo chown vscode:vscode node_modules 2>/dev/null || true
sudo chown -R vscode:vscode /home/vscode/.npm 2>/dev/null || true
sudo chown -R vscode:vscode /home/vscode/.gemini 2>/dev/null || true

# --- Install Gemini CLI GT (build from source) ---
# GitHub Packages requires auth even for public packages, so we clone and build.
# Uses --ignore-scripts to skip husky/prepare hooks, then builds explicitly.
echo "==> Installing Gemini CLI GT (building from source)..."
BUILD_DIR=$(mktemp -d)
git clone --depth 1 https://github.com/skydryft/gemini-cli-gt.git "$BUILD_DIR/gemini-cli-gt"
cd "$BUILD_DIR/gemini-cli-gt"
npm install --ignore-scripts
npm run generate
npm run build --workspace=@skydryft/gemini-cli-core
npm run build --workspace=@skydryft/gemini-cli-devtools
npm run build --workspace=@skydryft/gemini-cli
node esbuild.config.js
npm install -g --ignore-scripts .
cd /workspaces
rm -rf "$BUILD_DIR"

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
echo "  Gemini CLI GT: $(gemini --version 2>/dev/null || echo 'installed (checking...)')"
echo "  Node.js: $(node --version)"
echo ""
echo "For Gemini, set GEMINI_API_KEY or use OAuth: run 'gemini' and follow /auth prompts."
