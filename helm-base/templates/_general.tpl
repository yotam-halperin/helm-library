{{- define "helm-base.application" -}}
{{- $root := . -}}
{{- if and (hasKey .Values "namespace") (ne .Values.namespace "default") }}
{{- include "helm-base.namespace" . }}
---
{{- end -}}
{{- if and (hasKey .Values "createApplication") (.Values.createApplication.enabled) }}
{{- include "helm-base.kind" . }}
---
{{- end -}}
{{- if and (and (hasKey .Values "createApplication") (.Values.createApplication.enabled)) (and (hasKey .Values "autoscaling") (.Values.autoscaling.enabled)) }}
{{- include "helm-base.autoscaler" . }}
---
{{- end -}}
{{- if and (hasKey .Values "service") (.Values.service.enabled) }}
{{- include "helm-base.service" . }}
---
{{- end -}}
{{- if and (hasKey .Values "ingress") (.Values.ingress.enabled) }}
{{- include "helm-base.ingress" . }}
---
{{- end -}}
{{- if and (hasKey .Values "serviceAccount") (.Values.serviceAccount.enabled) }}
{{- include "helm-base.serviceAccount" . }}
---
{{- end -}}
{{- if and (hasKey .Values "pvc") (.Values.pvc.enabled) }}
{{- include "helm-base.pvc" . }}
---
{{- end -}}
{{- if and (hasKey .Values "configmap") (.Values.configmap.enabled) }}
{{- include "helm-base.configmap" . }}
---
{{- end -}}
{{- if and (hasKey .Values "secret") (.Values.secret.enabled) }}
{{- include "helm-base.secret" . }}
---
{{- end -}}
{{- end }}