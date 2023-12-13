{{- define "helm-base.statefulset" -}}
{{- $root := . -}}
apiVersion: apps/v1
kind: StatefulSet
metadata:
  {{- if hasKey .Values "name" }}
  name: {{ .Values.name }}
  {{- end }}
  namespace: {{ .Values.namespace | default "default" }}
  {{- if hasKey .Values "globalLabels" }}
  labels:
    {{- toYaml .Values.globalLabels | nindent 4 }}
  {{- end }}
  {{- if hasKey .Values "annotations" }}
  annotations:
    {{- toYaml .Values.annotations | nindent 4 }}
  {{- end }}
spec:
  {{- if or (not (hasKey .Values "autoscaling")) (not .Values.autoscaling.enabled) }}
  replicas: {{ .Values.replicaCount }}
  {{- end }}
  selector:
    matchLabels:
      {{- toYaml .Values.labels | nindent 6 }}
  template:
    metadata:
      {{- if hasKey .Values "name" }}
      name: {{ .Values.name }}
      {{- end }}
      namespace: {{ .Values.namespace | default "default" }}
      {{- if or (hasKey .Values "labels") (hasKey .Values "globalLabels") }}
      labels:
        {{- if hasKey .Values "labels" }}
        {{- toYaml .Values.labels | nindent 8 }}
        {{- end }}
        {{- if hasKey .Values "globalLabels" }}
        {{- toYaml .Values.globalLabels | nindent 8 }}
        {{- end }}
      {{- end }}
      {{- if hasKey .Values "annotations" }}
      annotations:
        {{- toYaml .Values.annotations | nindent 4 }}
      {{- end }}
    spec:
      {{- if hasKey .Values "imagePullSecrets" }}
      imagePullSecrets:
      {{- range .Values.imagePullSecrets }}
      - name: {{ . }}
      {{- end }}
      {{- end }}
      {{- if or (and (and (hasKey .Values "serviceAccount") .Values.serviceAccount.enabled) .Values.serviceAccount.assignToDeployment)  (hasKey .Values "serviceAccountNameOverride") }}
      serviceAccountName: {{ if hasKey .Values "serviceAccountNameOverride" }}{{ .Values.serviceAccountNameOverride }}{{ else}}{{ .Values.serviceAccount.name }}{{ end }}
      {{- end }}
      {{- if and (hasKey .Values "globalSecurityContext") (.Values.globalSecurityContext.enabled)}}
      securityContext:
          {{- include "helm-base.securityContext" .Values.globalSecurityContext -}}
      {{- end }}
      containers:
      {{- range .Values.containers }}
      - name: {{ .name | default $root.Values.name }}
        image: {{ .image }}:{{ .tag | default "latest" }}
        imagePullPolicy: {{ .pullPolicy | default "IfNotPresent"}}
        {{- if or (hasKey . "ports") (and (hasKey . "servicePort") .servicePort.enabled ) }}
        ports:
          {{- if hasKey . "ports" }}
          {{- include "helm-base.containerExtraPorts" .ports | indent 8 -}}
          {{- end }}
          {{- if and (hasKey . "servicePort") .servicePort.enabled }}
          {{- include "helm-base.containerServicePort" $root | indent 8 -}}
          {{- end }}
        {{- end }}
        {{- if or (and (hasKey $root.Values "resources") $root.Values.resources.enabled) (and (hasKey $root.Values "autoscaling") $root.Values.autoscaling.enabled ) }}
        resources: 
          {{- include "helm-base.resources" $root | indent 10 -}}
        {{- end }}
        {{- if hasKey . "command" }}
        command: 
        {{- range .command }}
        - {{ . | quote }}
        {{- end }}
        {{- end }}
        {{- if hasKey . "args" }}
        args: 
        {{- range .args }}
        - {{ . | quote }}
        {{- end }}
        {{- end }}
        {{- if hasKey . "env" }}
        env:
        {{- range $key,$value := .env }}
        - name: {{ $key }}
          value: {{ $value }}
        {{- end }}
        {{- end }}
        {{- if hasKey . "envFrom" }}
        envFrom:
        {{- if hasKey .envFrom "secrets" }}
        {{- range .envFrom.secrets }}
        - secretRef:
            name: '{{ . }}'
        {{- end }}
        {{- end }}
        {{- if hasKey .envFrom "configmaps" }}
        {{- range .envFrom.configmaps }}
        - configMapRef:
            name: '{{ . }}'
        {{- end }}
        {{- end }}
        {{- end }}
        {{- if hasKey . "securityContext" }}
        securityContext:
          {{- include "helm-base.securityContext" .securityContext | indent 6 -}}
        {{- end }}
        {{- if hasKey . "livenessProbe" }}
        {{- with .livenessProbe }}
        livenessProbe:
          {{- toYaml . | nindent 10 }}
        {{- end }}
        {{- end }}
        {{- if hasKey . "readinessProbe" }}
        {{- with .readinessProbe }}
        readinessProbe:
          {{- toYaml . | nindent 10 }}
        {{- end }}
        {{- end }}
        {{- if hasKey . "volumeMounts" }}
        volumeMounts:
        {{- range $name,$path := .volumeMounts }}
        - name: {{ $name }}
          mountPath: {{ $path }}
        {{- end }}
        {{- end }}
      {{- end }}
      {{- if (hasKey .Values "volumes") }}
      volumes:
        {{- include "helm-base.volumes" $root | indent 6 }}
      {{- end }}
      {{- if (hasKey .Values "initContainers") }}
      initContainers:
      {{- range .Values.initContainers }}
      - name: {{ .name | default $root.Values.name }}
        image: {{ .image }}:{{ .tag | default "latest" }}
        imagePullPolicy: {{ .pullPolicy | default "IfNotPresent"}}
        {{- if or (hasKey . "ports") (and (hasKey . "servicePort") .servicePort.enabled ) }}
        ports:
          {{- if hasKey . "ports" }}
          {{- include "helm-base.containerExtraPorts" .ports | indent 8 -}}
          {{- end }}
          {{- if and (hasKey . "servicePort") .servicePort.enabled }}
          {{- include "helm-base.containerServicePort" $root | indent 8 -}}
          {{- end }}
        {{- end }}
        {{- if or (and (hasKey $root.Values "resources") $root.Values.resources.enabled) (and (hasKey $root.Values "autoscaling") $root.Values.autoscaling.enabled ) }}
        resources: 
          {{- include "helm-base.resources" $root | indent 10 -}}
        {{- end }}
        {{- if hasKey . "command" }}
        command: 
        {{- range .command }}
        - {{ . | quote }}
        {{- end }}
        {{- end }}
        {{- if hasKey . "args" }}
        args: 
        {{- range .args }}
        - {{ . | quote }}
        {{- end }}
        {{- end }}
        {{- if hasKey . "env" }}
        env:
        {{- range $key,$value := .env }}
        - name: {{ $key }}
          value: {{ $value }}
        {{- end }}
        {{- end }}
        {{- if hasKey . "envFrom" }}
        envFrom:
        {{- if hasKey .envFrom "secrets" }}
        {{- range .envFrom.secrets }}
        - secretRef:
            name: '{{ . }}'
        {{- end }}
        {{- end }}
        {{- if hasKey .envFrom "configmaps" }}
        {{- range .envFrom.configmaps }}
        - configMapRef:
            name: '{{ . }}'
        {{- end }}
        {{- end }}
        {{- end }}
        {{- if hasKey . "securityContext" }}
        securityContext:
          {{- include "helm-base.securityContext" .securityContext | indent 6 -}}
        {{- end }}
        {{- if hasKey . "livenessProbe" }}
        {{- with .livenessProbe }}
        livenessProbe:
          {{- toYaml . | nindent 10 }}
        {{- end }}
        {{- end }}
        {{- if hasKey . "readinessProbe" }}
        {{- with .readinessProbe }}
        readinessProbe:
          {{- toYaml . | nindent 10 }}
        {{- end }}
        {{- end }}
        {{- if hasKey . "volumeMounts" }}
        volumeMounts:
        {{- range $name,$path := .volumeMounts }}
        - name: {{ $name }}
          mountPath: {{ $path }}
        {{- end }}
        {{- end }}
      {{- end }}
      {{- end }}
      {{- if hasKey .Values "nodeName" }}
      nodeName: {{ .Values.nodeName }}
      {{- end }}
      {{- if hasKey .Values "nodeSelector" }}
      nodeSelector: 
      {{ toYaml .Values.nodeSelector | indent 2 }}
      {{- end }}
      {{- if hasKey .Values "affinity" }}
      {{- with .Values.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- end }}
      {{- if hasKey .Values "tolerations"}}
      {{- with .Values.tolerations }}
      tolerations:
      {{- toYaml . | nindent 6 }}
      {{- end }}
      {{- end }}
{{- end }}
