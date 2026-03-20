# Gitea

Self-hosted lightweight Git server with code review, issue tracking, CI/CD, and wiki — a GitHub/GitLab alternative that runs on minimal resources.

## What It Does

- Git repository hosting with web interface
- Pull requests and code review
- Issue tracking and project boards
- Built-in CI/CD (Gitea Actions, compatible with GitHub Actions)
- Wiki per repository
- SQLite backend (zero external database dependencies)

## Quick Start

```bash
dream enable gitea
dream start gitea
```

Open **http://localhost:7830** to access the Gitea web UI.

**Note:** Registration is disabled by default. Set `GITEA_ADMIN_USER` and `GITEA_ADMIN_PASSWORD` environment variables before first run to create the admin account.

### Clone via SSH

```bash
git clone ssh://git@localhost:2222/username/repo.git
```

## API Usage

### List Repositories

```bash
curl -H "Authorization: token YOUR_TOKEN" \
  http://localhost:7830/api/v1/repos/search
```

### Health Check

```bash
curl http://localhost:7830/api/healthz
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `GITEA_HOST` | `localhost` | Hostname for Gitea server |
| `GITEA_PORT` | `7830` | External port for web interface |
| `GITEA_SSH_PORT` | `2222` | External port for SSH access |
| `GITEA_APP_NAME` | `Dream Server Git` | Display name for the instance |
| `GITEA_ADMIN_USER` | _(empty)_ | Admin username (created on first run) |
| `GITEA_ADMIN_PASSWORD` | _(empty)_ | Admin password (created on first run) |
| `GITEA_ADMIN_EMAIL` | `admin@localhost` | Admin email address |

## Data Persistence

- `./data/gitea/` — Repositories, database, configuration, and uploads
