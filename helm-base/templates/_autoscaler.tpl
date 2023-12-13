{{- define "helm-base.autoscaler" -}}
{{- $root := . -}}
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ .Values.name }}
  namespace: {{ .Values.namespace | default "default" }}
  {{- if or (hasKey .Values.autoscaling "labels") (hasKey .Values "globalLabels") }}
  labels:
    {{- if hasKey .Values.autoscaling "labels" }}
    {{- toYaml .Values.autoscaling.labels | nindent 4 }}
    {{- end }}
    {{- if hasKey .Values "globalLabels" }}
    {{- toYaml .Values.globalLabels | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- if hasKey .Values.autoscaling "annotations"}}
  {{- with .Values.autoscaling.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- end }}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: {{ .Values.createApplication.kind }}
    name: {{ .Values.name }}
  minReplicas: {{ .Values.autoscaling.replication.minReplicas }}
  maxReplicas: {{ .Values.autoscaling.replication.maxReplicas }}
  metrics:
  {{- if and (hasKey .Values.autoscaling "targetCPUUtilizationPercentage") .Values.autoscaling.targetCPUUtilizationPercentage }}
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: {{ .Values.autoscaling.targetCPUUtilizationPercentage }}
  {{- end }}
  {{- if and (hasKey .Values.autoscaling "targetMemoryUtilizationPercentage") .Values.autoscaling.targetMemoryUtilizationPercentage }}
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: {{ .Values.autoscaling.targetMemoryUtilizationPercentage }}
  {{- end }}
  {{- if hasKey .Values.autoscaling "metrics" }}
  {{- with .Values.autoscaling.metrics }}
  {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- end }}
{{- end }}
