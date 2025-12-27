#!/usr/bin/env zsh
# ~/.zsh/dev/kubernetes.zsh - Kubernetes workflows and aliases
#
# Comprehensive Kubernetes tooling for container orchestration
#

# ====================================
# KUBECTL ALIASES
# ====================================
if command -v kubectl &>/dev/null; then
  alias k='kubectl'
  alias kx='kubectx'
  alias kn='kubens'
  
  # Get commands
  alias kg='kubectl get'
  alias kgp='kubectl get pods'
  alias kgpa='kubectl get pods --all-namespaces'
  alias kgpw='kubectl get pods -o wide'
  alias kgd='kubectl get deployments'
  alias kgs='kubectl get services'
  alias kgn='kubectl get nodes'
  alias kgns='kubectl get namespaces'
  alias kgcm='kubectl get configmaps'
  alias kgsec='kubectl get secrets'
  alias kging='kubectl get ingress'
  alias kgpv='kubectl get pv'
  alias kgpvc='kubectl get pvc'
  alias kgj='kubectl get jobs'
  alias kgcj='kubectl get cronjobs'
  alias kgsa='kubectl get serviceaccounts'
  alias kgr='kubectl get roles'
  alias kgrb='kubectl get rolebindings'
  alias kgcr='kubectl get clusterroles'
  alias kgcrb='kubectl get clusterrolebindings'
  alias kgall='kubectl get all'
  alias kgalla='kubectl get all --all-namespaces'
  
  # Describe commands
  alias kd='kubectl describe'
  alias kdp='kubectl describe pod'
  alias kdd='kubectl describe deployment'
  alias kds='kubectl describe service'
  alias kdn='kubectl describe node'
  
  # Delete commands
  alias kdel='kubectl delete'
  alias kdelp='kubectl delete pod'
  alias kdeld='kubectl delete deployment'
  alias kdels='kubectl delete service'
  
  # Log commands
  alias kl='kubectl logs'
  alias klf='kubectl logs -f'
  alias klt='kubectl logs --tail=100'
  alias klft='kubectl logs -f --tail=100'
  
  # Exec commands
  alias ke='kubectl exec -it'
  alias kesh='kubectl exec -it -- /bin/sh'
  alias kebash='kubectl exec -it -- /bin/bash'
  
  # Apply/Create commands
  alias ka='kubectl apply -f'
  alias kc='kubectl create'
  alias kcf='kubectl create -f'
  alias kaf='kubectl apply -f'
  alias kar='kubectl apply -R -f'
  
  # Edit commands
  alias ked='kubectl edit'
  alias kedp='kubectl edit pod'
  alias kedd='kubectl edit deployment'
  
  # Scale commands
  alias ksc='kubectl scale'
  alias ksd='kubectl scale deployment'
  
  # Port forward
  alias kpf='kubectl port-forward'
  
  # Top/Resource usage
  alias ktop='kubectl top'
  alias ktopp='kubectl top pods'
  alias ktopn='kubectl top nodes'
  
  # Context and config
  alias kctx='kubectl config current-context'
  alias kctxs='kubectl config get-contexts'
  alias kuse='kubectl config use-context'
  alias kns='kubectl config set-context --current --namespace'
  
  # Rollout
  alias kro='kubectl rollout'
  alias kros='kubectl rollout status'
  alias kroh='kubectl rollout history'
  alias krou='kubectl rollout undo'
  alias kror='kubectl rollout restart'
fi

# ====================================
# HELM ALIASES
# ====================================
if command -v helm &>/dev/null; then
  alias h='helm'
  alias hi='helm install'
  alias hu='helm upgrade'
  alias hui='helm upgrade --install'
  alias hd='helm delete'
  alias hl='helm list'
  alias hla='helm list --all'
  alias hlan='helm list --all-namespaces'
  alias hs='helm search'
  alias hsr='helm search repo'
  alias hsh='helm search hub'
  alias hr='helm repo'
  alias hra='helm repo add'
  alias hru='helm repo update'
  alias hrl='helm repo list'
  alias hg='helm get'
  alias hgv='helm get values'
  alias hga='helm get all'
  alias hgm='helm get manifest'
  alias ht='helm template'
  alias hh='helm history'
  alias hrb='helm rollback'
  alias hst='helm status'
  alias hdep='helm dependency'
  alias hdepu='helm dependency update'
  alias hdepb='helm dependency build'
fi

# ====================================
# KUBERNETES FUNCTIONS
# ====================================

# Quick context switch with fuzzy finder
kctx-switch() {
  if command -v fzf &>/dev/null; then
    local context=$(kubectl config get-contexts -o name | fzf --height 40% --prompt="Select context: ")
    if [[ -n "$context" ]]; then
      kubectl config use-context "$context"
    fi
  else
    kubectl config get-contexts
  fi
}

# Quick namespace switch with fuzzy finder
kns-switch() {
  if command -v fzf &>/dev/null; then
    local ns=$(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | fzf --height 40% --prompt="Select namespace: ")
    if [[ -n "$ns" ]]; then
      kubectl config set-context --current --namespace="$ns"
      echo "Switched to namespace: $ns"
    fi
  else
    kubectl get namespaces
  fi
}

# Get pod by partial name with fuzzy finder
kpod() {
  if command -v fzf &>/dev/null; then
    kubectl get pods | fzf --header-lines=1 --height 40% | awk '{print $1}'
  else
    kubectl get pods "$@"
  fi
}

# Exec into pod with fuzzy selection
kexec() {
  local pod=$(kpod)
  if [[ -n "$pod" ]]; then
    local shell="${1:-/bin/sh}"
    kubectl exec -it "$pod" -- "$shell"
  fi
}

# Tail logs with fuzzy pod selection
klogs() {
  local pod=$(kpod)
  if [[ -n "$pod" ]]; then
    kubectl logs -f --tail=100 "$pod" "$@"
  fi
}

# Describe pod with fuzzy selection
kdesc() {
  local pod=$(kpod)
  if [[ -n "$pod" ]]; then
    kubectl describe pod "$pod"
  fi
}

# Delete pod with fuzzy selection and confirmation
kdelpod() {
  local pod=$(kpod)
  if [[ -n "$pod" ]]; then
    echo "Delete pod: $pod? (y/n)"
    read -q confirm
    echo ""
    if [[ "$confirm" == "y" ]]; then
      kubectl delete pod "$pod"
    fi
  fi
}

# Watch pods in current namespace
kwatch() {
  local selector="${1:-}"
  if [[ -n "$selector" ]]; then
    watch -n 2 "kubectl get pods -l $selector"
  else
    watch -n 2 'kubectl get pods'
  fi
}

# Get all resources in a namespace
kall() {
  local ns="${1:-$(kubectl config view --minify --output 'jsonpath={..namespace}')}"
  echo "Resources in namespace: $ns"
  echo "========================="
  for resource in pods deployments services configmaps secrets ingress pvc jobs cronjobs; do
    echo "\n--- $resource ---"
    kubectl get "$resource" -n "$ns" 2>/dev/null || echo "None"
  done
}

# Debug pod - create a debug container
kdebug() {
  local image="${1:-nicolaka/netshoot}"
  local name="debug-$(date +%s)"
  
  echo "Creating debug pod: $name with image: $image"
  kubectl run "$name" --rm -it --image="$image" --restart=Never -- /bin/bash
}

# Port forward with fuzzy selection
kpf-select() {
  local pod=$(kpod)
  if [[ -n "$pod" ]]; then
    local local_port="${1:-8080}"
    local remote_port="${2:-$local_port}"
    echo "Port forwarding $pod: localhost:$local_port -> pod:$remote_port"
    kubectl port-forward "$pod" "$local_port:$remote_port"
  fi
}

# Get pod resource usage
kres() {
  echo "Pod Resource Usage:"
  kubectl top pods --sort-by=memory 2>/dev/null || echo "Metrics server not available"
}

# Restart deployment
krestart() {
  local deployment="$1"
  if [[ -z "$deployment" ]]; then
    if command -v fzf &>/dev/null; then
      deployment=$(kubectl get deployments -o name | fzf --height 40% --prompt="Select deployment: " | sed 's|deployment.apps/||')
    else
      echo "Usage: krestart <deployment-name>"
      return 1
    fi
  fi
  
  if [[ -n "$deployment" ]]; then
    echo "Restarting deployment: $deployment"
    kubectl rollout restart deployment/"$deployment"
    kubectl rollout status deployment/"$deployment"
  fi
}

# Get events sorted by time
kevents() {
  local ns="${1:---all-namespaces}"
  kubectl get events $ns --sort-by='.lastTimestamp' | tail -20
}

# Show cluster info summary
kinfo() {
  echo "Cluster Info:"
  echo "============="
  echo "Context: $(kubectl config current-context)"
  echo "Namespace: $(kubectl config view --minify --output 'jsonpath={..namespace}')"
  echo ""
  echo "Nodes:"
  kubectl get nodes
  echo ""
  echo "Namespaces:"
  kubectl get namespaces
}

# Create namespace with resource quota
kns-create() {
  local ns="$1"
  local cpu_limit="${2:-4}"
  local mem_limit="${3:-8Gi}"
  
  if [[ -z "$ns" ]]; then
    echo "Usage: kns-create <namespace> [cpu-limit] [memory-limit]"
    return 1
  fi
  
  kubectl create namespace "$ns"
  
  cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: $ns
spec:
  hard:
    requests.cpu: "${cpu_limit}"
    requests.memory: "${mem_limit}"
    limits.cpu: "${cpu_limit}"
    limits.memory: "${mem_limit}"
EOF
  
  echo "Created namespace '$ns' with resource quota"
}

# Decode and view secret
ksec-view() {
  local secret="$1"
  
  if [[ -z "$secret" ]]; then
    if command -v fzf &>/dev/null; then
      secret=$(kubectl get secrets -o name | fzf --height 40% --prompt="Select secret: " | sed 's|secret/||')
    else
      echo "Usage: ksec-view <secret-name>"
      return 1
    fi
  fi
  
  if [[ -n "$secret" ]]; then
    echo "Secret: $secret"
    echo "==========="
    kubectl get secret "$secret" -o json | jq -r '.data | to_entries[] | "\(.key): \(.value | @base64d)"'
  fi
}
