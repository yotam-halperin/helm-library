{{- define "helm-base.namespace" -}}
{{- $root := . -}}
apiVersion: v1
kind: Namespace
metadata:
  name: {{ .Values.namespace | default .Values.name }}
{{- end }}