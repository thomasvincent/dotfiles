#!/usr/bin/env zsh
# digitalocean.zsh - DigitalOcean CLI configuration for macOS

# Ensure doctl is installed
if command -v doctl >/dev/null; then
  # Load doctl completion
  if [[ ! -f "${ZDOTDIR:-$HOME}/.zsh/completions/_doctl" ]]; then
    # Create completions directory if it doesn't exist
    mkdir -p "${ZDOTDIR:-$HOME}/.zsh/completions"
    print -P "%F{blue}Generating doctl completions...%f"
    doctl completion zsh > "${ZDOTDIR:-$HOME}/.zsh/completions/_doctl"
  fi

  # Add completions directory to fpath if not already added
  [[ -d "${ZDOTDIR:-$HOME}/.zsh/completions" ]] && fpath=("${ZDOTDIR:-$HOME}/.zsh/completions" $fpath)

  # Helpful aliases for doctl
  alias do-ls="doctl compute droplet list"
  alias do-regions="doctl compute region list"
  alias do-sizes="doctl compute size list"
  alias do-images="doctl compute image list --public"
  alias do-ssh="doctl compute ssh"
  alias do-balance="doctl balance get"

  # Function to create a new droplet with sane defaults
  do-create() {
    emulate -L zsh
    setopt local_options err_return pipefail

    local name="${1:?Missing droplet name}"
    local size="${2:-s-1vcpu-1gb}"
    local region="${3:-sfo3}"
    local image="${4:-ubuntu-22-04-x64}"

    print -P "%F{blue}Creating DigitalOcean droplet: %F{green}$name%f (%F{cyan}$size%f in %F{cyan}$region%f with %F{cyan}$image%f)"

    doctl compute droplet create "$name" \
      --size "$size" \
      --image "$image" \
      --region "$region" \
      --ssh-keys "$(doctl compute ssh-key list --format ID --no-header | tr '\n' ',')" \
      --wait

    print -P "%F{green}✓ Droplet created: %F{blue}$name%f"

    # Get the IP address
    local ip
    ip=$(doctl compute droplet get "$name" --format PublicIPv4 --no-header)

    print -P "%F{green}IP Address: %F{blue}$ip%f"
    print -P "%F{green}Connect with: %F{blue}ssh root@$ip%f"
  }

  # Function to delete a droplet with confirmation
  do-delete() {
    emulate -L zsh
    local name="${1:?Missing droplet name}"

    # Show droplet info first
    doctl compute droplet get "$name" --format ID,Name,PublicIPv4,Memory,Disk,Status

    # Ask for confirmation
    read -q "REPLY?Are you sure you want to delete droplet '$name'? (y/n) "
    echo

    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
      print -P "%F{yellow}Deleting droplet: %F{red}$name%f"
      doctl compute droplet delete "$name" --force
      print -P "%F{green}✓ Droplet deleted: %F{blue}$name%f"
    else
      print -P "%F{yellow}Operation cancelled%f"
    fi
  }

  # Function to list running droplets with their specs
  do-status() {
    emulate -L zsh
    print -P "%F{blue}DigitalOcean Account Status:%f"
    doctl account get --format Email,Status,DropletLimit

    print -P "%F{blue}Active Droplets:%f"
    doctl compute droplet list --format ID,Name,PublicIPv4,Memory,Disk,Status,Created
  }

  # Function to SSH into a droplet by name
  do-connect() {
    emulate -L zsh
    local name="${1:?Missing droplet name}"

    print -P "%F{blue}Connecting to %F{green}$name%f..."
    doctl compute ssh "$name"
  }
fi
