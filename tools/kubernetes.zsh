#!/usr/bin/env zsh

# kubernetes.zsh
# Author: Thomas Vincent
# GitHub: https://github.com/thomasvincent/dotfiles
#
# This file contains Kubernetes-specific configuration.

# Kubernetes aliases
alias k="kubectl"
alias kgp="kubectl get pods"
alias kgs="kubectl get services"
alias kgd="kubectl get deployments"
alias kgn="kubectl get nodes"
alias kgc="kubectl get configmaps"
alias kgsec="kubectl get secrets"
alias kgpvc="kubectl get pvc"
alias kgpv="kubectl get pv"
alias kgns="kubectl get namespaces"
alias kd="kubectl describe"
alias kdp="kubectl describe pod"
alias kds="kubectl describe service"
alias kdd="kubectl describe deployment"
alias kdn="kubectl describe node"
alias kdc="kubectl describe configmap"
alias kdsec="kubectl describe secret"
alias kdpvc="kubectl describe pvc"
alias kdpv="kubectl describe pv"
alias kdns="kubectl describe namespace"
alias kl="kubectl logs"
alias klf="kubectl logs -f"
alias kex="kubectl exec -it"
alias kcp="kubectl cp"
alias kroll="kubectl rollout restart deployment"
alias krollh="kubectl rollout history deployment"
alias krolls="kubectl rollout status deployment"
alias krollu="kubectl rollout undo deployment"
alias kctx="kubectx"
alias kns="kubens"

# If k9s is installed
if command -v k9s &> /dev/null; then
  alias k9="k9s"
fi

# Kubernetes functions

# Get all resources in all namespaces
kga() {
  kubectl get all --all-namespaces
}

# Get all resources in a specific namespace
kgan() {
  kubectl get all -n "$1"
}

# Get all pods in all namespaces
kgpa() {
  kubectl get pods --all-namespaces
}

# Get all services in all namespaces
kgsa() {
  kubectl get services --all-namespaces
}

# Get all deployments in all namespaces
kgda() {
  kubectl get deployments --all-namespaces
}

# Get all nodes in all namespaces
kgna() {
  kubectl get nodes --all-namespaces
}

# Get all configmaps in all namespaces
kgca() {
  kubectl get configmaps --all-namespaces
}

# Get all secrets in all namespaces
kgseca() {
  kubectl get secrets --all-namespaces
}

# Get all persistent volume claims in all namespaces
kgpvca() {
  kubectl get pvc --all-namespaces
}

# Get all persistent volumes in all namespaces
kgpva() {
  kubectl get pv --all-namespaces
}

# Get all namespaces
kgnsa() {
  kubectl get namespaces
}

# Get all pods in a specific namespace
kgpn() {
  kubectl get pods -n "$1"
}

# Get all services in a specific namespace
kgsn() {
  kubectl get services -n "$1"
}

# Get all deployments in a specific namespace
kgdn() {
  kubectl get deployments -n "$1"
}

# Get all configmaps in a specific namespace
kgcn() {
  kubectl get configmaps -n "$1"
}

# Get all secrets in a specific namespace
kgsecn() {
  kubectl get secrets -n "$1"
}

# Get all persistent volume claims in a specific namespace
kgpvcn() {
  kubectl get pvc -n "$1"
}

# Describe a pod in a specific namespace
kdpn() {
  kubectl describe pod "$1" -n "$2"
}

# Describe a service in a specific namespace
kdsn() {
  kubectl describe service "$1" -n "$2"
}

# Describe a deployment in a specific namespace
kddn() {
  kubectl describe deployment "$1" -n "$2"
}

# Describe a configmap in a specific namespace
kdcn() {
  kubectl describe configmap "$1" -n "$2"
}

# Describe a secret in a specific namespace
kdsecn() {
  kubectl describe secret "$1" -n "$2"
}

# Describe a persistent volume claim in a specific namespace
kdpvcn() {
  kubectl describe pvc "$1" -n "$2"
}

# Get logs for a pod in a specific namespace
kln() {
  kubectl logs "$1" -n "$2"
}

# Get logs for a pod in a specific namespace and follow
klfn() {
  kubectl logs -f "$1" -n "$2"
}

# Execute a command in a pod in a specific namespace
kexn() {
  kubectl exec -it "$1" -n "$2" -- "${@:3}"
}

# Copy files to/from a pod in a specific namespace
kcpn() {
  kubectl cp "$1" -n "$2"
}

# Rollout restart a deployment in a specific namespace
krolln() {
  kubectl rollout restart deployment "$1" -n "$2"
}

# Rollout history for a deployment in a specific namespace
krollhn() {
  kubectl rollout history deployment "$1" -n "$2"
}

# Rollout status for a deployment in a specific namespace
krollsn() {
  kubectl rollout status deployment "$1" -n "$2"
}

# Rollout undo for a deployment in a specific namespace
krollun() {
  kubectl rollout undo deployment "$1" -n "$2"
}

# Get all pods in all namespaces with wide output
kgpaw() {
  kubectl get pods --all-namespaces -o wide
}

# Get all services in all namespaces with wide output
kgsaw() {
  kubectl get services --all-namespaces -o wide
}

# Get all deployments in all namespaces with wide output
kgdaw() {
  kubectl get deployments --all-namespaces -o wide
}

# Get all nodes in all namespaces with wide output
kgnaw() {
  kubectl get nodes --all-namespaces -o wide
}

# Get all pods in a specific namespace with wide output
kgpnw() {
  kubectl get pods -n "$1" -o wide
}

# Get all services in a specific namespace with wide output
kgsnw() {
  kubectl get services -n "$1" -o wide
}

# Get all deployments in a specific namespace with wide output
kgdnw() {
  kubectl get deployments -n "$1" -o wide
}

# Get all pods in all namespaces with custom columns
kgpac() {
  kubectl get pods --all-namespaces -o custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName
}

# Get all services in all namespaces with custom columns
kgsac() {
  kubectl get services --all-namespaces -o custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name,TYPE:.spec.type,CLUSTER-IP:.spec.clusterIP,EXTERNAL-IP:.spec.externalIP,PORT:.spec.ports[*].port
}

# Get all deployments in all namespaces with custom columns
kgdac() {
  kubectl get deployments --all-namespaces -o custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name,REPLICAS:.spec.replicas,AVAILABLE:.status.availableReplicas,STRATEGY:.spec.strategy.type
}

# Get all nodes in all namespaces with custom columns
kgnac() {
  kubectl get nodes --all-namespaces -o custom-columns=NAME:.metadata.name,STATUS:.status.conditions[?(@.type==\"Ready\")].status,ROLES:.metadata.labels.\"kubernetes\\.io/role\",VERSION:.status.nodeInfo.kubeletVersion
}

# Get all pods in a specific namespace with custom columns
kgpnc() {
  kubectl get pods -n "$1" -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName
}

# Get all services in a specific namespace with custom columns
kgsnc() {
  kubectl get services -n "$1" -o custom-columns=NAME:.metadata.name,TYPE:.spec.type,CLUSTER-IP:.spec.clusterIP,EXTERNAL-IP:.spec.externalIP,PORT:.spec.ports[*].port
}

# Get all deployments in a specific namespace with custom columns
kgdnc() {
  kubectl get deployments -n "$1" -o custom-columns=NAME:.metadata.name,REPLICAS:.spec.replicas,AVAILABLE:.status.availableReplicas,STRATEGY:.spec.strategy.type
}

# Get all pods in all namespaces with JSON output
kgpaj() {
  kubectl get pods --all-namespaces -o json
}

# Get all services in all namespaces with JSON output
kgsaj() {
  kubectl get services --all-namespaces -o json
}

# Get all deployments in all namespaces with JSON output
kgdaj() {
  kubectl get deployments --all-namespaces -o json
}

# Get all nodes in all namespaces with JSON output
kgnaj() {
  kubectl get nodes --all-namespaces -o json
}

# Get all pods in a specific namespace with JSON output
kgpnj() {
  kubectl get pods -n "$1" -o json
}

# Get all services in a specific namespace with JSON output
kgsnj() {
  kubectl get services -n "$1" -o json
}

# Get all deployments in a specific namespace with JSON output
kgdnj() {
  kubectl get deployments -n "$1" -o json
}

# Get all pods in all namespaces with YAML output
kgpay() {
  kubectl get pods --all-namespaces -o yaml
}

# Get all services in all namespaces with YAML output
kgsay() {
  kubectl get services --all-namespaces -o yaml
}

# Get all deployments in all namespaces with YAML output
kgday() {
  kubectl get deployments --all-namespaces -o yaml
}

# Get all nodes in all namespaces with YAML output
kgnay() {
  kubectl get nodes --all-namespaces -o yaml
}

# Get all pods in a specific namespace with YAML output
kgpny() {
  kubectl get pods -n "$1" -o yaml
}

# Get all services in a specific namespace with YAML output
kgsny() {
  kubectl get services -n "$1" -o yaml
}

# Get all deployments in a specific namespace with YAML output
kgdny() {
  kubectl get deployments -n "$1" -o yaml
}

# Get a specific pod in a specific namespace with YAML output
kgpny() {
  kubectl get pod "$1" -n "$2" -o yaml
}

# Get a specific service in a specific namespace with YAML output
kgsny() {
  kubectl get service "$1" -n "$2" -o yaml
}

# Get a specific deployment in a specific namespace with YAML output
kgdny() {
  kubectl get deployment "$1" -n "$2" -o yaml
}

# Get a specific configmap in a specific namespace with YAML output
kgcny() {
  kubectl get configmap "$1" -n "$2" -o yaml
}

# Get a specific secret in a specific namespace with YAML output
kgsecny() {
  kubectl get secret "$1" -n "$2" -o yaml
}

# Get a specific persistent volume claim in a specific namespace with YAML output
kgpvcny() {
  kubectl get pvc "$1" -n "$2" -o yaml
}

# Get a specific persistent volume with YAML output
kgpvy() {
  kubectl get pv "$1" -o yaml
}

# Get a specific namespace with YAML output
kgnsy() {
  kubectl get namespace "$1" -o yaml
}

# Get a specific pod in a specific namespace with JSON output
kgpnj() {
  kubectl get pod "$1" -n "$2" -o json
}

# Get a specific service in a specific namespace with JSON output
kgsnj() {
  kubectl get service "$1" -n "$2" -o json
}

# Get a specific deployment in a specific namespace with JSON output
kgdnj() {
  kubectl get deployment "$1" -n "$2" -o json
}

# Get a specific configmap in a specific namespace with JSON output
kgcnj() {
  kubectl get configmap "$1" -n "$2" -o json
}

# Get a specific secret in a specific namespace with JSON output
kgsecnj() {
  kubectl get secret "$1" -n "$2" -o json
}

# Get a specific persistent volume claim in a specific namespace with JSON output
kgpvcnj() {
  kubectl get pvc "$1" -n "$2" -o json
}

# Get a specific persistent volume with JSON output
kgpvj() {
  kubectl get pv "$1" -o json
}

# Get a specific namespace with JSON output
kgnsj() {
  kubectl get namespace "$1" -o json
}

# Delete a pod in a specific namespace
kdelpn() {
  kubectl delete pod "$1" -n "$2"
}

# Delete a service in a specific namespace
kdelsn() {
  kubectl delete service "$1" -n "$2"
}

# Delete a deployment in a specific namespace
kdeldn() {
  kubectl delete deployment "$1" -n "$2"
}

# Delete a configmap in a specific namespace
kdelcn() {
  kubectl delete configmap "$1" -n "$2"
}

# Delete a secret in a specific namespace
kdelsecn() {
  kubectl delete secret "$1" -n "$2"
}

# Delete a persistent volume claim in a specific namespace
kdelpvcn() {
  kubectl delete pvc "$1" -n "$2"
}

# Delete a persistent volume
kdelpv() {
  kubectl delete pv "$1"
}

# Delete a namespace
kdelns() {
  kubectl delete namespace "$1"
}

# Apply a YAML file
kapply() {
  kubectl apply -f "$1"
}

# Apply a YAML file in a specific namespace
kapplyn() {
  kubectl apply -f "$1" -n "$2"
}

# Delete a YAML file
kdelete() {
  kubectl delete -f "$1"
}

# Delete a YAML file in a specific namespace
kdeleten() {
  kubectl delete -f "$1" -n "$2"
}

# Create a namespace
kcreate-ns() {
  kubectl create namespace "$1"
}

# Create a configmap from a file
kcreate-cm-file() {
  kubectl create configmap "$1" --from-file="$2"
}

# Create a configmap from a file in a specific namespace
kcreate-cm-file-n() {
  kubectl create configmap "$1" --from-file="$2" -n "$3"
}

# Create a configmap from a literal
kcreate-cm-literal() {
  kubectl create configmap "$1" --from-literal="$2"
}

# Create a configmap from a literal in a specific namespace
kcreate-cm-literal-n() {
  kubectl create configmap "$1" --from-literal="$2" -n "$3"
}

# Create a secret from a file
kcreate-secret-file() {
  kubectl create secret generic "$1" --from-file="$2"
}

# Create a secret from a file in a specific namespace
kcreate-secret-file-n() {
  kubectl create secret generic "$1" --from-file="$2" -n "$3"
}

# Create a secret from a literal
kcreate-secret-literal() {
  kubectl create secret generic "$1" --from-literal="$2"
}

# Create a secret from a literal in a specific namespace
kcreate-secret-literal-n() {
  kubectl create secret generic "$1" --from-literal="$2" -n "$3"
}

# Create a deployment
kcreate-deployment() {
  kubectl create deployment "$1" --image="$2"
}

# Create a deployment in a specific namespace
kcreate-deployment-n() {
  kubectl create deployment "$1" --image="$2" -n "$3"
}

# Create a service
kcreate-service() {
  kubectl create service "$1" "$2" --tcp="$3"
}

# Create a service in a specific namespace
kcreate-service-n() {
  kubectl create service "$1" "$2" --tcp="$3" -n "$4"
}

# Create a job
kcreate-job() {
  kubectl create job "$1" --image="$2"
}

# Create a job in a specific namespace
kcreate-job-n() {
  kubectl create job "$1" --image="$2" -n "$3"
}

# Create a cronjob
kcreate-cronjob() {
  kubectl create cronjob "$1" --image="$2" --schedule="$3"
}

# Create a cronjob in a specific namespace
kcreate-cronjob-n() {
  kubectl create cronjob "$1" --image="$2" --schedule="$3" -n "$4"
}

# Scale a deployment
kscale() {
  kubectl scale deployment "$1" --replicas="$2"
}

# Scale a deployment in a specific namespace
kscale-n() {
  kubectl scale deployment "$1" --replicas="$2" -n "$3"
}

# Set the image for a deployment
kset-image() {
  kubectl set image deployment/"$1" "$1"="$2"
}

# Set the image for a deployment in a specific namespace
kset-image-n() {
  kubectl set image deployment/"$1" "$1"="$2" -n "$3"
}

# Set the resources for a deployment
kset-resources() {
  kubectl set resources deployment "$1" --limits="$2" --requests="$3"
}

# Set the resources for a deployment in a specific namespace
kset-resources-n() {
  kubectl set resources deployment "$1" --limits="$2" --requests="$3" -n "$4"
}

# Set the environment variables for a deployment
kset-env() {
  kubectl set env deployment/"$1" "$2"="$3"
}

# Set the environment variables for a deployment in a specific namespace
kset-env-n() {
  kubectl set env deployment/"$1" "$2"="$3" -n "$4"
}

# Get the events for a specific namespace
kevents() {
  kubectl get events -n "$1"
}

# Get the events for all namespaces
kevents-all() {
  kubectl get events --all-namespaces
}

# Get the events for a specific pod in a specific namespace
kevents-pod() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific service in a specific namespace
kevents-service() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific deployment in a specific namespace
kevents-deployment() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific node
kevents-node() {
  kubectl get events --field-selector="involvedObject.name=$1"
}

# Get the events for a specific namespace
kevents-namespace() {
  kubectl get events --field-selector="involvedObject.name=$1"
}

# Get the events for a specific persistent volume claim in a specific namespace
kevents-pvc() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific persistent volume
kevents-pv() {
  kubectl get events --field-selector="involvedObject.name=$1"
}

# Get the events for a specific configmap in a specific namespace
kevents-configmap() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific secret in a specific namespace
kevents-secret() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific job in a specific namespace
kevents-job() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific cronjob in a specific namespace
kevents-cronjob() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific replicaset in a specific namespace
kevents-replicaset() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific statefulset in a specific namespace
kevents-statefulset() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific daemonset in a specific namespace
kevents-daemonset() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific ingress in a specific namespace
kevents-ingress() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific service account in a specific namespace
kevents-serviceaccount() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific role in a specific namespace
kevents-role() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific role binding in a specific namespace
kevents-rolebinding() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific cluster role
kevents-clusterrole() {
  kubectl get events --field-selector="involvedObject.name=$1"
}

# Get the events for a specific cluster role binding
kevents-clusterrolebinding() {
  kubectl get events --field-selector="involvedObject.name=$1"
}

# Get the events for a specific network policy in a specific namespace
kevents-networkpolicy() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific pod security policy
kevents-podsecuritypolicy() {
  kubectl get events --field-selector="involvedObject.name=$1"
}

# Get the events for a specific storage class
kevents-storageclass() {
  kubectl get events --field-selector="involvedObject.name=$1"
}

# Get the events for a specific persistent volume
kevents-persistentvolume() {
  kubectl get events --field-selector="involvedObject.name=$1"
}

# Get the events for a specific persistent volume claim in a specific namespace
kevents-persistentvolumeclaim() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific namespace
kevents-namespace() {
  kubectl get events --field-selector="involvedObject.name=$1"
}

# Get the events for a specific node
kevents-node() {
  kubectl get events --field-selector="involvedObject.name=$1"
}

# Get the events for a specific pod in a specific namespace
kevents-pod() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific service in a specific namespace
kevents-service() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific deployment in a specific namespace
kevents-deployment() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific replicaset in a specific namespace
kevents-replicaset() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific statefulset in a specific namespace
kevents-statefulset() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific daemonset in a specific namespace
kevents-daemonset() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific job in a specific namespace
kevents-job() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific cronjob in a specific namespace
kevents-cronjob() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific configmap in a specific namespace
kevents-configmap() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific secret in a specific namespace
kevents-secret() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific service account in a specific namespace
kevents-serviceaccount() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific role in a specific namespace
kevents-role() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific role binding in a specific namespace
kevents-rolebinding() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific ingress in a specific namespace
kevents-ingress() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific network policy in a specific namespace
kevents-networkpolicy() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific persistent volume claim in a specific namespace
kevents-persistentvolumeclaim() {
  kubectl get events -n "$1" --field-selector="involvedObject.name=$2"
}

# Get the events for a specific cluster role
kevents-clusterrole() {
  kubectl get events --field-selector="involvedObject.name=$1"
}

# Get the events for a specific cluster role binding
kevents-clusterrolebinding() {
  kubectl get events --field-selector="involvedObject.name=$1"
}

# Get the events for a specific pod security policy
kevents-podsecuritypolicy() {
  kubectl get events --field-selector="involvedObject.name=$1"
}

# Get the events for a specific storage class
kevents-storageclass() {
  kubectl get events --field-selector="involvedObject.name=$1"
}

# Get the events for a specific persistent volume
kevents-persistentvolume() {
  kubectl get events --field-selector="involvedObject.name=$1"
}

# Get the events for a specific namespace
kevents-namespace() {
  kubectl get events --field-selector="involvedObject.name=$1"
}

# Get the events for a specific node
kevents-node() {
  kubectl get events --field-selector="involvedObject.name=$1"
}
