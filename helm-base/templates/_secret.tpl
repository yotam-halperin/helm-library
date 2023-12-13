{{- define "helm-base.secret" -}}
apiVersion: v1
kind: Secret
metadata:
  name: {{ .Values.secret.name | default .Values.name }}
  namespace: {{ .Values.namespace | default "default" }}
  {{- if or (hasKey .Values.secret "labels") (hasKey .Values "globalLabels") }}
  labels:
    {{- if hasKey .Values.secret "labels" }}
    {{- toYaml .Values.secret.labels | nindent 4 }}
    {{- end }}
    {{- if hasKey .Values "globalLabels" }}
    {{- toYaml .Values.globalLabels | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- if hasKey .Values.secret "annotations"}}
  {{- with .Values.secret.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- end }}
data:
  {{- with .Values.secret.data }}
  {{- toYaml . | nindent 2 }}
  {{- end }}
type: {{ .Values.secret.type | default "Opaque" }}
{{- end }}