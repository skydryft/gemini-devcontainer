FROM mcr.microsoft.com/devcontainers/base:ubuntu

# System utilities for Gemini CLI shell tool and development.
# ripgrep/fd-find: fast file search used by Gemini CLI tools.
# jq/tree: useful for inspecting JSON configs and project structure.
# build-essential/libyaml-dev: native extension compilation (pg gem, psych, etc.)
# libpq-dev: PostgreSQL client library headers for the pg gem.
# postgresql/postgresql-contrib: local PostgreSQL server for development.
RUN apt-get update && apt-get install -y --no-install-recommends \
    ripgrep fd-find jq tree \
    build-essential libyaml-dev libpq-dev \
    postgresql postgresql-contrib \
    && rm -rf /var/lib/apt/lists/*

# Configure PostgreSQL for local development.
# Create a superuser role matching the dev credentials (rails/rails).
RUN service postgresql start \
    && su - postgres -c "psql -c \"CREATE ROLE rails WITH LOGIN SUPERUSER PASSWORD 'rails';\"" \
    && service postgresql stop

# Allow local password authentication for the rails role.
RUN PG_HBA=$(find /etc/postgresql -name pg_hba.conf | head -1) \
    && sed -i 's/local\s\+all\s\+all\s\+peer/local   all             all                                     md5/' "$PG_HBA" \
    && echo "host    all             all             127.0.0.1/32            md5" >> "$PG_HBA" \
    && echo "host    all             all             ::1/128                 md5" >> "$PG_HBA"

# Pre-create config directories with correct ownership.
# These may be overlaid by named volumes or bind mounts at runtime.
RUN mkdir -p /home/vscode/.gemini/tracker/tasks \
    && chown -R vscode:vscode /home/vscode/.gemini
