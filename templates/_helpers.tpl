{{/*
Expand the name of the chart.
*/}}
{{- define "kurrier.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kurrier.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kurrier.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kurrier.labels" -}}
helm.sh/chart: {{ include "kurrier.chart" . }}
{{ include "kurrier.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kurrier.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kurrier.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "kurrier.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "kurrier.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Web component labels
*/}}
{{- define "kurrier.web.labels" -}}
{{ include "kurrier.labels" . }}
app.kubernetes.io/component: web
{{- end }}

{{/*
Web component selector labels
*/}}
{{- define "kurrier.web.selectorLabels" -}}
{{ include "kurrier.selectorLabels" . }}
app.kubernetes.io/component: web
{{- end }}

{{/*
Worker component labels
*/}}
{{- define "kurrier.worker.labels" -}}
{{ include "kurrier.labels" . }}
app.kubernetes.io/component: worker
{{- end }}

{{/*
Worker component selector labels
*/}}
{{- define "kurrier.worker.selectorLabels" -}}
{{ include "kurrier.selectorLabels" . }}
app.kubernetes.io/component: worker
{{- end }}

{{/*
Kong component labels
*/}}
{{- define "kurrier.kong.labels" -}}
{{ include "kurrier.labels" . }}
app.kubernetes.io/component: kong
{{- end }}

{{/*
Kong component selector labels
*/}}
{{- define "kurrier.kong.selectorLabels" -}}
{{ include "kurrier.selectorLabels" . }}
app.kubernetes.io/component: kong
{{- end }}

{{/*
Auth component labels
*/}}
{{- define "kurrier.auth.labels" -}}
{{ include "kurrier.labels" . }}
app.kubernetes.io/component: auth
{{- end }}

{{/*
Auth component selector labels
*/}}
{{- define "kurrier.auth.selectorLabels" -}}
{{ include "kurrier.selectorLabels" . }}
app.kubernetes.io/component: auth
{{- end }}

{{/*
REST component labels
*/}}
{{- define "kurrier.rest.labels" -}}
{{ include "kurrier.labels" . }}
app.kubernetes.io/component: rest
{{- end }}

{{/*
REST component selector labels
*/}}
{{- define "kurrier.rest.selectorLabels" -}}
{{ include "kurrier.selectorLabels" . }}
app.kubernetes.io/component: rest
{{- end }}

{{/*
Realtime component labels
*/}}
{{- define "kurrier.realtime.labels" -}}
{{ include "kurrier.labels" . }}
app.kubernetes.io/component: realtime
{{- end }}

{{/*
Realtime component selector labels
*/}}
{{- define "kurrier.realtime.selectorLabels" -}}
{{ include "kurrier.selectorLabels" . }}
app.kubernetes.io/component: realtime
{{- end }}

{{/*
Storage component labels
*/}}
{{- define "kurrier.storage.labels" -}}
{{ include "kurrier.labels" . }}
app.kubernetes.io/component: storage
{{- end }}

{{/*
Storage component selector labels
*/}}
{{- define "kurrier.storage.selectorLabels" -}}
{{ include "kurrier.selectorLabels" . }}
app.kubernetes.io/component: storage
{{- end }}

{{/*
Meta component labels
*/}}
{{- define "kurrier.meta.labels" -}}
{{ include "kurrier.labels" . }}
app.kubernetes.io/component: meta
{{- end }}

{{/*
Meta component selector labels
*/}}
{{- define "kurrier.meta.selectorLabels" -}}
{{ include "kurrier.selectorLabels" . }}
app.kubernetes.io/component: meta
{{- end }}

{{/*
Studio component labels
*/}}
{{- define "kurrier.studio.labels" -}}
{{ include "kurrier.labels" . }}
app.kubernetes.io/component: studio
{{- end }}

{{/*
Studio component selector labels
*/}}
{{- define "kurrier.studio.selectorLabels" -}}
{{ include "kurrier.selectorLabels" . }}
app.kubernetes.io/component: studio
{{- end }}

{{/*
Typesense component labels
*/}}
{{- define "kurrier.typesense.labels" -}}
{{ include "kurrier.labels" . }}
app.kubernetes.io/component: typesense
{{- end }}

{{/*
Typesense component selector labels
*/}}
{{- define "kurrier.typesense.selectorLabels" -}}
{{ include "kurrier.selectorLabels" . }}
app.kubernetes.io/component: typesense
{{- end }}

{{/*
Baikal component labels
*/}}
{{- define "kurrier.baikal.labels" -}}
{{ include "kurrier.labels" . }}
app.kubernetes.io/component: baikal
{{- end }}

{{/*
Baikal component selector labels
*/}}
{{- define "kurrier.baikal.selectorLabels" -}}
{{ include "kurrier.selectorLabels" . }}
app.kubernetes.io/component: baikal
{{- end }}

{{/*
WebDAV component labels
*/}}
{{- define "kurrier.webdav.labels" -}}
{{ include "kurrier.labels" . }}
app.kubernetes.io/component: webdav
{{- end }}

{{/*
WebDAV component selector labels
*/}}
{{- define "kurrier.webdav.selectorLabels" -}}
{{ include "kurrier.selectorLabels" . }}
app.kubernetes.io/component: webdav
{{- end }}

{{/*
PostgreSQL host
*/}}
{{- define "kurrier.postgresql.host" -}}
{{- if .Values.externalPostgresql.enabled }}
{{- .Values.externalPostgresql.host }}
{{- else }}
{{- printf "%s-db" (include "kurrier.fullname" .) }}
{{- end }}
{{- end }}

{{/*
PostgreSQL port
*/}}
{{- define "kurrier.postgresql.port" -}}
{{- if .Values.externalPostgresql.enabled }}
{{- .Values.externalPostgresql.port }}
{{- else }}
{{- 5432 }}
{{- end }}
{{- end }}

{{/*
PostgreSQL database
*/}}
{{- define "kurrier.postgresql.database" -}}
{{- if .Values.externalPostgresql.enabled }}
{{- .Values.externalPostgresql.database }}
{{- else }}
{{- .Values.supabase.db.database }}
{{- end }}
{{- end }}

{{/*
PostgreSQL username
*/}}
{{- define "kurrier.postgresql.username" -}}
{{- if .Values.externalPostgresql.enabled }}
{{- .Values.externalPostgresql.username }}
{{- else }}
{{- "postgres" }}
{{- end }}
{{- end }}

{{/*
PostgreSQL password secret name
*/}}
{{- define "kurrier.postgresql.secretName" -}}
{{- if .Values.externalPostgresql.enabled }}
{{- if .Values.externalPostgresql.existingSecret }}
{{- .Values.externalPostgresql.existingSecret }}
{{- else }}
{{- printf "%s-external-postgresql" (include "kurrier.fullname" .) }}
{{- end }}
{{- else }}
{{- if .Values.supabase.db.existingSecret }}
{{- .Values.supabase.db.existingSecret }}
{{- else }}
{{- printf "%s-db" (include "kurrier.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
PostgreSQL password secret key
*/}}
{{- define "kurrier.postgresql.secretKey" -}}
{{- if .Values.externalPostgresql.enabled }}
{{- default "postgresql-password" .Values.externalPostgresql.secretKey }}
{{- else }}
{{- default "postgres-password" .Values.supabase.db.secretKey }}
{{- end }}
{{- end }}

{{/*
Valkey/Redis host
*/}}
{{- define "kurrier.redis.host" -}}
{{- if .Values.externalRedis.enabled }}
{{- .Values.externalRedis.host }}
{{- else }}
{{- printf "%s-valkey" (include "kurrier.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Valkey/Redis port
*/}}
{{- define "kurrier.redis.port" -}}
{{- if .Values.externalRedis.enabled }}
{{- .Values.externalRedis.port }}
{{- else }}
{{- .Values.valkey.service.port }}
{{- end }}
{{- end }}

{{/*
Valkey/Redis password secret name
*/}}
{{- define "kurrier.redis.secretName" -}}
{{- if .Values.externalRedis.enabled }}
{{- if .Values.externalRedis.existingSecret }}
{{- .Values.externalRedis.existingSecret }}
{{- else }}
{{- printf "%s-external-redis" (include "kurrier.fullname" .) }}
{{- end }}
{{- else }}
{{- if .Values.valkey.existingSecret }}
{{- .Values.valkey.existingSecret }}
{{- else }}
{{- printf "%s-valkey" (include "kurrier.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Valkey/Redis password secret key
*/}}
{{- define "kurrier.redis.secretKey" -}}
{{- if .Values.externalRedis.enabled }}
{{- default "redis-password" .Values.externalRedis.secretKey }}
{{- else }}
{{- default "valkey-password" .Values.valkey.secretKey }}
{{- end }}
{{- end }}

{{/*
Valkey secret name helper
*/}}
{{- define "kurrier.valkey.secretName" -}}
{{- if .Values.valkey.existingSecret }}
{{- .Values.valkey.existingSecret }}
{{- else }}
{{- printf "%s-valkey" (include "kurrier.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Typesense host
*/}}
{{- define "kurrier.typesense.host" -}}
{{- printf "%s-typesense" (include "kurrier.fullname" .) }}
{{- end }}

{{/*
Typesense API key secret name
*/}}
{{- define "kurrier.typesense.secretName" -}}
{{- if .Values.typesense.existingSecret }}
{{- .Values.typesense.existingSecret }}
{{- else }}
{{- printf "%s-typesense" (include "kurrier.fullname" .) }}
{{- end }}
{{- end }}

{{/*
JWT secret name
*/}}
{{- define "kurrier.jwt.secretName" -}}
{{- if .Values.kurrier.jwt.existingSecret }}
{{- .Values.kurrier.jwt.existingSecret }}
{{- else }}
{{- printf "%s-jwt" (include "kurrier.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Vault secret name
*/}}
{{- define "kurrier.vault.secretName" -}}
{{- if .Values.kurrier.vault.existingSecret }}
{{- .Values.kurrier.vault.existingSecret }}
{{- else }}
{{- printf "%s-vault" (include "kurrier.fullname" .) }}
{{- end }}
{{- end }}

{{/*
RLS secret name
*/}}
{{- define "kurrier.rls.secretName" -}}
{{- if .Values.kurrier.rls.existingSecret }}
{{- .Values.kurrier.rls.existingSecret }}
{{- else }}
{{- printf "%s-rls" (include "kurrier.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Kong service name
*/}}
{{- define "kurrier.kong.serviceName" -}}
{{- printf "%s-kong" (include "kurrier.fullname" .) }}
{{- end }}

{{/*
Auth service name
*/}}
{{- define "kurrier.auth.serviceName" -}}
{{- printf "%s-auth" (include "kurrier.fullname" .) }}
{{- end }}

{{/*
REST service name
*/}}
{{- define "kurrier.rest.serviceName" -}}
{{- printf "%s-rest" (include "kurrier.fullname" .) }}
{{- end }}

{{/*
Realtime service name
*/}}
{{- define "kurrier.realtime.serviceName" -}}
{{- printf "%s-realtime" (include "kurrier.fullname" .) }}
{{- end }}

{{/*
Storage service name
*/}}
{{- define "kurrier.storage.serviceName" -}}
{{- printf "%s-storage" (include "kurrier.fullname" .) }}
{{- end }}

{{/*
Meta service name
*/}}
{{- define "kurrier.meta.serviceName" -}}
{{- printf "%s-meta" (include "kurrier.fullname" .) }}
{{- end }}

{{/*
Studio service name
*/}}
{{- define "kurrier.studio.serviceName" -}}
{{- printf "%s-studio" (include "kurrier.fullname" .) }}
{{- end }}

{{/*
Web service name
*/}}
{{- define "kurrier.web.serviceName" -}}
{{- printf "%s-web" (include "kurrier.fullname" .) }}
{{- end }}

{{/*
Worker service name
*/}}
{{- define "kurrier.worker.serviceName" -}}
{{- printf "%s-worker" (include "kurrier.fullname" .) }}
{{- end }}

{{/*
Baikal service name
*/}}
{{- define "kurrier.baikal.serviceName" -}}
{{- printf "%s-baikal" (include "kurrier.fullname" .) }}
{{- end }}

{{/*
Kong external host - extracts hostname from webUrl or first ingress host
*/}}
{{- define "kurrier.kongExternalHost" -}}
{{- if .Values.ingress.enabled }}
  {{- if .Values.ingress.hosts }}
    {{- (index .Values.ingress.hosts 0).host }}
  {{- else }}
    {{- .Values.kurrier.webUrl | trimPrefix "https://" | trimPrefix "http://" | regexFind "^[^:/]+" }}
  {{- end }}
{{- else }}
  {{- .Values.kurrier.webUrl | trimPrefix "https://" | trimPrefix "http://" | regexFind "^[^:/]+" }}
{{- end }}
{{- end }}

{{/*
Image pull secrets helper
*/}}
{{- define "kurrier.imagePullSecrets" -}}
{{- $pullSecrets := list }}
{{- if .Values.global.imagePullSecrets }}
  {{- range .Values.global.imagePullSecrets }}
    {{- $pullSecrets = append $pullSecrets . }}
  {{- end }}
{{- end }}
{{- if .componentPullSecrets }}
  {{- range .componentPullSecrets }}
    {{- $pullSecrets = append $pullSecrets . }}
  {{- end }}
{{- end }}
{{- if $pullSecrets }}
imagePullSecrets:
  {{- range $pullSecrets }}
  - name: {{ . }}
  {{- end }}
{{- end }}
{{- end }}
