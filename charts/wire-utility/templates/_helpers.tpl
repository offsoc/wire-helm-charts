{{- define "wire-utility.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "wire-utility.fullname" -}}
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
{{- define "wire-utility.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "wire-utility.labels" -}}
helm.sh/chart: {{ include "wire-utility.chart" . }}
{{ include "wire-utility.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "wire-utility.selectorLabels" -}}
app.kubernetes.io/name: {{ include "wire-utility.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Check if cargohold configuration is provided
*/}}
{{- define "wire-utility.hasCargohold" -}}
{{- if and .Values.cargohold .Values.cargohold.config .Values.cargohold.config.aws .Values.cargohold.config.aws.s3Endpoint -}}
{{- "true" -}}
{{- else -}}
{{- "false" -}}
{{- end -}}
{{- end }}

{{/*
Check if brig configuration is provided
*/}}
{{- define "wire-utility.hasBrig" -}}
{{- if and .Values.brig .Values.brig.config -}}
{{- "true" -}}
{{- else -}}
{{- "false" -}}
{{- end -}}
{{- end }}

{{/*
Check if cargohold secrets are provided
*/}}
{{- define "wire-utility.hasCargoholdSecrets" -}}
{{- if and .Values.cargohold .Values.cargohold.secrets -}}
{{- "true" -}}
{{- else -}}
{{- "false" -}}
{{- end -}}
{{- end }}

{{/*
Check if brig secrets are provided
*/}}
{{- define "wire-utility.hasBrigSecrets" -}}
{{- if and .Values.brig .Values.brig.secrets .Values.brig.secrets.rabbitmq .Values.brig.secrets.pgPassword -}}
{{- "true" -}}
{{- else -}}
{{- "false" -}}
{{- end -}}
{{- end }}


{{/*
Validate and get Minio service and secrets
*/}}
{{- define "wire-utility.minioServiceEndpoint" -}}
{{- if eq (include "wire-utility.hasCargohold" .) "true" -}}
{{- .Values.cargohold.config.aws.s3Endpoint | quote -}}
{{- else -}}
{{- fail "cargohold.config.aws.s3Endpoint is required. Make sure you provided the values/wire-server/values.yaml with -f flag." -}}
{{- end }}
{{- end }}


{{- define "wire-utility.minioAccessKey" -}}
{{- if eq (include "wire-utility.hasCargoholdSecrets" .) "true" -}}
{{- .Values.cargohold.secrets.awsKeyId }}
{{- else -}}
{{- fail "cargohold.secrets.awsKeyId is required. Make sure you provided the values/wire-server/secrets.yaml with -f flag." -}}
{{- end }}
{{- end }}

{{- define "wire-utility.minioSecretKey" -}}
{{if eq (include "wire-utility.hasCargoholdSecrets" .) "true" -}}
{{- .Values.cargohold.secrets.awsSecretKey }}
{{- else -}}
{{- fail "cargohold.secrets.awsSecretKey is required. Make sure you you provided the values/wire-server/secrets.yaml with -f flag." -}}
{{- end }}
{{- end }}


{{/*
Validate and get Cassandra service name
*/}}
{{- define "wire-utility.cassandraServiceName" -}}
{{- if eq (include "wire-utility.hasBrig" .) "true" -}}
{{- .Values.brig.config.cassandra.host | quote -}}
{{- else -}}
{{- fail "brig.config.cassandra.host is required. Make sure you provided the values/wire-server/values.yaml with -f flag." -}}
{{- end }}
{{- end }}


{{/*
Validate and get RabbitMQ service name and secrets
*/}}
{{- define "wire-utility.rabbitmqServiceName" -}}
{{- if eq (include "wire-utility.hasBrig" .) "true" -}}
{{- .Values.brig.config.rabbitmq.host | quote -}}
{{- else -}}
{{- fail "brig.config.rabbitmq.host is required. Make sure you provided the values/wire-server/values.yaml with -f flag." -}}
{{- end }}
{{- end }}

{{- define "wire-utility.rabbitmqUsername" -}}
{{- if eq (include "wire-utility.hasBrigSecrets" .) "true" -}}
{{- .Values.brig.secrets.rabbitmq.username -}}
{{- else -}}
{{- fail "brig.secrets.rabbitmq.username is required. Make sure you provided the values/wire-server/secrets.yaml with -f flag." -}}
{{- end }}
{{- end }}


{{- define "wire-utility.rabbitmqPassword" -}}
{{- if eq (include "wire-utility.hasBrigSecrets" .) "true" -}}
{{- .Values.brig.secrets.rabbitmq.password -}}
{{- else -}}
{{- fail "brig.secrets.rabbitmq.password is required. Make sure you provided the values/wire-server/secrets.yaml with -f flag." -}}
{{- end }}
{{- end }}

{{/*
Elasticsearch service name
*/}}
{{- define "wire-utility.elasticsearchServiceName" -}}
{{- if eq (include "wire-utility.hasBrig" .) "true" -}}
{{- .Values.brig.config.elasticsearch.host | quote -}}
{{- else -}}
{{- fail "brig.config.elasticsearch.host is required. Make sure you provided the values/wire-server/values.yaml with -f flag." -}}
{{- end }}
{{- end }}

{{/*
Validate and get postgresql secret and service
*/}}
{{- define "wire-utility.postgresqlSecret" -}}
{{- if eq (include "wire-utility.hasBrigSecrets" .) "true" -}}
{{- .Values.brig.secrets.pgPassword -}}
{{- else -}}
{{- fail "brig.secrets.pgPassword is required. Make sure you provided the values/wire-server/secrets.yaml with -f flag." -}}
{{- end }}
{{- end }}

{{- define "wire-utility.postgresqlServiceName" -}}
{{- if eq (include "wire-utility.hasBrig" .) "true" -}}
{{- .Values.brig.config.postgresql.host | quote -}}
{{- else -}}
{{- fail "brig.config.postgresql.host is required. Make sure you provided the values/wire-server/values.yaml with -f flag." -}}
{{- end }}
{{- end }}

{{- define "wire-utility.postgresqlPort" -}}
{{- if eq (include "wire-utility.hasBrig" .) "true" -}}
{{- .Values.brig.config.postgresql.port | quote -}}
{{- else -}}
{{- fail "brig.config.postgresql.port is required. Make sure you provided the values/wire-server/values.yaml with -f flag." -}}
{{- end }}
{{- end }}

{{-  define "wire-utility.postgresqlUser" -}}
{{- if eq (include "wire-utility.hasBrig" .) "true" -}}
{{- .Values.brig.config.postgresql.user -}}
{{- else -}}
{{- fail "brig.config.postgresql.user is required. Make sure you provided the values/wire-server/values.yaml with -f flag." -}}
{{- end }}
{{- end }}

{{- define "wire-utility.postgresqlDbname" -}}
{{- if eq (include "wire-utility.hasBrig" .) "true" -}}
{{- .Values.brig.config.postgresql.dbname -}}
{{- else -}}
{{- fail "brig.config.postgresql.dbname is required. Make sure you provided the values/wire-server/values.yaml with -f flag." -}}
{{- end }}
{{- end }}
