{{- define "helm-base.service" -}}
{{- $root := . -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.service.name | default .Values.name }}
  namespace: {{ .Values.namespace | default "default" }}
  {{- if or (hasKey .Values.service "labels") (hasKey .Values "globalLabels") }}
  labels:
    {{- if hasKey .Values.service "labels" }}
    {{- toYaml .Values.service.labels | nindent 4 }}
    {{- end }}
    {{- if hasKey .Values "globalLabels" }}
    {{- toYaml .Values.globalLabels | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- if hasKey .Values.service "annotations"}}
  {{- with .Values.service.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- end }}
spec:
  {{- if hasKey .Values.service "type" }}
  type: {{ .Values.service.type }}
  {{- end }}
  {{- if hasKey .Values.service "ports" }}
  ports:
  {{- with .Values.service.ports }}
  {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- end }}
  {{- if hasKey .Values.service "ports" }}
  selector:
  {{- with .Values.service.selector }}
  {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- end }}
{{- end }}