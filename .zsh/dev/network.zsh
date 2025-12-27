#!/usr/bin/env zsh
# =============================================================================
# Network Debugging and API Tools
# =============================================================================
#
# File: ~/.zsh/dev/network.zsh
# Purpose: Network debugging, API testing, and HTTP utilities
# Dependencies: curl, httpie (optional), jq
#
# =============================================================================

# =============================================================================
# NETWORK INFORMATION
# =============================================================================

# -----------------------------------------------------------------------------
# myip: Show internal and external IP addresses
# -----------------------------------------------------------------------------
myip() {
  echo "🌐 IP Addresses"
  echo "=============="
  
  # Internal IP
  if [[ "$(uname)" == "Darwin" ]]; then
    local internal=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null)
  else
    local internal=$(hostname -I 2>/dev/null | awk '{print $1}')
  fi
  echo "Internal: ${internal:-Not connected}"
  
  # External IP
  local external=$(curl -s --max-time 5 https://api.ipify.org 2>/dev/null)
  echo "External: ${external:-Unable to determine}"
}

# -----------------------------------------------------------------------------
# ports: Show listening ports
# -----------------------------------------------------------------------------
ports() {
  if [[ "$(uname)" == "Darwin" ]]; then
    sudo lsof -iTCP -sTCP:LISTEN -n -P
  else
    ss -tlnp
  fi
}

# -----------------------------------------------------------------------------
# port-check: Check if a port is open on a host
# -----------------------------------------------------------------------------
port-check() {
  local host="$1"
  local port="$2"
  
  if [[ -z "$host" ]] || [[ -z "$port" ]]; then
    echo "Usage: port-check <host> <port>"
    return 1
  fi
  
  if nc -z -w 3 "$host" "$port" 2>/dev/null; then
    echo "✅ Port $port is open on $host"
  else
    echo "❌ Port $port is closed on $host"
  fi
}

# -----------------------------------------------------------------------------
# listening: Show what's listening on a specific port
# -----------------------------------------------------------------------------
listening() {
  local port="$1"
  if [[ -z "$port" ]]; then
    echo "Usage: listening <port>"
    return 1
  fi
  
  if [[ "$(uname)" == "Darwin" ]]; then
    lsof -nP -iTCP:"$port" -sTCP:LISTEN
  else
    ss -tlnp | grep ":$port"
  fi
}

# =============================================================================
# HTTP/API UTILITIES
# =============================================================================

# -----------------------------------------------------------------------------
# http-headers: Show HTTP response headers
# -----------------------------------------------------------------------------
http-headers() {
  local url="$1"
  if [[ -z "$url" ]]; then
    echo "Usage: http-headers <url>"
    return 1
  fi
  curl -sI "$url"
}

# -----------------------------------------------------------------------------
# http-status: Show just the HTTP status code
# -----------------------------------------------------------------------------
http-status() {
  local url="$1"
  if [[ -z "$url" ]]; then
    echo "Usage: http-status <url>"
    return 1
  fi
  curl -sI -o /dev/null -w "%{http_code}" "$url"
  echo ""
}

# -----------------------------------------------------------------------------
# http-time: Show HTTP response timing
# -----------------------------------------------------------------------------
http-time() {
  local url="$1"
  if [[ -z "$url" ]]; then
    echo "Usage: http-time <url>"
    return 1
  fi
  
  curl -sL -o /dev/null -w "\
    DNS Lookup:  %{time_namelookup}s\n\
    Connect:     %{time_connect}s\n\
    TLS Setup:   %{time_appconnect}s\n\
    First Byte:  %{time_starttransfer}s\n\
    Total:       %{time_total}s\n\
    " "$url"
}

# -----------------------------------------------------------------------------
# api-get: Simple GET request with JSON pretty printing
# -----------------------------------------------------------------------------
api-get() {
  local url="$1"
  shift
  
  if [[ -z "$url" ]]; then
    echo "Usage: api-get <url> [curl-options]"
    return 1
  fi
  
  curl -sL "$@" "$url" | jq .
}

# -----------------------------------------------------------------------------
# api-post: POST JSON data
# -----------------------------------------------------------------------------
api-post() {
  local url="$1"
  local data="$2"
  
  if [[ -z "$url" ]] || [[ -z "$data" ]]; then
    echo "Usage: api-post <url> '<json-data>'"
    echo "Example: api-post https://api.example.com/users '{\"name\": \"John\"}'"
    return 1
  fi
  
  curl -sL -X POST \
    -H "Content-Type: application/json" \
    -d "$data" \
    "$url" | jq .
}

# -----------------------------------------------------------------------------
# api-put: PUT JSON data
# -----------------------------------------------------------------------------
api-put() {
  local url="$1"
  local data="$2"
  
  if [[ -z "$url" ]] || [[ -z "$data" ]]; then
    echo "Usage: api-put <url> '<json-data>'"
    return 1
  fi
  
  curl -sL -X PUT \
    -H "Content-Type: application/json" \
    -d "$data" \
    "$url" | jq .
}

# -----------------------------------------------------------------------------
# api-delete: DELETE request
# -----------------------------------------------------------------------------
api-delete() {
  local url="$1"
  
  if [[ -z "$url" ]]; then
    echo "Usage: api-delete <url>"
    return 1
  fi
  
  curl -sL -X DELETE "$url" | jq .
}

# -----------------------------------------------------------------------------
# jwt-decode: Decode a JWT token
# -----------------------------------------------------------------------------
jwt-decode() {
  local token="$1"
  
  if [[ -z "$token" ]]; then
    echo "Usage: jwt-decode <token>"
    return 1
  fi
  
  echo "🔐 JWT Decode"
  echo "============"
  echo ""
  echo "Header:"
  echo "$token" | cut -d'.' -f1 | base64 -d 2>/dev/null | jq .
  echo ""
  echo "Payload:"
  echo "$token" | cut -d'.' -f2 | base64 -d 2>/dev/null | jq .
}

# =============================================================================
# SSL/TLS UTILITIES
# =============================================================================

# -----------------------------------------------------------------------------
# ssl-check: Check SSL certificate for a domain
# -----------------------------------------------------------------------------
ssl-check() {
  local domain="$1"
  
  if [[ -z "$domain" ]]; then
    echo "Usage: ssl-check <domain>"
    return 1
  fi
  
  echo "🔒 SSL Certificate for: $domain"
  echo "================================"
  echo | openssl s_client -servername "$domain" -connect "$domain":443 2>/dev/null | openssl x509 -noout -dates -subject -issuer
}

# -----------------------------------------------------------------------------
# ssl-expiry: Check when SSL certificate expires
# -----------------------------------------------------------------------------
ssl-expiry() {
  local domain="$1"
  
  if [[ -z "$domain" ]]; then
    echo "Usage: ssl-expiry <domain>"
    return 1
  fi
  
  echo | openssl s_client -servername "$domain" -connect "$domain":443 2>/dev/null | openssl x509 -noout -enddate
}

# =============================================================================
# DNS UTILITIES
# =============================================================================

# -----------------------------------------------------------------------------
# dns-lookup: Comprehensive DNS lookup
# -----------------------------------------------------------------------------
dns-lookup() {
  local domain="$1"
  
  if [[ -z "$domain" ]]; then
    echo "Usage: dns-lookup <domain>"
    return 1
  fi
  
  echo "🌐 DNS Lookup: $domain"
  echo "========================"
  echo ""
  echo "A Records:"
  dig +short A "$domain"
  echo ""
  echo "AAAA Records:"
  dig +short AAAA "$domain"
  echo ""
  echo "MX Records:"
  dig +short MX "$domain"
  echo ""
  echo "NS Records:"
  dig +short NS "$domain"
  echo ""
  echo "TXT Records:"
  dig +short TXT "$domain"
}

# -----------------------------------------------------------------------------
# flush-dns: Flush DNS cache (macOS)
# -----------------------------------------------------------------------------
flush-dns() {
  if [[ "$(uname)" == "Darwin" ]]; then
    sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder
    echo "✅ DNS cache flushed"
  else
    sudo systemd-resolve --flush-caches 2>/dev/null || sudo systemctl restart systemd-resolved 2>/dev/null
    echo "✅ DNS cache flushed"
  fi
}

# =============================================================================
# ALIASES
# =============================================================================

alias headers='http-headers'
alias status='http-status'
alias timing='http-time'
alias get='api-get'
alias post='api-post'
alias sslcheck='ssl-check'
alias dnslookup='dns-lookup'
