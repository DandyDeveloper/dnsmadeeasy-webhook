{{/* Common labels shared across objects */}}
{{- define "dnsmadeeasy.labels" -}}
helm.sh/chart: {{ include "dnsmadeeasy.names.chart" . }}
{{ include "dnsmadeeasy.selectorLabels" . }}
  {{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
  {{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/* Selector labels shared across objects */}}
{{- define "dnsmadeeasy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "dnsmadeeasy.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/* Expand the name of the chart */}}
{{- define "dnsmadeeasy.name" -}}
  {{- $globalNameOverride := "" -}}
  {{- if hasKey .Values "global" -}}
    {{- $globalNameOverride = (default $globalNameOverride .Values.global.nameOverride) -}}
  {{- end -}}
  {{- default .Chart.Name (default .Values.nameOverride $globalNameOverride) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "dnsmadeeasy.fullname" -}}
  {{- $name := include "dnsmadeeasy.name" . -}}
  {{- $globalFullNameOverride := "" -}}
  {{- if hasKey .Values "global" -}}
    {{- $globalFullNameOverride = (default $globalFullNameOverride .Values.global.fullnameOverride) -}}
  {{- end -}}
  {{- if or .Values.fullnameOverride $globalFullNameOverride -}}
    {{- $name = default .Values.fullnameOverride $globalFullNameOverride -}}
  {{- else -}}
    {{- if contains $name .Release.Name -}}
      {{- $name = .Release.Name -}}
    {{- else -}}
      {{- $name = printf "%s-%s" .Release.Name $name -}}
    {{- end -}}
  {{- end -}}
  {{- trunc 63 $name | trimSuffix "-" -}}
{{- end -}}

{{/* Create chart name and version as used by the chart label */}}
{{- define "dnsmadeeasy.names.chart" -}}
  {{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Create the name of the ServiceAccount to use */}}
{{- define "dnsmadeeasy.names.serviceAccountName" -}}
  {{- if .Values.serviceAccount.create -}}
    {{- default (include "dnsmadeeasy.fullname" .) .Values.serviceAccount.name -}}
  {{- else -}}
    {{- default "default" .Values.serviceAccount.name -}}
  {{- end -}}
{{- end -}}

{{/* Return the properly cased version of the controller type */}}
{{- define "dnsmadeeasy.names.controllerType" -}}
  {{- if eq .Values.controller.type "deployment" -}}
    {{- print "Deployment" -}}
  {{- else if eq .Values.controller.type "daemonset" -}}
    {{- print "DaemonSet" -}}
  {{- else if eq .Values.controller.type "statefulset"  -}}
    {{- print "StatefulSet" -}}
  {{- else -}}
    {{- fail (printf "Not a valid controller.type (%s)" .Values.controller.type) -}}
  {{- end -}}
{{- end -}}

{{- define "dnsmadeeasy-webhook.selfSignedIssuer" -}}
{{ printf "%s-selfsign" (include "dnsmadeeasy.fullname" .) }}
{{- end -}}

{{- define "dnsmadeeasy-webhook.rootCAIssuer" -}}
{{ printf "%s-ca" (include "dnsmadeeasy.fullname" .) }}
{{- end -}}

{{- define "dnsmadeeasy-webhook.rootCACertificate" -}}
{{ printf "%s-ca" (include "dnsmadeeasy.fullname" .) }}
{{- end -}}

{{- define "dnsmadeeasy-webhook.servingCertificate" -}}
{{- if .Values.generateCerts }}
{{- printf "%s-webhook-tls" (include "dnsmadeeasy.fullname" .) }}
{{- else -}}
{{- printf "%s-cert-manager-webhook-ca" (include "dnsmadeeasy.fullname" .) }}
{{- end -}}
{{- end -}}
