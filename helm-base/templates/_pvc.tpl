{{- define "helm-base.pvc" -}}
{{- $root := . -}}
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ .Values.pvc.name | default .Values.name }}
  namespace: {{ .Values.namespace | default "default" }}
  {{- if or (hasKey .Values.pvc "labels") (hasKey .Values "globalLabels") }}
  labels:
    {{- if hasKey .Values.pvc "labels" }}
    {{- toYaml .Values.pvc.labels | nindent 4 }}
    {{- end }}
    {{- if hasKey .Values "globalLabels" }}
    {{- toYaml .Values.globalLabels | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- if hasKey .Values.pvc "annotations"}}
  {{- with .Values.pvc.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- end }}
spec:
  {{- if hasKey .Values.pvc "accessModes" }}
  {{- with .Values.pvc.accessModes }}
  accessModes:
  {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- end }}
  {{- if hasKey .Values.pvc "accessModes" }}
  volumeMode: {{ .Values.pvc.volumeMode }}
  {{- end }}
  resources:
  {{- if hasKey .Values.pvc "resourcesOverride" }}
    {{- with .Values.pvc.resourcesOverride }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- else }}
    requests:
      storage: {{ .Values.pvc.storageSize | default "10Gi" }}
  {{- end }}
  {{- if hasKey .Values.pvc "selector" }}
  selector: 
  {{- with .Values.pvc.selector }}
  {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- end }}
  {{- if hasKey .Values.pvc "dataSource" }}
  dataSource:
  {{- with .Values.pvc.dataSource }}
  {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- end }}
  {{- if hasKey .Values.pvc "storageClassName" }}
  storageClassName: {{ .Values.pvc.storageClassName | default "" }} 
  {{- end }}
{{- end }}

