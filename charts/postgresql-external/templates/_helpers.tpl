{{- define "postgresql-external.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "postgresql-external.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Validate that required IPs are provided
*/}}
{{- define "postgresql-external.validateIPs" -}}
{{- if not .Values.RWIPs -}}
{{- fail "RWIPs must be specified in values.yaml" -}}
{{- end -}}
{{- if not .Values.ROIPs -}}
{{- fail "ROIPs must be specified in values.yaml" -}}
{{- end -}}
{{- end -}}

{{/*
Get all PostgreSQL nodes combined
*/}}
{{- define "postgresql-external.allNodes" -}}
{{- include "postgresql-external.validateIPs" . -}}
{{- join "," (concat .Values.RWIPs .Values.ROIPs) -}}
{{- end -}}