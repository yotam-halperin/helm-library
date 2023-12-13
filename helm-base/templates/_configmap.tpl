{{- define "helm-base.configmap" -}}
{{- $root := . -}}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Values.configmap.name | default .Values.name }}
  namespace: {{ .Values.namespace | default "default" }}
  {{- if or (hasKey .Values.configmap "labels") (hasKey .Values "globalLabels") }}
  labels:
    {{- if hasKey .Values.configmap "labels" }}
    {{- toYaml .Values.configmap.labels | nindent 4 }}
    {{- end }}
    {{- if hasKey .Values "globalLabels" }}
    {{- toYaml .Values.globalLabels | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- if hasKey .Values.configmap "annotations"}}
  {{- with .Values.configmap.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- end }}
data:
  {{- with .Values.configmap.data }}
  {{- toYaml . | nindent 2 }}
  {{- end }}
{{- end }}