# sixpack-docker

Docker image and orchestration for [Sixpack](https://github.com/seatgeek/sixpack) A/B testing service.

## Overview

This project provides:

- **Dockerfile**: Multi-purpose image for Sixpack API and Web (Python 2.7.18, pinned dependencies, Gunicorn).
- **Docker Compose**: Local stack with Sixpack API, Sixpack Web, and Redis.
- **Kubernetes**: Deployment and service manifests for API and Web under `kube/`.

## Requirements

- Docker and Docker Compose (Compose V2)
- For Kubernetes: `kubectl` and cluster access

## Docker Compose

### Starting the stack

Build and start all services (API, Web, Redis):

```bash
docker compose up --build
```

- **Sixpack API**: <http://localhost:5000>
- **Sixpack Web**: <http://localhost:5001>
- **Redis**: internal only (port 6379)

Run in detached mode (background):

```bash
docker compose up --build -d
```

### Stopping the stack

Stop and remove containers, networks, and optionally volumes:

```bash
docker compose down
```

To also remove volumes (e.g. Redis data):

```bash
docker compose down -v
```

### Other useful commands

- View logs: `docker compose logs -f`
- Restart a service: `docker compose restart sixpackapi` or `docker compose restart sixpackweb`
- Rebuild after Dockerfile changes: `docker compose up --build`

## Image details

- **Base**: `python:2.7.18`
- **Sixpack**: 2.0.2, installed with `--no-deps`; dependencies are pinned to avoid pulling yuicompressor from PyPI.
- **Server**: Gunicorn 19.3.0 with gevent workers (default CMD).
- **Commands**: `sixpack` (API) and `sixpack-web` (Web) are used in Compose and Kubernetes.

## Environment variables

| Variable | Description |
|----------|-------------|
| `SIXPACK_CONFIG_ENABLED` | Enable Sixpack (e.g. `true`) |
| `SIXPACK_CONFIG_REDIS_HOST` | Redis host (e.g. `redis` in Compose) |
| `SIXPACK_CONFIG_REDIS_PORT` | Redis port (default `6379`) |
| `SIXPACK_CONFIG_REDIS_PREFIX` | Redis key prefix (e.g. `sixpack`) |
| `SIXPACK_CONFIG_CSRF_DISABLE` | Disable CSRF (optional, used in Web in k8s) |

## Kubernetes

Manifests in `kube/`:

- `sixpack-api-controller.yaml` – Deployment for API (`command: sixpack`)
- `sixpack-web-controller.yaml` – Deployment for Web (`command: sixpack-web`)
- `service-sixpack-api.yaml` – Service for API (port 80 → container `targetPort: 5000`)
- `service-sixpack-web.yaml` – Service for Web (port 80 → container `targetPort: 5001`)

Deployments use image `leogamas/sixpack:v0.1` and expect a Redis service (e.g. `sixpack-redis-db`).
