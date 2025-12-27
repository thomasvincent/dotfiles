#!/usr/bin/env zsh
# =============================================================================
# Docker Workflows and Aliases
# =============================================================================
#
# File: ~/.zsh/dev/docker.zsh
# Purpose: Docker and container management shortcuts
# Dependencies: docker, docker-compose, fzf (optional)
#
# =============================================================================

# =============================================================================
# DOCKER ALIASES
# =============================================================================

if command -v docker &>/dev/null; then
  # ---------------------------------------------------------------------------
  # Core Commands
  # ---------------------------------------------------------------------------
  alias d='docker'
  alias dc='docker compose'               # Docker Compose v2 (built-in)
  alias dco='docker-compose'              # Docker Compose v1 (standalone)
  
  # ---------------------------------------------------------------------------
  # Container Management
  # ---------------------------------------------------------------------------
  alias dps='docker ps'                   # List running containers
  alias dpsa='docker ps -a'               # List all containers
  alias dstart='docker start'             # Start container
  alias dstop='docker stop'               # Stop container
  alias drestart='docker restart'         # Restart container
  alias drm='docker rm'                   # Remove container
  alias drmf='docker rm -f'               # Force remove container
  
  # ---------------------------------------------------------------------------
  # Image Management
  # ---------------------------------------------------------------------------
  alias di='docker images'                # List images
  alias drmi='docker rmi'                 # Remove image
  alias dpull='docker pull'               # Pull image
  alias dpush='docker push'               # Push image
  alias dbuild='docker build'             # Build image
  alias dtag='docker tag'                 # Tag image
  
  # ---------------------------------------------------------------------------
  # Logs and Exec
  # ---------------------------------------------------------------------------
  alias dlogs='docker logs'               # View logs
  alias dlogsf='docker logs -f'           # Follow logs
  alias dlogst='docker logs --tail 100'   # Last 100 lines
  alias dexec='docker exec -it'           # Interactive exec
  alias dsh='docker exec -it /bin/sh'     # Shell into container
  alias dbash='docker exec -it /bin/bash' # Bash into container
  
  # ---------------------------------------------------------------------------
  # System Management
  # ---------------------------------------------------------------------------
  alias dprune='docker system prune -a'   # Clean everything
  alias ddf='docker system df'            # Disk usage
  alias dinfo='docker info'               # System info
  alias dstats='docker stats'             # Live resource usage
  
  # ---------------------------------------------------------------------------
  # Network
  # ---------------------------------------------------------------------------
  alias dnet='docker network'             # Network commands
  alias dnetls='docker network ls'        # List networks
  
  # ---------------------------------------------------------------------------
  # Volume
  # ---------------------------------------------------------------------------
  alias dvol='docker volume'              # Volume commands
  alias dvolls='docker volume ls'         # List volumes
  alias dvolrm='docker volume rm'         # Remove volume
fi

# =============================================================================
# DOCKER COMPOSE ALIASES
# =============================================================================

if command -v docker &>/dev/null; then
  alias dcup='docker compose up'          # Start services
  alias dcupd='docker compose up -d'      # Start detached
  alias dcupl='docker compose up -d && docker compose logs -f'  # Start and follow
  alias dcdown='docker compose down'      # Stop services
  alias dcdownv='docker compose down -v'  # Stop and remove volumes
  alias dcps='docker compose ps'          # List services
  alias dclogs='docker compose logs'      # View logs
  alias dclogsf='docker compose logs -f'  # Follow logs
  alias dcexec='docker compose exec'      # Exec into service
  alias dcbuild='docker compose build'    # Build services
  alias dcpull='docker compose pull'      # Pull images
  alias dcrestart='docker compose restart' # Restart services
fi

# =============================================================================
# DOCKER FUNCTIONS
# =============================================================================

# -----------------------------------------------------------------------------
# docker-shell: Interactive container selection and shell
# -----------------------------------------------------------------------------
#
# Usage:
#   docker-shell              # Select container, use sh
#   docker-shell /bin/bash    # Select container, use bash
#
# -----------------------------------------------------------------------------
docker-shell() {
  local shell="${1:-/bin/sh}"
  
  if ! command -v fzf &>/dev/null; then
    echo "Usage: docker-shell <container-id> [shell]"
    docker ps
    return 1
  fi
  
  local container
  container=$(docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}' | fzf --header-lines=1 --height 40% | awk '{print $1}')
  
  if [[ -n "$container" ]]; then
    echo "💻 Connecting to: $container"
    docker exec -it "$container" "$shell"
  fi
}
alias dshell='docker-shell'

# -----------------------------------------------------------------------------
# docker-logs-select: Tail logs from selected container
# -----------------------------------------------------------------------------
docker-logs-select() {
  if ! command -v fzf &>/dev/null; then
    echo "Usage: docker-logs-select"
    docker ps
    return 1
  fi
  
  local container
  container=$(docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Image}}' | fzf --header-lines=1 --height 40% | awk '{print $1}')
  
  if [[ -n "$container" ]]; then
    docker logs -f --tail 100 "$container"
  fi
}
alias dlf='docker-logs-select'

# -----------------------------------------------------------------------------
# docker-stop-all: Stop all running containers
# -----------------------------------------------------------------------------
docker-stop-all() {
  local containers=$(docker ps -q)
  if [[ -n "$containers" ]]; then
    echo "🛑 Stopping all containers..."
    docker stop $containers
    echo "✅ All containers stopped"
  else
    echo "No running containers"
  fi
}
alias dstopall='docker-stop-all'

# -----------------------------------------------------------------------------
# docker-rm-all: Remove all stopped containers
# -----------------------------------------------------------------------------
docker-rm-all() {
  local containers=$(docker ps -aq)
  if [[ -n "$containers" ]]; then
    echo "🗑️  Removing all containers..."
    docker rm $containers
    echo "✅ All containers removed"
  else
    echo "No containers to remove"
  fi
}
alias drmall='docker-rm-all'

# -----------------------------------------------------------------------------
# docker-rmi-dangling: Remove dangling images
# -----------------------------------------------------------------------------
docker-rmi-dangling() {
  local images=$(docker images -f "dangling=true" -q)
  if [[ -n "$images" ]]; then
    echo "🧹 Removing dangling images..."
    docker rmi $images
    echo "✅ Dangling images removed"
  else
    echo "No dangling images"
  fi
}
alias drmid='docker-rmi-dangling'

# -----------------------------------------------------------------------------
# docker-clean: Full cleanup (containers, images, volumes, networks)
# -----------------------------------------------------------------------------
docker-clean() {
  echo "🧹 Docker Cleanup"
  echo "==============="
  echo ""
  echo "This will remove:"
  echo "  - All stopped containers"
  echo "  - All dangling images"
  echo "  - All unused volumes"
  echo "  - All unused networks"
  echo ""
  echo -n "Continue? (y/n) "
  read confirm
  
  if [[ "$confirm" == "y" ]]; then
    docker system prune -a --volumes
    echo "✅ Cleanup complete"
  else
    echo "Cancelled"
  fi
}

# -----------------------------------------------------------------------------
# docker-ip: Get container IP address
# -----------------------------------------------------------------------------
docker-ip() {
  local container="$1"
  if [[ -z "$container" ]]; then
    echo "Usage: docker-ip <container>"
    return 1
  fi
  docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$container"
}

# -----------------------------------------------------------------------------
# docker-ports: Show exposed ports for a container
# -----------------------------------------------------------------------------
docker-ports() {
  local container="$1"
  if [[ -z "$container" ]]; then
    echo "Usage: docker-ports <container>"
    return 1
  fi
  docker port "$container"
}

# -----------------------------------------------------------------------------
# docker-size: Show image sizes sorted by size
# -----------------------------------------------------------------------------
docker-size() {
  docker images --format '{{.Size}}\t{{.Repository}}:{{.Tag}}' | sort -hr
}

# -----------------------------------------------------------------------------
# docker-run-here: Run image with current directory mounted
# -----------------------------------------------------------------------------
#
# Usage:
#   docker-run-here node:18      # Mount cwd as /app, run bash
#   docker-run-here python:3.11  # Mount cwd as /app, run bash
#
# -----------------------------------------------------------------------------
docker-run-here() {
  local image="$1"
  local shell="${2:-/bin/bash}"
  
  if [[ -z "$image" ]]; then
    echo "Usage: docker-run-here <image> [shell]"
    return 1
  fi
  
  echo "📦 Running $image with $(pwd) mounted as /app"
  docker run -it --rm -v "$(pwd):/app" -w /app "$image" "$shell"
}
alias drun='docker-run-here'

# -----------------------------------------------------------------------------
# dockerfile-lint: Lint Dockerfile
# -----------------------------------------------------------------------------
dockerfile-lint() {
  local file="${1:-Dockerfile}"
  
  if command -v hadolint &>/dev/null; then
    hadolint "$file"
  else
    echo "hadolint not installed. Install with: brew install hadolint"
    return 1
  fi
}
