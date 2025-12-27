#!/usr/bin/env zsh
# =============================================================================
# Kubernetes Workflows and Aliases
# =============================================================================
#
# File: ~/.zsh/dev/kubernetes.zsh
# Purpose: Comprehensive tooling for Kubernetes and Helm
# Dependencies: kubectl, helm (optional), fzf (optional, for fuzzy selection)
#
# This module provides:
#   - Extensive kubectl aliases for common operations
#   - Helm aliases for chart management
#   - Interactive functions using fzf for pod/resource selection
#   - Utility functions for debugging and troubleshooting
#
# =============================================================================

# =============================================================================
# KUBECTL ALIASES
# =============================================================================
#
# Organized by operation type. All aliases start with 'k' for kubectl.
# Naming convention:
#   k   = kubectl
#   kg  = kubectl get
#   kd  = kubectl describe
#   kdel = kubectl delete
#   etc.
#
# =============================================================================

if command -v kubectl &>/dev/null; then
  # ---------------------------------------------------------------------------
  # Base Commands
  # ---------------------------------------------------------------------------
  alias k='kubectl'                       # Base kubectl command
  alias kx='kubectx'                      # Switch contexts (if installed)
  alias kn='kubens'                       # Switch namespaces (if installed)
  
  # ---------------------------------------------------------------------------
  # GET Commands - Retrieve resources
  # ---------------------------------------------------------------------------
  alias kg='kubectl get'                  # Get any resource
  alias kgp='kubectl get pods'            # Get pods in current namespace
  alias kgpa='kubectl get pods --all-namespaces'  # Get ALL pods
  alias kgpw='kubectl get pods -o wide'   # Get pods with extra info (node, IP)
  alias kgd='kubectl get deployments'     # Get deployments
  alias kgs='kubectl get services'        # Get services
  alias kgn='kubectl get nodes'           # Get cluster nodes
  alias kgns='kubectl get namespaces'     # Get namespaces
  alias kgcm='kubectl get configmaps'     # Get configmaps
  alias kgsec='kubectl get secrets'       # Get secrets
  alias kging='kubectl get ingress'       # Get ingress resources
  alias kgpv='kubectl get pv'             # Get persistent volumes
  alias kgpvc='kubectl get pvc'           # Get persistent volume claims
  alias kgj='kubectl get jobs'            # Get jobs
  alias kgcj='kubectl get cronjobs'       # Get cronjobs
  alias kgsa='kubectl get serviceaccounts' # Get service accounts
  alias kgr='kubectl get roles'           # Get roles
  alias kgrb='kubectl get rolebindings'   # Get role bindings
  alias kgcr='kubectl get clusterroles'   # Get cluster roles
  alias kgcrb='kubectl get clusterrolebindings' # Get cluster role bindings
  alias kgall='kubectl get all'           # Get common resources
  alias kgalla='kubectl get all --all-namespaces' # Get all across namespaces
  
  # ---------------------------------------------------------------------------
  # DESCRIBE Commands - Detailed resource information
  # ---------------------------------------------------------------------------
  alias kd='kubectl describe'             # Describe any resource
  alias kdp='kubectl describe pod'        # Describe pod
  alias kdd='kubectl describe deployment' # Describe deployment
  alias kds='kubectl describe service'    # Describe service
  alias kdn='kubectl describe node'       # Describe node
  
  # ---------------------------------------------------------------------------
  # DELETE Commands - Remove resources (use with caution!)
  # ---------------------------------------------------------------------------
  alias kdel='kubectl delete'             # Delete any resource
  alias kdelp='kubectl delete pod'        # Delete pod
  alias kdeld='kubectl delete deployment' # Delete deployment
  alias kdels='kubectl delete service'    # Delete service
  
  # ---------------------------------------------------------------------------
  # LOG Commands - View container logs
  # ---------------------------------------------------------------------------
  alias kl='kubectl logs'                 # Get logs
  alias klf='kubectl logs -f'             # Follow logs (stream)
  alias klt='kubectl logs --tail=100'     # Last 100 lines
  alias klft='kubectl logs -f --tail=100' # Follow last 100 lines
  
  # ---------------------------------------------------------------------------
  # EXEC Commands - Run commands in containers
  # ---------------------------------------------------------------------------
  alias ke='kubectl exec -it'             # Interactive exec
  alias kesh='kubectl exec -it -- /bin/sh'    # Exec into shell
  alias kebash='kubectl exec -it -- /bin/bash' # Exec into bash
  
  # ---------------------------------------------------------------------------
  # APPLY/CREATE Commands - Create resources
  # ---------------------------------------------------------------------------
  alias ka='kubectl apply -f'             # Apply from file
  alias kc='kubectl create'               # Create resource
  alias kcf='kubectl create -f'           # Create from file
  alias kaf='kubectl apply -f'            # Apply from file
  alias kar='kubectl apply -R -f'         # Apply recursively
  
  # ---------------------------------------------------------------------------
  # EDIT Commands - Modify resources
  # ---------------------------------------------------------------------------
  alias ked='kubectl edit'                # Edit resource
  alias kedp='kubectl edit pod'           # Edit pod
  alias kedd='kubectl edit deployment'    # Edit deployment
  
  # ---------------------------------------------------------------------------
  # SCALE Commands - Scale resources
  # ---------------------------------------------------------------------------
  alias ksc='kubectl scale'               # Scale resource
  alias ksd='kubectl scale deployment'    # Scale deployment
  
  # ---------------------------------------------------------------------------
  # MISC Commands
  # ---------------------------------------------------------------------------
  alias kpf='kubectl port-forward'        # Port forward
  alias ktop='kubectl top'                # Resource usage
  alias ktopp='kubectl top pods'          # Pod resource usage
  alias ktopn='kubectl top nodes'         # Node resource usage
  
  # ---------------------------------------------------------------------------
  # CONTEXT/CONFIG Commands
  # ---------------------------------------------------------------------------
  alias kctx='kubectl config current-context'  # Current context
  alias kctxs='kubectl config get-contexts'    # List contexts
  alias kuse='kubectl config use-context'      # Switch context
  alias kns='kubectl config set-context --current --namespace'  # Set namespace
  
  # ---------------------------------------------------------------------------
  # ROLLOUT Commands - Manage deployments
  # ---------------------------------------------------------------------------
  alias kro='kubectl rollout'             # Rollout commands
  alias kros='kubectl rollout status'     # Rollout status
  alias kroh='kubectl rollout history'    # Rollout history
  alias krou='kubectl rollout undo'       # Rollback
  alias kror='kubectl rollout restart'    # Restart deployment
fi

# =============================================================================
# HELM ALIASES
# =============================================================================
#
# Helm is the package manager for Kubernetes. These aliases make
# chart management faster.
#
# =============================================================================

if command -v helm &>/dev/null; then
  alias h='helm'                          # Base helm command
  alias hi='helm install'                 # Install chart
  alias hu='helm upgrade'                 # Upgrade release
  alias hui='helm upgrade --install'      # Install or upgrade
  alias hd='helm delete'                  # Delete release (same as uninstall)
  alias hl='helm list'                    # List releases
  alias hla='helm list --all'             # List all releases (including failed)
  alias hlan='helm list --all-namespaces' # List across all namespaces
  alias hs='helm search'                  # Search charts
  alias hsr='helm search repo'            # Search in repos
  alias hsh='helm search hub'             # Search Artifact Hub
  alias hr='helm repo'                    # Repo commands
  alias hra='helm repo add'               # Add repo
  alias hru='helm repo update'            # Update repos
  alias hrl='helm repo list'              # List repos
  alias hg='helm get'                     # Get release info
  alias hgv='helm get values'             # Get release values
  alias hga='helm get all'                # Get all release info
  alias hgm='helm get manifest'           # Get release manifest
  alias ht='helm template'                # Render templates locally
  alias hh='helm history'                 # Release history
  alias hrb='helm rollback'               # Rollback release
  alias hst='helm status'                 # Release status
  alias hdep='helm dependency'            # Dependency commands
  alias hdepu='helm dependency update'    # Update dependencies
  alias hdepb='helm dependency build'     # Build dependencies
fi

# =============================================================================
# KUBERNETES FUNCTIONS
# =============================================================================
#
# These functions provide interactive workflows, often using fzf for
# fuzzy selection. They make common operations faster and easier.
#
# =============================================================================

# -----------------------------------------------------------------------------
# kctx-switch: Interactive context switching with fzf
# -----------------------------------------------------------------------------
#
# Use fzf to select and switch Kubernetes context. Falls back to
# listing contexts if fzf is not installed.
#
# Usage:
#   kctx-switch    # Opens fuzzy selector
#
# -----------------------------------------------------------------------------
kctx-switch() {
  if command -v fzf &>/dev/null; then
    local context
    context=$(kubectl config get-contexts -o name | fzf --height 40% --prompt="Select context: ")
    if [[ -n "$context" ]]; then
      kubectl config use-context "$context"
      echo "✅ Switched to context: $context"
    fi
  else
    echo "Available contexts:"
    kubectl config get-contexts
    echo ""
    echo "(Install fzf for interactive selection: brew install fzf)"
  fi
}

# -----------------------------------------------------------------------------
# kns-switch: Interactive namespace switching with fzf
# -----------------------------------------------------------------------------
#
# Use fzf to select and switch namespace in current context.
#
# Usage:
#   kns-switch     # Opens fuzzy selector
#
# -----------------------------------------------------------------------------
kns-switch() {
  if command -v fzf &>/dev/null; then
    local ns
    ns=$(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | fzf --height 40% --prompt="Select namespace: ")
    if [[ -n "$ns" ]]; then
      kubectl config set-context --current --namespace="$ns"
      echo "✅ Switched to namespace: $ns"
    fi
  else
    echo "Available namespaces:"
    kubectl get namespaces
    echo ""
    echo "(Install fzf for interactive selection: brew install fzf)"
  fi
}

# -----------------------------------------------------------------------------
# kpod: Select a pod using fzf
# -----------------------------------------------------------------------------
#
# Returns the name of the selected pod. Useful as a helper for other functions.
#
# Usage:
#   kpod           # Returns pod name
#   ke $(kpod)     # Exec into selected pod
#
# -----------------------------------------------------------------------------
kpod() {
  if command -v fzf &>/dev/null; then
    kubectl get pods | fzf --header-lines=1 --height 40% | awk '{print $1}'
  else
    echo "fzf not installed. Usage: kubectl get pods" >&2
    kubectl get pods
    return 1
  fi
}

# -----------------------------------------------------------------------------
# kexec: Exec into a pod selected with fzf
# -----------------------------------------------------------------------------
#
# Select a pod interactively, then exec into it.
#
# Usage:
#   kexec           # Select pod and exec with /bin/sh
#   kexec /bin/bash # Select pod and exec with bash
#
# -----------------------------------------------------------------------------
kexec() {
  local pod
  pod=$(kpod)
  if [[ -n "$pod" ]]; then
    local shell="${1:-/bin/sh}"
    echo "💻 Connecting to pod: $pod"
    kubectl exec -it "$pod" -- "$shell"
  fi
}

# -----------------------------------------------------------------------------
# klogs: Tail logs from a pod selected with fzf
# -----------------------------------------------------------------------------
#
# Select a pod interactively, then tail its logs.
#
# Usage:
#   klogs           # Select pod and tail logs
#   klogs -c app    # Select pod and tail specific container
#
# -----------------------------------------------------------------------------
klogs() {
  local pod
  pod=$(kpod)
  if [[ -n "$pod" ]]; then
    echo "📜 Tailing logs for pod: $pod"
    kubectl logs -f --tail=100 "$pod" "$@"
  fi
}

# -----------------------------------------------------------------------------
# kdesc: Describe a pod selected with fzf
# -----------------------------------------------------------------------------
kdesc() {
  local pod
  pod=$(kpod)
  if [[ -n "$pod" ]]; then
    kubectl describe pod "$pod"
  fi
}

# -----------------------------------------------------------------------------
# kdelpod: Delete a pod with fzf selection and confirmation
# -----------------------------------------------------------------------------
#
# Select a pod, confirm deletion, then delete it.
# Useful for killing stuck pods.
#
# Usage:
#   kdelpod        # Select and delete pod
#
# -----------------------------------------------------------------------------
kdelpod() {
  local pod
  pod=$(kpod)
  if [[ -n "$pod" ]]; then
    echo "⚠️  Delete pod: $pod? (y/n)"
    read -q confirm
    echo ""
    if [[ "$confirm" == "y" ]]; then
      kubectl delete pod "$pod"
      echo "✅ Deleted pod: $pod"
    else
      echo "❌ Cancelled"
    fi
  fi
}

# -----------------------------------------------------------------------------
# kwatch: Watch pods in real-time
# -----------------------------------------------------------------------------
#
# Continuously update pod status every 2 seconds.
# Optionally filter by label selector.
#
# Usage:
#   kwatch              # Watch all pods
#   kwatch app=nginx    # Watch pods with label app=nginx
#
# -----------------------------------------------------------------------------
kwatch() {
  local selector="${1:-}"
  if [[ -n "$selector" ]]; then
    watch -n 2 "kubectl get pods -l $selector"
  else
    watch -n 2 'kubectl get pods'
  fi
}

# -----------------------------------------------------------------------------
# kall: List all resources in a namespace
# -----------------------------------------------------------------------------
#
# Shows a comprehensive view of resources in a namespace.
# Useful for understanding what's deployed.
#
# Usage:
#   kall            # Current namespace
#   kall production # Specific namespace
#
# -----------------------------------------------------------------------------
kall() {
  local ns="${1:-$(kubectl config view --minify --output 'jsonpath={..namespace}')}"
  ns="${ns:-default}"  # Fallback to default if empty
  
  echo "📊 Resources in namespace: $ns"
  echo "============================================="
  
  for resource in pods deployments services configmaps secrets ingress pvc jobs cronjobs; do
    echo ""
    echo "--- $resource ---"
    kubectl get "$resource" -n "$ns" 2>/dev/null || echo "None"
  done
}

# -----------------------------------------------------------------------------
# kdebug: Launch a debug container for troubleshooting
# -----------------------------------------------------------------------------
#
# Creates a temporary pod with debugging tools (netshoot by default).
# The pod is deleted when you exit.
#
# Usage:
#   kdebug             # Use netshoot image
#   kdebug busybox     # Use busybox image
#
# -----------------------------------------------------------------------------
kdebug() {
  local image="${1:-nicolaka/netshoot}"  # netshoot has tons of network tools
  local name="debug-$(date +%s)"
  
  echo "🔧 Creating debug pod: $name"
  echo "   Image: $image"
  echo "   (Pod will be deleted when you exit)"
  echo ""
  
  kubectl run "$name" --rm -it --image="$image" --restart=Never -- /bin/bash
}

# -----------------------------------------------------------------------------
# kpf-select: Port forward with fzf pod selection
# -----------------------------------------------------------------------------
#
# Select a pod, then port forward to it.
#
# Usage:
#   kpf-select              # Forward 8080:8080
#   kpf-select 3000 3000    # Forward 3000:3000
#
# -----------------------------------------------------------------------------
kpf-select() {
  local pod
  pod=$(kpod)
  if [[ -n "$pod" ]]; then
    local local_port="${1:-8080}"
    local remote_port="${2:-$local_port}"
    echo "🔗 Port forwarding: localhost:$local_port → $pod:$remote_port"
    kubectl port-forward "$pod" "$local_port:$remote_port"
  fi
}

# -----------------------------------------------------------------------------
# krestart: Restart a deployment
# -----------------------------------------------------------------------------
#
# Restarts all pods in a deployment by triggering a rollout.
# Waits for the rollout to complete.
#
# Usage:
#   krestart           # Select deployment with fzf
#   krestart my-app    # Restart specific deployment
#
# -----------------------------------------------------------------------------
krestart() {
  local deployment="$1"
  
  # Use fzf if no deployment specified
  if [[ -z "$deployment" ]]; then
    if command -v fzf &>/dev/null; then
      deployment=$(kubectl get deployments -o name | fzf --height 40% --prompt="Select deployment: " | sed 's|deployment.apps/||')
    else
      echo "Usage: krestart <deployment-name>"
      return 1
    fi
  fi
  
  if [[ -n "$deployment" ]]; then
    echo "🔄 Restarting deployment: $deployment"
    kubectl rollout restart deployment/"$deployment"
    echo "⏳ Waiting for rollout to complete..."
    kubectl rollout status deployment/"$deployment"
    echo "✅ Restart complete"
  fi
}

# -----------------------------------------------------------------------------
# kevents: Show recent cluster events
# -----------------------------------------------------------------------------
#
# Shows the most recent events, sorted by timestamp.
# Useful for debugging issues.
#
# Usage:
#   kevents             # Current namespace
#   kevents -A          # All namespaces
#
# -----------------------------------------------------------------------------
kevents() {
  local ns="${1:---all-namespaces}"
  kubectl get events $ns --sort-by='.lastTimestamp' | tail -20
}

# -----------------------------------------------------------------------------
# kinfo: Show cluster summary
# -----------------------------------------------------------------------------
#
# Quick overview of the current cluster configuration.
#
# Usage:
#   kinfo
#
# -----------------------------------------------------------------------------
kinfo() {
  echo "🌐 Cluster Info"
  echo "============="
  echo "Context:   $(kubectl config current-context)"
  echo "Namespace: $(kubectl config view --minify --output 'jsonpath={..namespace}')"
  echo ""
  echo "💻 Nodes:"
  kubectl get nodes
  echo ""
  echo "📁 Namespaces:"
  kubectl get namespaces
}

# -----------------------------------------------------------------------------
# ksec-view: Decode and view secret values
# -----------------------------------------------------------------------------
#
# Secrets are base64 encoded. This function decodes them for viewing.
# Use with caution in shared terminals!
#
# Usage:
#   ksec-view              # Select secret with fzf
#   ksec-view my-secret    # View specific secret
#
# -----------------------------------------------------------------------------
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
    echo "🔐 Secret: $secret"
    echo "==========="
    # Decode each key-value pair
    kubectl get secret "$secret" -o json | jq -r '.data | to_entries[] | "\(.key): \(.value | @base64d)"'
  fi
}

# -----------------------------------------------------------------------------
# kns-create: Create namespace with resource quota
# -----------------------------------------------------------------------------
#
# Creates a namespace with default resource limits to prevent runaway usage.
#
# Usage:
#   kns-create my-app           # Default limits
#   kns-create my-app 8 16Gi    # 8 CPU cores, 16GB memory
#
# -----------------------------------------------------------------------------
kns-create() {
  local ns="$1"
  local cpu_limit="${2:-4}"
  local mem_limit="${3:-8Gi}"
  
  if [[ -z "$ns" ]]; then
    echo "Usage: kns-create <namespace> [cpu-limit] [memory-limit]"
    echo "  Default: 4 CPU cores, 8Gi memory"
    return 1
  fi
  
  echo "📦 Creating namespace: $ns"
  kubectl create namespace "$ns"
  
  echo "📏 Applying resource quota..."
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
  
  echo "✅ Created namespace '$ns' with resource quota:"
  echo "   CPU: ${cpu_limit}"
  echo "   Memory: ${mem_limit}"
}
