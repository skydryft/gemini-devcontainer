# Gemini Devcontainer

A templated devcontainer bootstrapper for Gemini CLI-assisted projects. Provides a pre-configured development environment where Gemini CLI runs efficiently out of the box with shell-only mode enabled.

## What This Is

This is a starter template for new projects that use Gemini CLI as the primary AI development assistant. It includes:

- A devcontainer configuration with Gemini CLI pre-installed from the [gemini-cli-gt](../gemini-cli-gt/) fork
- Pre-tuned `.gemini/settings.json` with shell-only mode enabled for optimal model performance
- A `GEMINI.md` template with workflow guidance that works with the reduced tool set
- Credential persistence across container rebuilds via a shared Docker volume

## Quick Start

1. Copy this directory as the base for a new project
2. Update `GEMINI.md` with your project's context, tech stack, and build commands
3. Open in VS Code / Codespaces — the devcontainer builds automatically
4. Run `gemini` in the terminal

## Shell-Only Mode

This template ships with shell-only mode enabled by default. Instead of giving the model 25+ specialized tools to choose from, it gets 4:

| Tool | Purpose |
|---|---|
| `run_shell_command` | All file operations, builds, tests — everything goes through bash |
| `ask_user` | Ask clarifying questions back to the user |
| `update_topic` | Conversation topic metadata |
| `save_memory` | Persist facts across sessions |

The model uses standard Unix commands (`grep`, `find`, `cat`, `sed`, etc.) for file operations. This plays to Gemini's training strengths and eliminates tool selection overhead.

See [shell-only mode research](../docs/research/gemini-cli/shell-only-mode.md) for the rationale and test results.

## Configuration

### `.gemini/settings.json`

```json
{
  "tools": {
    "core": ["run_shell_command", "ask_user", "update_topic", "save_memory"]
  }
}
```

To revert to the full tool set, remove the `tools.core` key entirely.

### `GEMINI.md`

The project context file. Edit the `<project_context>` section with your project's description, and fill in the build/test/lint commands once established. The `<workflow>` section guides the model on how to approach greenfield vs existing codebases.

### Credential Persistence

Credentials are stored in a shared Docker named volume (`claude-credentials`):

- First time: run `gemini` and authenticate, then run `persist-claude-auth`
- Credentials auto-restore on every container start or rebuild
- Shared across all devcontainer projects using this bootstrapper

## Project Structure

```
.devcontainer/
  devcontainer.json    Container configuration
.gemini/
  settings.json        Gemini CLI settings (shell-only mode)
GEMINI.md              Project context for the AI agent
```

## Customizing the Devcontainer

The base image is generic Ubuntu. For your project, update `.devcontainer/devcontainer.json` with:

- The appropriate base image (e.g., `mcr.microsoft.com/devcontainers/python:3.12`)
- Dev container features for additional tooling
- `postCreateCommand` for dependency installation

After changes, rebuild the container (`Cmd/Ctrl+Shift+P` > "Rebuild Container").

## License

Apache License 2.0
