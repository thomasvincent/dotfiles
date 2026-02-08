#!/usr/bin/env bash
# generate-docs.sh - Auto-generate command reference from workflow modules
#
# Usage:
#   ./scripts/generate-docs.sh              # Generate docs/COMMANDS.md
#   ./scripts/generate-docs.sh --stdout     # Print to stdout

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
WORKFLOW_DIR="$REPO_DIR/home/dot_zsh"
OUTPUT_FILE="$REPO_DIR/docs/COMMANDS.md"

# Parse arguments
STDOUT_ONLY=false
if [[ "${1:-}" == "--stdout" ]]; then
  STDOUT_ONLY=true
fi

# Ensure docs directory exists
mkdir -p "$REPO_DIR/docs"

generate_docs() {
  cat <<'HEADER'
# Command Reference

Auto-generated reference of all functions and aliases from workflow modules.

> **Note**: This file is auto-generated. Do not edit manually.
> Run `./scripts/generate-docs.sh` to regenerate.

## Table of Contents

HEADER

  # Generate TOC
  for file in "$WORKFLOW_DIR"/*.zsh.tmpl; do
    [[ -f "$file" ]] || continue
    basename="${file##*/}"
    name="${basename%.zsh.tmpl}"
    anchor="${name//_/-}"
    echo "- [${name}](#${anchor})"
  done

  echo ""
  echo "---"
  echo ""

  # Process each workflow file
  for file in "$WORKFLOW_DIR"/*.zsh.tmpl; do
    [[ -f "$file" ]] || continue

    basename="${file##*/}"
    name="${basename%.zsh.tmpl}"

    echo "## ${name}"
    echo ""

    # Extract module description from header comment
    if head -10 "$file" | grep -q "^#"; then
      echo "### Description"
      echo ""
      head -20 "$file" | grep "^#" | sed 's/^# *//' | head -5
      echo ""
    fi

    # Extract functions
    functions=$(grep -E "^function [a-zA-Z_][a-zA-Z0-9_]*|^[a-zA-Z_][a-zA-Z0-9_]*\(\)" "$file" 2>/dev/null || true)
    if [[ -n "$functions" ]]; then
      echo "### Functions"
      echo ""
      echo '```'
      echo "$functions" | sed 's/function //' | sed 's/() {.*//' | sed 's/()//' | sort -u
      echo '```'
      echo ""
    fi

    # Extract aliases
    aliases=$(grep -E "^alias [a-zA-Z_][a-zA-Z0-9_-]*=" "$file" 2>/dev/null || true)
    if [[ -n "$aliases" ]]; then
      echo "### Aliases"
      echo ""
      echo "| Alias | Command |"
      echo "|-------|---------|"
      echo "$aliases" | while read -r line; do
        # Parse alias name and value
        alias_def="${line#alias }"
        alias_name="${alias_def%%=*}"
        alias_value="${alias_def#*=}"
        # Remove quotes
        alias_value="${alias_value#\"}"
        alias_value="${alias_value%\"}"
        alias_value="${alias_value#\'}"
        alias_value="${alias_value%\'}"
        # Escape pipes for markdown
        alias_value="${alias_value//|/\\|}"
        # Truncate long commands
        if [[ ${#alias_value} -gt 60 ]]; then
          alias_value="${alias_value:0:57}..."
        fi
        echo "| \`$alias_name\` | \`$alias_value\` |"
      done
      echo ""
    fi

    echo "---"
    echo ""
  done

  # Add generation timestamp
  echo ""
  echo "---"
  echo ""
  echo "*Generated on $(date '+%Y-%m-%d %H:%M:%S')*"
}

# Main
if $STDOUT_ONLY; then
  generate_docs
else
  generate_docs >"$OUTPUT_FILE"
  echo "Generated: $OUTPUT_FILE"
  echo "Functions and aliases extracted from $(find "$WORKFLOW_DIR" -name "*.zsh.tmpl" | wc -l | tr -d ' ') workflow modules"
fi
