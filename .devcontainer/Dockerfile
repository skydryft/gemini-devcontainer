FROM mcr.microsoft.com/devcontainers/base:ubuntu

# System utilities for Gemini CLI shell tool and development.
# ripgrep/fd-find: fast file search used by Gemini CLI tools.
# jq/tree: useful for inspecting JSON configs and project structure.
RUN apt-get update && apt-get install -y --no-install-recommends \
    ripgrep fd-find jq tree \
    && rm -rf /var/lib/apt/lists/*
