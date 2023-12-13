{{- define "helm-base.serviceAccount" -}}
{{- $root := . -}}
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ .Values.serviceAccount.name | default .Values.name }}
  namespace: {{ .Values.namespace | default "default" }}
  {{- if or (hasKey .Values.serviceAccount "labels") (hasKey .Values "globalLabels") }}
  labels:
    {{- if hasKey .Values.serviceAccount "labels" }}
    {{- toYaml .Values.serviceAccount.labels | nindent 4 }}
    {{- end }}
    {{- if hasKey .Values "globalLabels" }}
    {{- toYaml .Values.globalLabels | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- if hasKey .Values.serviceAccount "annotations"}}
  {{- with .Values.serviceAccount.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- end }}
{{- end }}
