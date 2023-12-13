{{- define "helm-base.ingress" -}}
{{- $root := . -}}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ .Values.ingress.name | default .Values.name }}
  namespace: {{ .Values.namespace | default "default" }}
  {{- if or (hasKey .Values.ingress "labels") (hasKey .Values "globalLabels") }}
  labels:
    {{- if hasKey .Values.ingress "labels" }}
    {{- toYaml .Values.ingress.labels | nindent 4 }}
    {{- end }}
    {{- if hasKey .Values "globalLabels" }}
    {{- toYaml .Values.globalLabels | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- if hasKey .Values.ingress "annotations"}}
  {{- with .Values.ingress.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- end }}
spec:
  {{- if hasKey .Values.ingress "ingressClassName" }}
  ingressClassName: {{ .Values.ingress.ingressClassName }}
  {{- end }}
  {{- if and (hasKey .Values.ingress "tls") .Values.ingress.tls.enabled }}
  tls:
  - hosts:
    {{- if hasKey .Values.ingress.tls "hosts" }}
    {{- with .Values.ingress.tls.hosts }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
    {{- end }}
    {{- if hasKey .Values.ingress.tls "secretName" }}
    secretName: {{ .Values.ingress.tls.secretName }}
    {{- end }}
  {{- end }}
  {{- if or (hasKey .Values.ingress "rules") (and (hasKey .Values.ingress "serviceRule") .Values.ingress.serviceRule.enabled )}}
  rules:
  {{- if hasKey .Values.ingress "rules" }}
  {{- with .Values.ingress.rules }}
  {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- end }}
  {{- if and (hasKey .Values.ingress "serviceRule") .Values.ingress.serviceRule.enabled }}
  {{- include "helm-base.ingressServiceRule" $root | indent 2 }}
  {{- end }}
  {{- end }}
{{- end }}