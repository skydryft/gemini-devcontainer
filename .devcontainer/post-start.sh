#!/bin/bash
# post-start.sh — Runs every time the container starts (including after stop/start).
# Starts services, restores credentials, and configures git.

# --- Start PostgreSQL ---
# Ensure the database server is running on every container start.
sudo service postgresql start 2>/dev/null || true

# --- Git safe.directory ---
# Prevents "dubious ownership" errors across Docker Desktop, OrbStack, and
# Rancher Desktop where UID mapping can cause ownership mismatches.
# Add both /workspaces and the current directory as safe.
# Covers Docker Desktop, OrbStack, and Rancher Desktop UID mismatches.
git config --global --add safe.directory /workspaces 2>/dev/null || true
if [ -n "$PWD" ] && [ "$PWD" != "/workspaces" ]; then
  git config --global --add safe.directory "$PWD" 2>/dev/null || true
fi

# --- Gemini auth status ---
# Report which authentication method is active so users know their quota tier.
if [ -n "$GEMINI_API_KEY" ] || [ -n "$GOOGLE_API_KEY" ]; then
  echo "Gemini auth: API key detected (10 RPM free tier — consider OAuth for 6x quota)"
elif [ -f "$HOME/.gemini/google_accounts.json" ]; then
  echo "Gemini auth: OAuth credentials found (60 RPM)"
else
  echo "Gemini auth: not configured — run 'gemini' and use /auth to set up"
fi
