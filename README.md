# Kurrier Helm Chart

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/kurrier)](https://artifacthub.io/packages/search?repo=kurrier)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Helm chart for deploying [Kurrier](https://www.kurrier.org) - a modern, self-hosted webmail that integrates with all major Email Service Providers (ESPs).

## Overview

Kurrier is a self-hosted webmail platform that connects to standard protocols and providers — IMAP, SMTP, AWS SES, SendGrid, Mailgun, Postmark, and more. This Helm chart deploys the complete Kurrier stack including:

- **Kurrier Web Dashboard** - Next.js-based frontend
- **Kurrier Worker** - Nitro API backend and job runner
- **Supabase Stack** - PostgreSQL (with Supabase extensions), Authentication, Storage, Realtime, and API Gateway
- **Typesense** - Fast search engine for email indexing
- **Radicale** - CardDAV/CalDAV server for contacts and calendars
- **Valkey** - Redis-compatible cache (community fork of Redis)

> **Note:** PostgreSQL is included as part of the Supabase stack using the `supabase/postgres` image which includes necessary extensions for Supabase services. This is **not** the Bitnami PostgreSQL chart.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8+
- PV provisioner support in the underlying infrastructure (for persistence)
- At least 4GB RAM and 2 CPU cores available in your cluster

## Installation

### Add the Helm Repository

```bash
helm repo add kurrier https://codekoala.github.io/kurrier-helm
helm repo update
```

### Quick Start

```bash
# Create namespace
kubectl create namespace kurrier

# Install with default values
helm install kurrier kurrier/kurrier -n kurrier
```

### Production Installation

For production deployments, create a `values-production.yaml` file:

```yaml
# Production values example
kurrier:
  webUrl: "https://mail.example.com"
  jwt:
    existingSecret: kurrier-jwt-secrets

ingress:
  enabled: true
  className: nginx
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
    nginx.ingress.kubernetes.io/proxy-body-size: "50m"
  hosts:
    - host: mail.example.com
      paths:
        - path: /
          pathType: Prefix
          service: web
        - path: /api
          pathType: Prefix
          service: kong
  tls:
    - secretName: kurrier-tls
      hosts:
        - mail.example.com

postgresql:
  auth:
    existingSecret: kurrier-postgres-secret
  primary:
    persistence:
      size: 50Gi

redis:
  auth:
    existingSecret: kurrier-redis-secret
  master:
    persistence:
      size: 10Gi

web:
  replicaCount: 2
  resources:
    requests:
      cpu: 250m
      memory: 512Mi
    limits:
      cpu: 1000m
      memory: 1Gi

worker:
  replicaCount: 2
  resources:
    requests:
      cpu: 500m
      memory: 1Gi
    limits:
      cpu: 2000m
      memory: 2Gi

podDisruptionBudget:
  enabled: true
  minAvailable: 1
```

Install with production values:

```bash
helm install kurrier kurrier/kurrier -n kurrier -f values-production.yaml
```

## Configuration

### Global Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `global.imageRegistry` | Global Docker image registry | `""` |
| `global.imagePullSecrets` | Global image pull secrets | `[]` |
| `global.storageClass` | Global storage class for PVCs | `""` |

### Kurrier Core Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `kurrier.webUrl` | Public URL for Kurrier | `"http://localhost:3000"` |
| `kurrier.apiUrl` | API URL (internal) | `"http://localhost:3001"` |
| `kurrier.localTunnelUrl` | Local tunnel URL for development | `""` |
| `kurrier.jwt.secret` | JWT secret (min 32 chars) | `"your-super-secret-jwt-token..."` |
| `kurrier.jwt.anonKey` | Supabase anonymous key | `"eyJhbG..."` |
| `kurrier.jwt.serviceRoleKey` | Supabase service role key | `"eyJhbG..."` |
| `kurrier.jwt.existingSecret` | Existing secret for JWT keys | `""` |

### Web Dashboard Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `web.enabled` | Enable web dashboard | `true` |
| `web.replicaCount` | Number of replicas | `1` |
| `web.image.repository` | Image repository | `ghcr.io/kurrier-org/kurrier-web` |
| `web.image.tag` | Image tag | `""` (uses appVersion) |
| `web.service.type` | Service type | `ClusterIP` |
| `web.service.port` | Service port | `3000` |
| `web.resources.limits.cpu` | CPU limit | `500m` |
| `web.resources.limits.memory` | Memory limit | `512Mi` |

### Worker Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `worker.enabled` | Enable worker | `true` |
| `worker.replicaCount` | Number of replicas | `1` |
| `worker.image.repository` | Image repository | `ghcr.io/kurrier-org/kurrier-worker` |
| `worker.service.port` | Service port | `3001` |
| `worker.resources.limits.cpu` | CPU limit | `1000m` |
| `worker.resources.limits.memory` | Memory limit | `1Gi` |

### Supabase Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `supabase.enabled` | Enable Supabase stack | `true` |
| `supabase.kong.enabled` | Enable Kong API gateway | `true` |
| `supabase.auth.enabled` | Enable GoTrue auth | `true` |
| `supabase.auth.siteUrl` | Site URL for auth | `"http://localhost:3000"` |
| `supabase.rest.enabled` | Enable PostgREST | `true` |
| `supabase.realtime.enabled` | Enable Realtime | `true` |
| `supabase.storage.enabled` | Enable Storage | `true` |
| `supabase.storage.backend` | Storage backend (file/s3) | `"file"` |
| `supabase.studio.enabled` | Enable Studio dashboard | `true` |

### Supabase PostgreSQL Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `supabase.db.enabled` | Enable Supabase PostgreSQL | `true` |
| `supabase.db.image.repository` | PostgreSQL image | `supabase/postgres` |
| `supabase.db.image.tag` | PostgreSQL image tag | `15.1.1.78` |
| `supabase.db.password` | Postgres password | `"your-super-secret..."` |
| `supabase.db.database` | Database name | `"postgres"` |
| `supabase.db.existingSecret` | Use existing secret for password | `""` |
| `supabase.db.persistence.enabled` | Enable persistence | `true` |
| `supabase.db.persistence.size` | Storage size | `20Gi` |

### External PostgreSQL

| Parameter | Description | Default |
|-----------|-------------|---------|
| `externalPostgresql.enabled` | Use external PostgreSQL | `false` |
| `externalPostgresql.host` | PostgreSQL host | `""` |
| `externalPostgresql.port` | PostgreSQL port | `5432` |
| `externalPostgresql.database` | Database name | `"kurrier"` |

### Valkey Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `valkey.enabled` | Enable Valkey | `true` |
| `valkey.image.repository` | Valkey image | `valkey/valkey` |
| `valkey.image.tag` | Valkey image tag | `8.0` |
| `valkey.password` | Valkey password | `"replace_with..."` |
| `valkey.existingSecret` | Use existing secret for password | `""` |
| `valkey.persistence.enabled` | Enable persistence | `true` |
| `valkey.persistence.size` | Storage size | `8Gi` |

### External Redis/Valkey

| Parameter | Description | Default |
|-----------|-------------|---------|
| `externalRedis.enabled` | Use external Redis/Valkey | `false` |
| `externalRedis.host` | Redis host | `""` |
| `externalRedis.port` | Redis port | `6379` |

### Typesense Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `typesense.enabled` | Enable Typesense | `true` |
| `typesense.apiKey` | Typesense API key | `"supersecretkey"` |
| `typesense.persistence.enabled` | Enable persistence | `true` |
| `typesense.persistence.size` | Storage size | `10Gi` |

### DAV (CardDAV/CalDAV) Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `dav.enabled` | Enable DAV services | `true` |
| `dav.radicale.enabled` | Enable Radicale | `true` |
| `dav.radicale.persistence.size` | Storage size | `5Gi` |

### Ingress Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable ingress | `false` |
| `ingress.className` | Ingress class name | `""` |
| `ingress.annotations` | Ingress annotations | `{}` |
| `ingress.hosts` | Ingress hosts configuration | `[]` |
| `ingress.tls` | TLS configuration | `[]` |

## Secrets Management

For production deployments, use Kubernetes secrets instead of values:

### Create JWT Secrets

```bash
# Generate secure secrets
JWT_SECRET=$(openssl rand -base64 32)

kubectl create secret generic kurrier-jwt-secrets \
  --namespace kurrier \
  --from-literal=jwt-secret="$JWT_SECRET" \
  --from-literal=anon-key="your-anon-key" \
  --from-literal=service-role-key="your-service-role-key"
```

### Create PostgreSQL Secret

```bash
kubectl create secret generic kurrier-postgres-secret \
  --namespace kurrier \
  --from-literal=postgres-password="your-secure-password"
```

### Create Valkey Secret

```bash
kubectl create secret generic kurrier-valkey-secret \
  --namespace kurrier \
  --from-literal=valkey-password="your-secure-password"
```

## Upgrading

```bash
helm upgrade kurrier kurrier/kurrier -n kurrier -f values.yaml
```

## Uninstalling

```bash
helm uninstall kurrier -n kurrier
```

To also remove persistent volumes:

```bash
kubectl delete pvc -n kurrier -l app.kubernetes.io/instance=kurrier
```

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Ingress Controller                        │
└─────────────────────────────┬───────────────────────────────────┘
                              │
          ┌───────────────────┼───────────────────┐
          │                   │                   │
          ▼                   ▼                   ▼
    ┌──────────┐       ┌──────────┐       ┌──────────┐
    │   Web    │       │   Kong   │       │  Studio  │
    │Dashboard │       │   API    │       │          │
    └────┬─────┘       └────┬─────┘       └────┬─────┘
         │                  │                   │
         └──────────────────┼───────────────────┘
                            │
         ┌──────────────────┼──────────────────┐
         │                  │                  │
         ▼                  ▼                  ▼
   ┌──────────┐       ┌──────────┐       ┌──────────┐
   │  Worker  │       │  Auth    │       │  REST    │
   │  (Nitro) │       │(GoTrue)  │       │(PostgREST)│
   └────┬─────┘       └────┬─────┘       └────┬─────┘
        │                  │                   │
        └──────────────────┼───────────────────┘
                           │
    ┌──────────────────────┼──────────────────────┐
    │                      │                      │
    ▼                      ▼                      ▼
┌──────────┐         ┌──────────┐          ┌──────────┐
│ Supabase │         │  Valkey  │          │Typesense │
│ Postgres │         │ (cache)  │          │ (search) │
└──────────┘         └──────────┘          └──────────┘
```

## Troubleshooting

### Pods not starting

Check pod events:
```bash
kubectl describe pod -n kurrier <pod-name>
```

### Database connection issues

Verify PostgreSQL is running:
```bash
kubectl get pods -n kurrier -l app.kubernetes.io/component=postgresql
kubectl logs -n kurrier -l app.kubernetes.io/component=postgresql
```

### Authentication issues

Check auth service logs:
```bash
kubectl logs -n kurrier -l app.kubernetes.io/component=auth
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This Helm chart is licensed under the MIT License. See [LICENSE](LICENSE) for details.

Kurrier itself is licensed under its own terms. See the [Kurrier repository](https://github.com/kurrier-org/kurrier) for details.

## Links

- [Kurrier Documentation](https://www.kurrier.org/docs)
- [Kurrier GitHub](https://github.com/kurrier-org/kurrier)
- [Chart Repository](https://github.com/codekoala/kurrier-helm)
