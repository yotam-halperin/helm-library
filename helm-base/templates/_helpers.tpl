{{- define "helm-base.resources" }}
{{- if hasKey .Values "resources" }}
{{- if hasKey .Values.resources "requests" }}
requests:
  cpu: {{ .Values.resources.requests.minCPU | default "500m" }}
  memory: {{ .Values.resources.requests.minMemory | default "1Gi" }}
{{- else }}
requests:
  cpu: "500m"
  memory: "1Gi"
{{- end }}
{{- if hasKey .Values.resources "limits" }}
limits:
  cpu: {{ .Values.resources.limits.maxCPU | default "2" }}
  memory: {{ .Values.resources.limits.maxMemory | default "4Gi" }}
{{- else }}
limits:
  cpu: "2"
  memory: "4Gi"
{{- end }}
{{- else if and (not (hasKey .Values "resources")) (and (hasKey .Values "autoscaling") .Values.autoscaling.enabled)}}
requests:
  cpu: "500m"
  memory: "1Gi"
limits:
  cpu: "2"
  memory: "4Gi"
{{- end }}
{{- end }}


{{- define "helm-base.securityContext" }}
{{- if hasKey . "runAsUser" }}
    runAsUser: {{ .runAsUser }}
{{- end }}
{{- if hasKey . "runAsGroup" }}
    runAsGroup: {{ .runAsGroup }}
{{- end }}
{{- if hasKey . "fsGroup" }}
    fsGroup: {{ .fsGroup }}
{{- end }}
{{- end }}


{{- define "helm-base.containerExtraPorts" }}
{{- range . }}
- containerPort: {{ .port }}
  {{- if hasKey . "name" }}
  name: {{ .name }}
  {{- end }}
  {{- if hasKey . "protocol" }}
  protocol: {{ .protocol }}
  {{- end }}
{{- end }}
{{- end }}

{{- define "helm-base.containerServicePort" }}
{{- range .Values.service.ports }}
{{- if kindIs "string" .targetPort }}
- containerPort: {{ .port }}
  name: {{ .targetPort }}
{{- else }}
- containerPort: {{ .targetPort }}
  {{- if hasKey . "name" }}
  name: {{ .name }}
  {{- end }}
{{- end }}
  {{- if hasKey . "protocol" }}
  protocol: {{ .protocol }}
  {{- end }}
{{- end }}
{{- end }}


{{- define "helm-base.volumes" }}
{{- with .Values.volumes.extraVolumes }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- if and (hasKey .Values.volumes "pvcVolume") .Values.volumes.pvcVolume.enabled }}
- name: {{ .Values.pvc.name | default .Values.name }}-pvcvolume
  persistentVolumeClaim:
    claimName: {{ .Values.pvc.name | default .Values.name }}
{{- end }}
{{- if and (hasKey .Values.volumes "cmVolume") .Values.volumes.cmVolume.enabled }}
- name: {{ .Values.configmap.name | default .Values.name }}-cmvolume
  configMap:
    name: {{ .Values.configmap.name | default .Values.name }}
    items:
    {{- range .Values.volumes.cmVolume.items }}
    - key: {{ . }}
      path: {{ . }}
    {{- end }}
{{- end }}
{{- end }}

{{- define "helm-base.ingressServiceRule" }}
{{- range .Values.ingress.serviceRule.routes }}
- host: {{ .host }}
  http:
    paths:
    - pathType: Prefix
      path: {{ .path }}
      backend:
        service:
          name: {{ $.Values.service.name | default $.Values.name }}
          port:
            number: {{ .servicePort }}
{{- end }}
{{- end }}