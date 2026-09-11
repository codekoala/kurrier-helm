# Kurrier Helm Chart

A Helm chart for deploying [Kurrier](https://www.kurrier.org), a self-hosted
workspace for email, calendars, contacts, and storage.

This chart targets the current Kurrier v4 deployment model:

- Kurrier web dashboard
- Kurrier Nitro worker/API
- PostgreSQL
- Redis-compatible cache
- Typesense
- Baikal for CalDAV/CardDAV
- Garage for S3-compatible object storage
- A database migration Job based on the pinned upstream Kurrier init scripts

The previous chart versions modeled the old Supabase-based Kurrier stack. That
surface has been removed in chart `0.2.0`.

The chart defaults pin the upstream v4 init/migration archive while using the
`v3.9.6` web and worker images referenced by the upstream `v4.0.0` compose file.

## Install

```bash
helm install kurrier . -n kurrier --create-namespace -f examples/values-talos.yaml
```

For render-only validation:

```bash
helm lint .
helm template kurrier . -n kurrier -f examples/values-render-test.yaml
```

## Important Values

| Value | Purpose |
| --- | --- |
| `upstream.ref` | Kurrier upstream source tag used for init/migration scripts |
| `upstream.archiveUrl` | Archive URL fetched by migration/bootstrap init containers |
| `web.image.tag` | Kurrier web image tag |
| `worker.image.tag` | Kurrier worker image tag |
| `config.webUrl` | Public web URL |
| `config.davUrl` | Public DAV URL shown to clients |
| `secrets.existingSecret` | Existing Kubernetes Secret containing runtime secrets |
| `postgres.persistence.storageClass` | Main Postgres storage class |
| `baikalPostgres.persistence.storageClass` | Baikal Postgres storage class |
| `garage.enabled` | Enable bundled single-node Garage |
| `ingress.enabled` | Enable Kubernetes Ingress |
| `gateway.enabled` | Enable Gateway API HTTPRoute |

## Required Secret Keys

When `secrets.existingSecret` is set, the Secret must contain:

- `POSTGRES_PASSWORD`
- `BAIKAL_POSTGRES_PASSWORD`
- `DATABASE_URL`
- `DATABASE_RLS_URL`
- `DAV_DATABASE_URL`
- `REDIS_PASSWORD`
- `TYPESENSE_API_KEY`
- `JWT_SECRET`
- `APP_SECRET_ENCRYPTION_KEY`
- `GARAGE_RPC_SECRET`
- `GARAGE_ACCESS_KEY`
- `GARAGE_SECRET_KEY`
- `BAIKAL_ENCRYPTION_KEY`
- `BAIKAL_ADMIN_PASSWORD_HASH`
- `S3_ACCESS_KEY`
- `S3_SECRET_KEY`

Optional keys:

- `API_ADMIN_KEY`
- `OIDC_GOOGLE_CLIENT_SECRET`
- `OIDC_CLIENT_SECRET`

## Notes

- The chart defaults are suitable for rendering, not production.
- For production, use an existing Secret and SOPS/ExternalSecrets rather than
  committing secrets in values files.
- The migration Job currently downloads the pinned upstream source archive at
  install/upgrade time. Vendoring the migration SQL files into the chart would
  remove that runtime GitHub dependency.
- The downloader init containers use `wget --no-check-certificate` because the
  minimal Alpine downloader image does not ship a complete public CA store in
  this cluster after CA injection. The archive URL is pinned by chart values.
- Stateful data restore from older Kurrier/Supabase deployments should be planned
  separately; do not mount old PVC data into this v4 chart without schema review.
