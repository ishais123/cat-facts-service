{{/*
Expand the name of the chart.
*/}}
{{- define "moon.name" -}}
{{- default .Chart.Name .Values.time.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "moon.fullname" -}}
{{- if .Values.time.fullnameOverride }}
{{- .Values.time.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.time.nameOverride }}
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
{{- define "moon.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "moon.cat.labels" -}}
helm.sh/chart: {{ include "moon.chart" . }}
app: cat
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
{{- end }}

{{- define "moon.time.labels" -}}
helm.sh/chart: {{ include "moon.chart" . }}
app: time
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
{{- end }}

{{/*
Selector labels cat
*/}}
{{- define "moon.cat.selectorLabels" -}}
app.kubernetes.io/name: {{ include "moon.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: cat
{{- end }}

{{/*
Selector labels time
*/}}
{{- define "moon.time.selectorLabels" -}}
app.kubernetes.io/name: {{ include "moon.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: time
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "moon.serviceAccountName" -}}
{{- if .Values.time.serviceAccount.create }}
{{- default (include "moon.fullname" .) .Values.time.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.time.serviceAccount.name }}
{{- end }}
{{- end }}
