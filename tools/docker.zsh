#!/usr/bin/env zsh

# docker.zsh
# Author: Thomas Vincent
# GitHub: https://github.com/thomasvincent/dotfiles
#
# This file contains Docker-specific configuration.

# Docker aliases
alias d="docker"
alias dc="docker-compose"
alias dps="docker ps"
alias dpsa="docker ps -a"
alias di="docker images"
alias dex="docker exec -it"
alias drun="docker run -it"
alias drm="docker rm"
alias drmi="docker rmi"
alias dprune="docker system prune -a"
alias dstop="docker stop"
alias dstart="docker start"
alias drestart="docker restart"
alias dlogs="docker logs"
alias dlogsf="docker logs -f"
alias dip="docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'"

# Docker functions

# List all Docker containers
docker-ls() {
  docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Image}}\t{{.Ports}}"
}

# List all Docker images
docker-images() {
  docker images --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}\t{{.Size}}"
}

# Remove all Docker containers
docker-rm-all() {
  docker rm -f $(docker ps -aq)
}

# Remove all Docker images
docker-rmi-all() {
  docker rmi -f $(docker images -q)
}

# Remove all Docker volumes
docker-volume-rm-all() {
  docker volume rm $(docker volume ls -q)
}

# Remove all Docker networks
docker-network-rm-all() {
  docker network rm $(docker network ls -q)
}

# Remove all Docker containers, images, volumes, and networks
docker-clean-all() {
  docker-rm-all
  docker-rmi-all
  docker-volume-rm-all
  docker-network-rm-all
}

# Remove all stopped Docker containers
docker-rm-stopped() {
  docker rm $(docker ps -aq -f status=exited)
}

# Remove all dangling Docker images
docker-rmi-dangling() {
  docker rmi $(docker images -q -f dangling=true)
}

# Remove all dangling Docker volumes
docker-volume-rm-dangling() {
  docker volume rm $(docker volume ls -q -f dangling=true)
}

# Remove all dangling Docker networks
docker-network-rm-dangling() {
  docker network rm $(docker network ls -q -f dangling=true)
}

# Remove all dangling Docker containers, images, volumes, and networks
docker-clean-dangling() {
  docker-rm-stopped
  docker-rmi-dangling
  docker-volume-rm-dangling
  docker-network-rm-dangling
}

# Get Docker container IP address
docker-ip() {
  docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$@"
}

# Get Docker container environment variables
docker-env() {
  docker inspect --format '{{range .Config.Env}}{{println .}}{{end}}' "$@"
}

# Get Docker container ports
docker-ports() {
  docker inspect --format '{{range $p, $conf := .NetworkSettings.Ports}}{{$p}} -> {{(index $conf 0).HostPort}}{{println}}{{end}}' "$@"
}

# Get Docker container volumes
docker-volumes() {
  docker inspect --format '{{range .Mounts}}{{.Source}} -> {{.Destination}}{{println}}{{end}}' "$@"
}

# Get Docker container labels
docker-labels() {
  docker inspect --format '{{range $k, $v := .Config.Labels}}{{$k}}={{$v}}{{println}}{{end}}' "$@"
}

# Get Docker container logs
docker-logs() {
  docker logs -f "$@"
}

# Get Docker container stats
docker-stats() {
  docker stats "$@"
}

# Get Docker container processes
docker-top() {
  docker top "$@"
}

# Get Docker container details
docker-inspect() {
  docker inspect "$@"
}

# Get Docker container history
docker-history() {
  docker history "$@"
}

# Get Docker container diff
docker-diff() {
  docker diff "$@"
}

# Get Docker container events
docker-events() {
  docker events "$@"
}

# Get Docker container info
docker-info() {
  docker info
}

# Get Docker container version
docker-version() {
  docker version
}

# Get Docker container system
docker-system() {
  docker system "$@"
}

# Get Docker container system df
docker-system-df() {
  docker system df
}

# Get Docker container system events
docker-system-events() {
  docker system events
}

# Get Docker container system info
docker-system-info() {
  docker system info
}

# Get Docker container system prune
docker-system-prune() {
  docker system prune "$@"
}

# Get Docker container network
docker-network() {
  docker network "$@"
}

# Get Docker container network ls
docker-network-ls() {
  docker network ls
}

# Get Docker container network inspect
docker-network-inspect() {
  docker network inspect "$@"
}

# Get Docker container network create
docker-network-create() {
  docker network create "$@"
}

# Get Docker container network rm
docker-network-rm() {
  docker network rm "$@"
}

# Get Docker container network prune
docker-network-prune() {
  docker network prune
}

# Get Docker container volume
docker-volume() {
  docker volume "$@"
}

# Get Docker container volume ls
docker-volume-ls() {
  docker volume ls
}

# Get Docker container volume inspect
docker-volume-inspect() {
  docker volume inspect "$@"
}

# Get Docker container volume create
docker-volume-create() {
  docker volume create "$@"
}

# Get Docker container volume rm
docker-volume-rm() {
  docker volume rm "$@"
}

# Get Docker container volume prune
docker-volume-prune() {
  docker volume prune
}

# Get Docker container image
docker-image() {
  docker image "$@"
}

# Get Docker container image ls
docker-image-ls() {
  docker image ls
}

# Get Docker container image inspect
docker-image-inspect() {
  docker image inspect "$@"
}

# Get Docker container image history
docker-image-history() {
  docker image history "$@"
}

# Get Docker container image rm
docker-image-rm() {
  docker image rm "$@"
}

# Get Docker container image prune
docker-image-prune() {
  docker image prune
}

# Get Docker container container
docker-container() {
  docker container "$@"
}

# Get Docker container container ls
docker-container-ls() {
  docker container ls
}

# Get Docker container container inspect
docker-container-inspect() {
  docker container inspect "$@"
}

# Get Docker container container logs
docker-container-logs() {
  docker container logs "$@"
}

# Get Docker container container stats
docker-container-stats() {
  docker container stats "$@"
}

# Get Docker container container top
docker-container-top() {
  docker container top "$@"
}

# Get Docker container container diff
docker-container-diff() {
  docker container diff "$@"
}

# Get Docker container container rm
docker-container-rm() {
  docker container rm "$@"
}

# Get Docker container container prune
docker-container-prune() {
  docker container prune
}

# Get Docker container container run
docker-container-run() {
  docker container run "$@"
}

# Get Docker container container start
docker-container-start() {
  docker container start "$@"
}

# Get Docker container container stop
docker-container-stop() {
  docker container stop "$@"
}

# Get Docker container container restart
docker-container-restart() {
  docker container restart "$@"
}

# Get Docker container container pause
docker-container-pause() {
  docker container pause "$@"
}

# Get Docker container container unpause
docker-container-unpause() {
  docker container unpause "$@"
}

# Get Docker container container kill
docker-container-kill() {
  docker container kill "$@"
}

# Get Docker container container exec
docker-container-exec() {
  docker container exec "$@"
}

# Get Docker container container cp
docker-container-cp() {
  docker container cp "$@"
}

# Get Docker container container export
docker-container-export() {
  docker container export "$@"
}

# Get Docker container container port
docker-container-port() {
  docker container port "$@"
}

# Get Docker container container rename
docker-container-rename() {
  docker container rename "$@"
}

# Get Docker container container update
docker-container-update() {
  docker container update "$@"
}

# Get Docker container container wait
docker-container-wait() {
  docker container wait "$@"
}

# Get Docker container container attach
docker-container-attach() {
  docker container attach "$@"
}

# Get Docker container container commit
docker-container-commit() {
  docker container commit "$@"
}

# Get Docker container container create
docker-container-create() {
  docker container create "$@"
}

# Get Docker container container events
docker-container-events() {
  docker container events "$@"
}

# Get Docker container container ls -a
docker-container-ls-all() {
  docker container ls -a
}

# Get Docker container container ls -q
docker-container-ls-quiet() {
  docker container ls -q
}

# Get Docker container container ls -aq
docker-container-ls-all-quiet() {
  docker container ls -aq
}

# Get Docker container container ls -f
docker-container-ls-filter() {
  docker container ls -f "$@"
}

# Get Docker container container ls -af
docker-container-ls-all-filter() {
  docker container ls -af "$@"
}

# Get Docker container container ls -qf
docker-container-ls-quiet-filter() {
  docker container ls -qf "$@"
}

# Get Docker container container ls -aqf
docker-container-ls-all-quiet-filter() {
  docker container ls -aqf "$@"
}

# Docker Compose functions

# Docker Compose up
docker-compose-up() {
  docker-compose up "$@"
}

# Docker Compose down
docker-compose-down() {
  docker-compose down "$@"
}

# Docker Compose start
docker-compose-start() {
  docker-compose start "$@"
}

# Docker Compose stop
docker-compose-stop() {
  docker-compose stop "$@"
}

# Docker Compose restart
docker-compose-restart() {
  docker-compose restart "$@"
}

# Docker Compose logs
docker-compose-logs() {
  docker-compose logs "$@"
}

# Docker Compose ps
docker-compose-ps() {
  docker-compose ps "$@"
}

# Docker Compose exec
docker-compose-exec() {
  docker-compose exec "$@"
}

# Docker Compose run
docker-compose-run() {
  docker-compose run "$@"
}

# Docker Compose build
docker-compose-build() {
  docker-compose build "$@"
}

# Docker Compose pull
docker-compose-pull() {
  docker-compose pull "$@"
}

# Docker Compose push
docker-compose-push() {
  docker-compose push "$@"
}

# Docker Compose config
docker-compose-config() {
  docker-compose config "$@"
}

# Docker Compose images
docker-compose-images() {
  docker-compose images "$@"
}

# Docker Compose top
docker-compose-top() {
  docker-compose top "$@"
}

# Docker Compose events
docker-compose-events() {
  docker-compose events "$@"
}

# Docker Compose port
docker-compose-port() {
  docker-compose port "$@"
}

# Docker Compose pause
docker-compose-pause() {
  docker-compose pause "$@"
}

# Docker Compose unpause
docker-compose-unpause() {
  docker-compose unpause "$@"
}

# Docker Compose kill
docker-compose-kill() {
  docker-compose kill "$@"
}

# Docker Compose rm
docker-compose-rm() {
  docker-compose rm "$@"
}

# Docker Compose scale
docker-compose-scale() {
  docker-compose scale "$@"
}

# Docker Compose version
docker-compose-version() {
  docker-compose version
}

# Docker Compose help
docker-compose-help() {
  docker-compose help
}

# Docker Compose config
docker-compose-config() {
  docker-compose config
}

# Docker Compose ps
docker-compose-ps() {
  docker-compose ps
}

# Docker Compose top
docker-compose-top() {
  docker-compose top
}

# Docker Compose logs
docker-compose-logs() {
  docker-compose logs
}

# Docker Compose events
docker-compose-events() {
  docker-compose events
}

# Docker Compose pause
docker-compose-pause() {
  docker-compose pause
}

# Docker Compose unpause
docker-compose-unpause() {
  docker-compose unpause
}

# Docker Compose start
docker-compose-start() {
  docker-compose start
}

# Docker Compose stop
docker-compose-stop() {
  docker-compose stop
}

# Docker Compose restart
docker-compose-restart() {
  docker-compose restart
}

# Docker Compose kill
docker-compose-kill() {
  docker-compose kill
}

# Docker Compose rm
docker-compose-rm() {
  docker-compose rm
}

# Docker Compose build
docker-compose-build() {
  docker-compose build
}

# Docker Compose pull
docker-compose-pull() {
  docker-compose pull
}

# Docker Compose push
docker-compose-push() {
  docker-compose push
}

# Docker Compose up
docker-compose-up() {
  docker-compose up
}

# Docker Compose down
docker-compose-down() {
  docker-compose down
}

# Docker Compose exec
docker-compose-exec() {
  docker-compose exec
}

# Docker Compose run
docker-compose-run() {
  docker-compose run
}

# Docker Compose scale
docker-compose-scale() {
  docker-compose scale
}

# Docker Compose port
docker-compose-port() {
  docker-compose port
}

# Docker Compose images
docker-compose-images() {
  docker-compose images
}

# Docker Compose help
docker-compose-help() {
  docker-compose help
}

# Docker Compose version
docker-compose-version() {
  docker-compose version
}

# Docker Compose config
docker-compose-config() {
  docker-compose config
}

# Docker Compose ps
docker-compose-ps() {
  docker-compose ps
}

# Docker Compose top
docker-compose-top() {
  docker-compose top
}

# Docker Compose logs
docker-compose-logs() {
  docker-compose logs
}

# Docker Compose events
docker-compose-events() {
  docker-compose events
}

# Docker Compose pause
docker-compose-pause() {
  docker-compose pause
}

# Docker Compose unpause
docker-compose-unpause() {
  docker-compose unpause
}

# Docker Compose start
docker-compose-start() {
  docker-compose start
}

# Docker Compose stop
docker-compose-stop() {
  docker-compose stop
}

# Docker Compose restart
docker-compose-restart() {
  docker-compose restart
}

# Docker Compose kill
docker-compose-kill() {
  docker-compose kill
}

# Docker Compose rm
docker-compose-rm() {
  docker-compose rm
}

# Docker Compose build
docker-compose-build() {
  docker-compose build
}

# Docker Compose pull
docker-compose-pull() {
  docker-compose pull
}

# Docker Compose push
docker-compose-push() {
  docker-compose push
}

# Docker Compose up
docker-compose-up() {
  docker-compose up
}

# Docker Compose down
docker-compose-down() {
  docker-compose down
}

# Docker Compose exec
docker-compose-exec() {
  docker-compose exec
}

# Docker Compose run
docker-compose-run() {
  docker-compose run
}

# Docker Compose scale
docker-compose-scale() {
  docker-compose scale
}

# Docker Compose port
docker-compose-port() {
  docker-compose port
}

# Docker Compose images
docker-compose-images() {
  docker-compose images
}

# Docker Compose help
docker-compose-help() {
  docker-compose help
}

# Docker Compose version
docker-compose-version() {
  docker-compose version
}
