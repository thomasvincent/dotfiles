#!/usr/bin/env bash

# Common setup for all bats tests
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TESTS_DIR="${REPO_DIR}/tests"
HOME_DIR="${REPO_DIR}/home"
ZSH_DIR="${HOME_DIR}/dot_zsh"

# Strip chezmoi template markers from a file, producing valid shell
strip_template_markers() {
    local file="$1"
    sed -E \
        -e '/\{\{-?\s*(if|range)/d' \
        -e '/\{\{-?\s*(else|end)/d' \
        -e 's/\{\{[^}]*\}\}/"TEMPLATE_VALUE"/g' \
        "$file"
}

# Render a template using chezmoi with a given config
render_template() {
    local file="$1"
    local config="${2:-${REPO_DIR}/chezmoi.toml}"
    chezmoi --config="$config" execute-template < "$file"
}

setup() {
    BATS_TMPDIR="$(mktemp -d)"
}

teardown() {
    [ -d "${BATS_TMPDIR:-}" ] && rm -rf "$BATS_TMPDIR"
}
