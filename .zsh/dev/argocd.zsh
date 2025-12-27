#!/usr/bin/env zsh
# =============================================================================
# ArgoCD GitOps Workflows and Aliases
# =============================================================================
#
# File: ~/.zsh/dev/argocd.zsh
# Purpose: Comprehensive ArgoCD tooling for GitOps operations
# Dependencies: argocd CLI, kubectl, fzf (optional)
#
# This module provides:
#   - ArgoCD CLI aliases for common operations
#   - Interactive application management with fzf
#   - Quick status and health checking
#   - Rollback and sync workflows
#
# Setup:
#   1. Install ArgoCD CLI: brew install argocd
#   2. Login to your ArgoCD server: argocd login <server>
#   3. Or use: argo-port-forward then argo-login
#
# =============================================================================

# =============================================================================
# ARGOCD ALIASES
# =============================================================================
#
# Naming convention:
#   argo   = argocd
#   argo*  = argocd subcommands
#
# ArgoCD organizes resources into:
#   - Applications: Deployed workloads
#   - Projects: Groups of applications with access controls
#   - Clusters: Kubernetes clusters managed by ArgoCD
#   - Repositories: Git repos containing application manifests
#
# =============================================================================

if command -v argocd &>/dev/null; then
  # ---------------------------------------------------------------------------
  # Base Command
  # ---------------------------------------------------------------------------
  alias argo='argocd'                     # Base ArgoCD command
  
  # ---------------------------------------------------------------------------
  # Application Commands
  # ---------------------------------------------------------------------------
  # Applications are the core ArgoCD resource - they represent deployed workloads
  alias argols='argocd app list'          # List all applications
  alias argoget='argocd app get'          # Get application details
  alias argosync='argocd app sync'        # Sync application (deploy changes)
  alias argodiff='argocd app diff'        # Show diff between live and git
  alias argohist='argocd app history'     # Show deployment history
  alias argoroll='argocd app rollback'    # Rollback to previous version
  alias argodel='argocd app delete'       # Delete application
  alias argocreate='argocd app create'    # Create new application
  alias argoset='argocd app set'          # Modify application settings
  alias argowait='argocd app wait'        # Wait for app to be healthy
  alias argoterm='argocd app terminate-op' # Terminate running operation
  
  # ---------------------------------------------------------------------------
  # Cluster Commands
  # ---------------------------------------------------------------------------
  # Clusters are Kubernetes clusters that ArgoCD can deploy to
  alias argocls='argocd cluster list'     # List registered clusters
  alias argocladd='argocd cluster add'    # Add new cluster
  alias argoclrm='argocd cluster rm'      # Remove cluster
  
  # ---------------------------------------------------------------------------
  # Project Commands
  # ---------------------------------------------------------------------------
  # Projects group applications and define access controls
  alias argopls='argocd proj list'        # List projects
  alias argopcreate='argocd proj create'  # Create project
  alias argopget='argocd proj get'        # Get project details
  
  # ---------------------------------------------------------------------------
  # Repository Commands
  # ---------------------------------------------------------------------------
  # Repositories are Git repos containing application manifests
  alias argorls='argocd repo list'        # List configured repos
  alias argoradd='argocd repo add'        # Add repository
  alias argorrm='argocd repo rm'          # Remove repository
  
  # ---------------------------------------------------------------------------
  # Account Commands
  # ---------------------------------------------------------------------------
  alias argoacc='argocd account list'     # List accounts
  alias argopasswd='argocd account update-password'  # Change password
  
  # ---------------------------------------------------------------------------
  # Context Commands
  # ---------------------------------------------------------------------------
  alias argoctx='argocd context'          # Show/switch context
fi

# =============================================================================
# ARGOCD FUNCTIONS
# =============================================================================
#
# These functions provide higher-level workflows for common ArgoCD operations.
# Many support interactive selection using fzf.
#
# =============================================================================

# -----------------------------------------------------------------------------
# argo-login: Login to ArgoCD server
# -----------------------------------------------------------------------------
#
# Authenticates with an ArgoCD server. Use after port-forwarding
# or when connecting to an external ArgoCD instance.
#
# Usage:
#   argo-login                           # Login to argocd.local
#   argo-login argocd.mycompany.com      # Login to specific server
#   argo-login argocd.mycompany.com deployer  # With specific username
#
# -----------------------------------------------------------------------------
argo-login() {
  local server="${1:-argocd.local}"
  local username="${2:-admin}"
  
  echo "🔐 Logging into ArgoCD: $server"
  # --grpc-web enables gRPC over HTTP/1.1, useful behind load balancers
  argocd login "$server" --username "$username" --grpc-web
}

# -----------------------------------------------------------------------------
# argo-init-password: Get initial admin password from Kubernetes
# -----------------------------------------------------------------------------
#
# When ArgoCD is first installed, it generates a random admin password
# stored in a Kubernetes secret. This function retrieves and decodes it.
#
# Usage:
#   argo-init-password            # Default namespace: argocd
#   argo-init-password custom-ns  # Custom namespace
#
# After getting the password, you should change it:
#   argocd account update-password
#
# -----------------------------------------------------------------------------
argo-init-password() {
  local namespace="${1:-argocd}"
  
  echo "🔑 Initial admin password for ArgoCD:"
  kubectl -n "$namespace" get secret argocd-initial-admin-secret \
    -o jsonpath="{.data.password}" | base64 -d
  echo ""  # Add newline after password
  echo ""
  echo "Change this password with: argocd account update-password"
}

# -----------------------------------------------------------------------------
# argo-port-forward: Port forward to ArgoCD server
# -----------------------------------------------------------------------------
#
# Creates a port forward from localhost to the ArgoCD server.
# Useful for accessing ArgoCD when it's not exposed externally.
#
# Usage:
#   argo-port-forward              # localhost:8080 in argocd namespace
#   argo-port-forward argocd 9090  # Custom namespace and port
#
# After running, access ArgoCD at https://localhost:8080
# Then login with: argo-login localhost:8080
#
# -----------------------------------------------------------------------------
argo-port-forward() {
  local namespace="${1:-argocd}"
  local port="${2:-8080}"
  
  echo "🔗 Port forwarding ArgoCD to localhost:$port"
  echo "   Namespace: $namespace"
  echo ""
  echo "🌐 Access ArgoCD at: https://localhost:$port"
  echo "   (Press Ctrl+C to stop)"
  echo ""
  
  kubectl port-forward svc/argocd-server -n "$namespace" "$port:443"
}

# -----------------------------------------------------------------------------
# argo-sync-select: Sync an application with fuzzy selection
# -----------------------------------------------------------------------------
#
# Lists all applications and lets you select one to sync.
# Sync triggers ArgoCD to deploy the latest changes from git.
#
# Usage:
#   argo-sync-select
#
# -----------------------------------------------------------------------------
argo-sync-select() {
  if command -v fzf &>/dev/null; then
    local app
    app=$(argocd app list -o name | fzf --height 40% --prompt="Select app to sync: ")
    if [[ -n "$app" ]]; then
      echo "🔄 Syncing application: $app"
      argocd app sync "$app"
    fi
  else
    echo "Available applications:"
    argocd app list
    echo ""
    echo "Usage: argocd app sync <app-name>"
    echo "(Install fzf for interactive selection)"
  fi
}

# -----------------------------------------------------------------------------
# argo-status: Get detailed application status
# -----------------------------------------------------------------------------
#
# Shows comprehensive status for an application including:
#   - Sync status (Synced, OutOfSync)
#   - Health status (Healthy, Degraded, Progressing)
#   - Resources and their states
#
# Usage:
#   argo-status                    # Interactive selection
#   argo-status my-app             # Specific application
#
# -----------------------------------------------------------------------------
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

# -----------------------------------------------------------------------------
# argo-watch: Watch application status in real-time
# -----------------------------------------------------------------------------
#
# Continuously monitors application sync and health status.
# Useful during deployments or troubleshooting.
#
# Usage:
#   argo-watch                     # Watch all apps
#   argo-watch my-app              # Wait for specific app to be synced/healthy
#
# -----------------------------------------------------------------------------
argo-watch() {
  local app="$1"
  
  if [[ -z "$app" ]]; then
    # Watch all applications
    watch -n 5 'argocd app list'
  else
    # Wait for specific app to sync and become healthy
    echo "⏳ Waiting for $app to sync and become healthy..."
    argocd app wait "$app" --sync --health
    echo "✅ $app is synced and healthy!"
  fi
}

# -----------------------------------------------------------------------------
# argo-create-app: Create an application from a Git repository
# -----------------------------------------------------------------------------
#
# Creates a new ArgoCD application with sensible defaults:
#   - Automated sync policy
#   - Auto-prune (removes deleted resources)
#   - Self-heal (reverts manual changes)
#
# Usage:
#   argo-create-app my-app https://github.com/org/repo.git
#   argo-create-app my-app https://github.com/org/repo.git manifests/
#   argo-create-app my-app https://github.com/org/repo.git . production
#
# Arguments:
#   1. app-name: Name for the application
#   2. repo-url: Git repository URL
#   3. path: Path to manifests in repo (default: .)
#   4. namespace: Target namespace (default: default)
#   5. project: ArgoCD project (default: default)
#
# -----------------------------------------------------------------------------
argo-create-app() {
  local app_name="$1"
  local repo_url="$2"
  local path="${3:-.}"                    # Default: root of repo
  local dest_namespace="${4:-default}"     # Default: default namespace
  local project="${5:-default}"            # Default: default project
  
  if [[ -z "$app_name" ]] || [[ -z "$repo_url" ]]; then
    echo "Usage: argo-create-app <app-name> <repo-url> [path] [namespace] [project]"
    echo ""
    echo "Example:"
    echo "  argo-create-app my-app https://github.com/org/repo.git manifests/ production"
    return 1
  fi
  
  echo "🚀 Creating ArgoCD application: $app_name"
  echo "   Repository: $repo_url"
  echo "   Path: $path"
  echo "   Namespace: $dest_namespace"
  echo ""
  
  argocd app create "$app_name" \
    --repo "$repo_url" \
    --path "$path" \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace "$dest_namespace" \
    --project "$project" \
    --sync-policy automated \
    --auto-prune \
    --self-heal
  
  echo ""
  echo "✅ Application created!"
  argocd app get "$app_name"
}

# -----------------------------------------------------------------------------
# argo-hard-refresh: Force refresh application from Git
# -----------------------------------------------------------------------------
#
# Forces ArgoCD to re-read manifests from Git and recalculate diff.
# Useful when Git webhooks might have failed or cache is stale.
#
# Usage:
#   argo-hard-refresh              # Interactive selection
#   argo-hard-refresh my-app       # Specific application
#
# -----------------------------------------------------------------------------
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
    echo "🔄 Hard refreshing: $app"
    argocd app get "$app" --hard-refresh
    echo "✅ Refresh complete"
  fi
}

# -----------------------------------------------------------------------------
# argo-diff-select: Show diff for an application
# -----------------------------------------------------------------------------
#
# Shows the difference between the live state in Kubernetes
# and the desired state in Git.
#
# Usage:
#   argo-diff-select
#
# -----------------------------------------------------------------------------
argo-diff-select() {
  if command -v fzf &>/dev/null; then
    local app
    app=$(argocd app list -o name | fzf --height 40% --prompt="Select app to diff: ")
    if [[ -n "$app" ]]; then
      argocd app diff "$app"
    fi
  else
    argocd app list
    echo ""
    echo "Usage: argocd app diff <app-name>"
  fi
}

# -----------------------------------------------------------------------------
# argo-rollback: Rollback an application to a previous version
# -----------------------------------------------------------------------------
#
# Shows deployment history and allows rollback to a previous revision.
# The history shows each sync operation with timestamps.
#
# Usage:
#   argo-rollback                  # Interactive selection
#   argo-rollback my-app           # Show history, prompt for revision
#   argo-rollback my-app 5         # Rollback to revision 5
#
# -----------------------------------------------------------------------------
argo-rollback() {
  local app="$1"
  local revision="$2"
  
  # Select app if not provided
  if [[ -z "$app" ]]; then
    if command -v fzf &>/dev/null; then
      app=$(argocd app list -o name | fzf --height 40% --prompt="Select app: ")
    else
      echo "Usage: argo-rollback <app-name> [revision]"
      return 1
    fi
  fi
  
  if [[ -n "$app" ]]; then
    # Show history if no revision specified
    if [[ -z "$revision" ]]; then
      echo "📜 Application history for: $app"
      argocd app history "$app"
      echo ""
      echo -n "Enter revision number to rollback to: "
      read revision
    fi
    
    if [[ -n "$revision" ]]; then
      echo "⏪ Rolling back $app to revision $revision..."
      argocd app rollback "$app" "$revision"
      echo "✅ Rollback complete"
    fi
  fi
}

# -----------------------------------------------------------------------------
# argo-out-of-sync: List all out-of-sync applications
# -----------------------------------------------------------------------------
#
# Shows applications where the live state doesn't match Git.
# These need a sync to bring them up to date.
#
# Usage:
#   argo-out-of-sync
#
# -----------------------------------------------------------------------------
argo-out-of-sync() {
  echo "⚠️  Out of sync applications:"
  echo "=========================="
  argocd app list -o json | jq -r '.[] | select(.status.sync.status != "Synced") | "\(.metadata.name): \(.status.sync.status)"'
}

# -----------------------------------------------------------------------------
# argo-unhealthy: List all unhealthy applications
# -----------------------------------------------------------------------------
#
# Shows applications that are not in a healthy state.
# These might have failing pods, missing resources, etc.
#
# Usage:
#   argo-unhealthy
#
# -----------------------------------------------------------------------------
argo-unhealthy() {
  echo "🚨 Unhealthy applications:"
  echo "========================"
  argocd app list -o json | jq -r '.[] | select(.status.health.status != "Healthy") | "\(.metadata.name): \(.status.health.status)"'
}

# -----------------------------------------------------------------------------
# argo-dashboard: Show ArgoCD summary dashboard
# -----------------------------------------------------------------------------
#
# Provides a quick overview of all ArgoCD resources:
#   - Application count and status summary
#   - Registered clusters
#   - Configured repositories
#
# Usage:
#   argo-dashboard
#
# -----------------------------------------------------------------------------
argo-dashboard() {
  echo "📊 ArgoCD Dashboard"
  echo "=================="
  echo ""
  
  # Application summary using jq for JSON processing
  echo "📦 Applications Summary:"
  argocd app list -o json | jq -r '
    "   Total: \(length)",
    "   Synced: \([.[] | select(.status.sync.status == "Synced")] | length)",
    "   OutOfSync: \([.[] | select(.status.sync.status != "Synced")] | length)",
    "   Healthy: \([.[] | select(.status.health.status == "Healthy")] | length)",
    "   Degraded: \([.[] | select(.status.health.status == "Degraded")] | length)"
  '
  
  echo ""
  echo "💻 Clusters:"
  argocd cluster list
  
  echo ""
  echo "📁 Repositories:"
  argocd repo list
}
