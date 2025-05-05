#!/usr/bin/env zsh
# Docker development environment setup

# === Docker Utilities ===

# Start a quick interactive container
# Usage: drun [image] [command]
drun() {
  local image="${1:-ubuntu}"
  local cmd="${2:-bash}"
  
  echo "Starting interactive container from $image..."
  docker run --rm -it "$image" "$cmd"
}

# List all containers with formatted output
dlist() {
  docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Image}}\t{{.Ports}}"
}

# List all images with formatted output
dimages() {
  docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}"
}

# Quick docker-compose up with detached mode
dcup() {
  docker-compose up -d "$@"
}

# Check container logs
dlogs() {
  if [[ -z "$1" ]]; then
    echo "Usage: dlogs <container_name> [--follow]"
    return 1
  fi
  
  local container="$1"
  local follow="${2:---follow}"
  
  if [[ "$follow" == "--follow" ]] || [[ "$follow" == "-f" ]]; then
    docker logs --follow "$container"
  else
    docker logs "$container"
  fi
}

# Remove all stopped containers
dclean() {
  echo "Removing all stopped containers..."
  docker container prune -f
}

# Clean up unused images
dimgclean() {
  echo "Removing unused images..."
  docker image prune -f
}

# Clean up everything
dcleanall() {
  echo "Removing all stopped containers, unused images, networks, and volumes..."
  docker system prune -f
}

# Get inside a running container
dexec() {
  if [[ -z "$1" ]]; then
    echo "Usage: dexec <container_name> [command]"
    return 1
  fi
  
  local container="$1"
  local cmd="${2:-bash}"
  
  docker exec -it "$container" "$cmd"
}

# Show container stats
dstats() {
  docker stats
}

# Pull and update all images
dupdate() {
  echo "Updating all Docker images..."
  
  # Get all unique images
  local images=$(docker image ls --format "{{.Repository}}:{{.Tag}}" | grep -v "<none>")
  
  if [[ -z "$images" ]]; then
    echo "No images found"
    return 0
  fi
  
  echo "Found the following images:"
  echo "$images"
  echo
  
  echo -n "Pull updates for all images? [y/N] "
  read -q response
  echo
  
  if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "$images" | while read -r image; do
      echo "Updating $image..."
      docker pull "$image"
    done
    echo "All images updated"
  fi
}

# Kill and remove all running containers
dkill() {
  echo -n "Kill and remove all running containers? [y/N] "
  read -q response
  echo
  
  if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "Killing all running containers..."
    docker kill $(docker ps -q) 2>/dev/null || true
    echo "Removing all containers..."
    docker rm $(docker ps -a -q) 2>/dev/null || true
    echo "Done"
  fi
}

# Create a new Dockerfile
dcreate() {
  local filename="${1:-Dockerfile}"
  
  if [[ -f "$filename" ]]; then
    echo "File $filename already exists. Overwrite? [y/N] "
    read -q response
    echo
    
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
      return 1
    fi
  fi
  
  cat > "$filename" << 'EOF'
FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy application files
COPY . .

# Default command
CMD ["bash"]
EOF

  echo "Created Dockerfile at $filename"
}

# Create a new docker-compose.yml
dccompose() {
  local filename="${1:-docker-compose.yml}"
  
  if [[ -f "$filename" ]]; then
    echo "File $filename already exists. Overwrite? [y/N] "
    read -q response
    echo
    
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
      return 1
    fi
  fi
  
  cat > "$filename" << 'EOF'
version: '3.8'

services:
  app:
    build: .
    container_name: my-app
    volumes:
      - .:/app
    ports:
      - "8000:8000"
    environment:
      - NODE_ENV=development
    command: bash

  # Uncomment to add a database
  # db:
  #   image: postgres:latest
  #   container_name: my-db
  #   volumes:
  #     - postgres-data:/var/lib/postgresql/data
  #   ports:
  #     - "5432:5432"
  #   environment:
  #     - POSTGRES_USER=postgres
  #     - POSTGRES_PASSWORD=postgres
  #     - POSTGRES_DB=myapp

volumes:
  postgres-data:
EOF

  echo "Created docker-compose.yml at $filename"
}

# Show container IPs
dips() {
  docker ps -q | xargs -n 1 docker inspect --format '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' | sed 's#^/##'
}

# Inspect a container or image
dinspect() {
  if [[ -z "$1" ]]; then
    echo "Usage: dinspect <container_or_image>"
    return 1
  fi
  
  docker inspect "$1" | jq
}

# Generate YAML file for Kubernetes from Docker Compose
dcompose2kube() {
  if ! command -v kompose &> /dev/null; then
    echo "kompose not found. Install it first."
    return 1
  fi
  
  local compose_file="${1:-docker-compose.yml}"
  
  if [[ ! -f "$compose_file" ]]; then
    echo "Compose file $compose_file not found"
    return 1
  fi
  
  echo "Converting $compose_file to Kubernetes manifests..."
  kompose convert -f "$compose_file"
}

# Run command with Docker Buildx
dbuildx() {
  if ! docker buildx version &>/dev/null; then
    echo "Docker Buildx not available"
    return 1
  fi
  
  docker buildx "$@"
}