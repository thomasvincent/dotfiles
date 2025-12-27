#!/usr/bin/env zsh
# ~/.zsh/dev/argocd.zsh - ArgoCD GitOps workflows and aliases
#
# Comprehensive ArgoCD tooling for GitOps operations
#

# ====================================
# ARGOCD ALIASES
# ====================================
if command -v argocd &>/dev/null; then
  alias argo='argocd'
  
  # Application commands
  alias argols='argocd app list'
  alias argoget='argocd app get'
  alias argosync='argocd app sync'
  alias argodiff='argocd app diff'
  alias argohist='argocd app history'
  alias argoroll='argocd app rollback'
  alias argodel='argocd app delete'
  alias argocreate='argocd app create'
  alias argoset='argocd app set'
  alias argowait='argocd app wait'
  alias argoterm='argocd app terminate-op'
  
  # Cluster commands
  alias argocls='argocd cluster list'
  alias argocladd='argocd cluster add'
  alias argoclrm='argocd cluster rm'
  
  # Project commands
  alias argopls='argocd proj list'
  alias argopcreate='argocd proj create'
  alias argopget='argocd proj get'
  
  # Repo commands
  alias argorls='argocd repo list'
  alias argoradd='argocd repo add'
  alias argorrm='argocd repo rm'
  
  # Account commands
  alias argoacc='argocd account list'
  alias argopasswd='argocd account update-password'
  
  # Context
  alias argoctx='argocd context'
fi

# ====================================
# ARGOCD FUNCTIONS
# ====================================

# Login to ArgoCD
argo-login() {
  local server="${1:-argocd.local}"
  local username="${2:-admin}"
  
  echo "Logging into ArgoCD: $server"
  argocd login "$server" --username "$username" --grpc-web
}

# Get initial admin password from Kubernetes secret
argo-init-password() {
  local namespace="${1:-argocd}"
  kubectl -n "$namespace" get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
  echo ""
}

# Port forward to ArgoCD server
argo-port-forward() {
  local namespace="${1:-argocd}"
  local port="${2:-8080}"
  
  echo "Port forwarding ArgoCD to localhost:$port"
  echo "Access at: https://localhost:$port"
  kubectl port-forward svc/argocd-server -n "$namespace" "$port:443"
}

# Sync application with fuzzy selection
argo-sync-select() {
  if command -v fzf &>/dev/null; then
    local app=$(argocd app list -o name | fzf --height 40% --prompt="Select app to sync: ")
    if [[ -n "$app" ]]; then
      echo "Syncing: $app"
      argocd app sync "$app"
    fi
  else
    argocd app list
  fi
}

# Get application status with details
argo-status() {
  local app="$1"
  
  if [[ -z "$app" ]]; then
    if command -v fzf &>/dev/null; then
      app=$(argocd app list -o name | fzf --height 40% --prompt="Select app: ")
    else
      argocd app list
      return 0
    fi
  fi
  
  if [[ -n "$app" ]]; then
    argocd app get "$app"
  fi
}

# Watch application sync status
argo-watch() {
  local app="$1"
  
  if [[ -z "$app" ]]; then
    watch -n 5 'argocd app list'
  else
    argocd app wait "$app" --sync --health
  fi
}

# Create application from Git repository
argo-create-app() {
  local app_name="$1"
  local repo_url="$2"
  local path="${3:-.}"
  local dest_namespace="${4:-default}"
  local project="${5:-default}"
  
  if [[ -z "$app_name" ]] || [[ -z "$repo_url" ]]; then
    echo "Usage: argo-create-app <app-name> <repo-url> [path] [namespace] [project]"
    return 1
  fi
  
  argocd app create "$app_name" \
    --repo "$repo_url" \
    --path "$path" \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace "$dest_namespace" \
    --project "$project" \
    --sync-policy automated \
    --auto-prune \
    --self-heal
  
  echo "Created application: $app_name"
  argocd app get "$app_name"
}

# Hard refresh application
argo-hard-refresh() {
  local app="$1"
  
  if [[ -z "$app" ]]; then
    if command -v fzf &>/dev/null; then
      app=$(argocd app list -o name | fzf --height 40% --prompt="Select app: ")
    else
      echo "Usage: argo-hard-refresh <app-name>"
      return 1
    fi
  fi
  
  if [[ -n "$app" ]]; then
    echo "Hard refreshing: $app"
    argocd app get "$app" --hard-refresh
  fi
}

# Show application diff
argo-diff-select() {
  if command -v fzf &>/dev/null; then
    local app=$(argocd app list -o name | fzf --height 40% --prompt="Select app to diff: ")
    if [[ -n "$app" ]]; then
      argocd app diff "$app"
    fi
  else
    argocd app list
  fi
}

# Rollback application
argo-rollback() {
  local app="$1"
  local revision="$2"
  
  if [[ -z "$app" ]]; then
    if command -v fzf &>/dev/null; then
      app=$(argocd app list -o name | fzf --height 40% --prompt="Select app: ")
    else
      echo "Usage: argo-rollback <app-name> [revision]"
      return 1
    fi
  fi
  
  if [[ -n "$app" ]]; then
    if [[ -z "$revision" ]]; then
      echo "Application history:"
      argocd app history "$app"
      echo ""
      read "revision?Enter revision to rollback to: "
    fi
    
    if [[ -n "$revision" ]]; then
      argocd app rollback "$app" "$revision"
    fi
  fi
}

# List out-of-sync applications
argo-out-of-sync() {
  echo "Out of sync applications:"
  argocd app list -o json | jq -r '.[] | select(.status.sync.status != "Synced") | "\(.metadata.name): \(.status.sync.status)"'
}

# List unhealthy applications
argo-unhealthy() {
  echo "Unhealthy applications:"
  argocd app list -o json | jq -r '.[] | select(.status.health.status != "Healthy") | "\(.metadata.name): \(.status.health.status)"'
}

# Dashboard summary
argo-dashboard() {
  echo "ArgoCD Dashboard"
  echo "================"
  echo ""
  echo "Applications Summary:"
  argocd app list -o json | jq -r '
    "Total: \(length)",
    "Synced: \([.[] | select(.status.sync.status == "Synced")] | length)",
    "OutOfSync: \([.[] | select(.status.sync.status != "Synced")] | length)",
    "Healthy: \([.[] | select(.status.health.status == "Healthy")] | length)",
    "Degraded: \([.[] | select(.status.health.status == "Degraded")] | length)"
  '
  echo ""
  echo "Clusters:"
  argocd cluster list
  echo ""
  echo "Repositories:"
  argocd repo list
}
