{{/*
Expand the name of the chart.
*/}}
{{- define "kurrier.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
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

{{- define "kurrier.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "kurrier.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kurrier.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "kurrier.labels" -}}
helm.sh/chart: {{ include "kurrier.chart" . }}
{{ include "kurrier.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "kurrier.componentLabels" -}}
{{ include "kurrier.labels" .root }}
app.kubernetes.io/component: {{ .component }}
{{- end }}

{{- define "kurrier.componentSelectorLabels" -}}
{{ include "kurrier.selectorLabels" .root }}
app.kubernetes.io/component: {{ .component }}
{{- end }}

{{- define "kurrier.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "kurrier.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "kurrier.image" -}}
{{- $registry := .root.Values.global.imageRegistry -}}
{{- $repository := .image.repository -}}
{{- if $registry -}}
{{- printf "%s/%s:%s" $registry $repository .image.tag -}}
{{- else -}}
{{- printf "%s:%s" $repository .image.tag -}}
{{- end -}}
{{- end }}

{{- define "kurrier.imagePullSecrets" -}}
{{- $pullSecrets := .Values.global.imagePullSecrets -}}
{{- if $pullSecrets }}
imagePullSecrets:
{{- range $pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end }}
{{- end }}

{{- define "kurrier.storageClass" -}}
{{- $class := .storageClass | default .root.Values.global.storageClass -}}
{{- if $class }}
storageClassName: {{ $class | quote }}
{{- end }}
{{- end }}

{{- define "kurrier.secretName" -}}
{{- default (printf "%s-secrets" (include "kurrier.fullname" .)) .Values.secrets.existingSecret }}
{{- end }}

{{- define "kurrier.configName" -}}
{{- printf "%s-config" (include "kurrier.fullname" .) }}
{{- end }}

{{- define "kurrier.postgres.serviceName" -}}
{{- printf "%s-postgres" (include "kurrier.fullname" .) }}
{{- end }}

{{- define "kurrier.baikalPostgres.serviceName" -}}
{{- printf "%s-baikal-postgres" (include "kurrier.fullname" .) }}
{{- end }}

{{- define "kurrier.redis.serviceName" -}}
{{- printf "%s-redis" (include "kurrier.fullname" .) }}
{{- end }}

{{- define "kurrier.typesense.serviceName" -}}
{{- printf "%s-typesense" (include "kurrier.fullname" .) }}
{{- end }}

{{- define "kurrier.dav.serviceName" -}}
{{- printf "%s-dav" (include "kurrier.fullname" .) }}
{{- end }}

{{- define "kurrier.garage.serviceName" -}}
{{- printf "%s-garage" (include "kurrier.fullname" .) }}
{{- end }}

{{- define "kurrier.web.serviceName" -}}
{{- printf "%s-web" (include "kurrier.fullname" .) }}
{{- end }}

{{- define "kurrier.worker.serviceName" -}}
{{- printf "%s-worker" (include "kurrier.fullname" .) }}
{{- end }}

{{- define "kurrier.databaseUrl" -}}
postgresql://{{ .Values.postgres.user }}:$(POSTGRES_PASSWORD)@{{ include "kurrier.postgres.serviceName" . }}:{{ .Values.postgres.service.port }}/{{ .Values.postgres.database }}
{{- end }}

{{- define "kurrier.databaseRlsUrl" -}}
postgresql://kurrier:$(POSTGRES_PASSWORD)@{{ include "kurrier.postgres.serviceName" . }}:{{ .Values.postgres.service.port }}/{{ .Values.postgres.database }}
{{- end }}

{{- define "kurrier.baikalDatabaseUrl" -}}
postgresql://{{ .Values.baikalPostgres.user }}:$(BAIKAL_POSTGRES_PASSWORD)@{{ include "kurrier.baikalPostgres.serviceName" . }}:{{ .Values.baikalPostgres.service.port }}/{{ .Values.baikalPostgres.database }}
{{- end }}
