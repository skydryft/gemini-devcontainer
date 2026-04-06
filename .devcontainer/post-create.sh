#!/bin/bash
# post-create.sh — Runs once after container creation (including rebuilds).
# Installs Gemini CLI GT, Ruby on Rails, and configures PostgreSQL.
set -e

echo "==> Setting up Gemini CLI Rails dev environment..."

# --- Named volume ownership ---
# Docker creates named volumes as root. Fix ownership for the vscode user.
sudo chown -R vscode:vscode /home/vscode/.npm 2>/dev/null || true
sudo chown -R vscode:vscode /home/vscode/.gem 2>/dev/null || true
sudo chown -R vscode:vscode /home/vscode/.gemini 2>/dev/null || true
sudo chown -R vscode:vscode /usr/local/bundle 2>/dev/null || true

# --- Install Gemini CLI GT (from GitHub Packages) ---
echo "==> Installing Gemini CLI GT from GitHub Packages..."
echo "@skydryft:registry=https://npm.pkg.github.com" >> ~/.npmrc
sudo npm install -g @skydryft/gemini-cli@latest

# --- Update helper ---
sudo tee /usr/local/bin/update-gemini > /dev/null << 'SCRIPT'
#!/bin/bash
echo "==> Updating Gemini CLI GT..."
sudo npm install -g @skydryft/gemini-cli@latest --registry=https://npm.pkg.github.com
echo "==> Gemini CLI GT: $(gemini --version 2>/dev/null)"
SCRIPT
sudo chmod +x /usr/local/bin/update-gemini

# --- Install skills CLI (universal agent skill installer) ---
echo "==> Installing skills CLI..."
npm install -g skills

# --- Start PostgreSQL ---
echo "==> Starting PostgreSQL..."
sudo service postgresql start

# --- Create development databases ---
# Uses the rails superuser role created in the Dockerfile (avoids sudo -u postgres).
echo "==> Creating development databases..."
PGPASSWORD=rails createdb -U rails -h localhost app_development 2>/dev/null || true
PGPASSWORD=rails createdb -U rails -h localhost app_test 2>/dev/null || true

# --- Install Rails and Bundler ---
echo "==> Installing Rails and Bundler..."
gem install rails bundler --no-document

# --- Install project dependencies (if Gemfile exists) ---
if [ -f "Gemfile" ]; then
  echo "==> Installing project gem dependencies..."
  bundle install
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
echo "  Ruby:          $(ruby --version)"
echo "  Rails:         $(rails --version)"
echo "  Bundler:       $(bundler --version)"
echo "  PostgreSQL:    $(psql --version)"
echo "  Node.js:       $(node --version)"
echo ""
echo "Database credentials: rails/rails @ localhost:5432"
echo "  Development DB: app_development"
echo "  Test DB:        app_test"
echo ""
echo "To start a new Rails app:"
echo "  rails new myapp --database=postgresql"
echo ""
echo "For Gemini, set GEMINI_API_KEY or use OAuth: run 'gemini' and follow /auth prompts."
