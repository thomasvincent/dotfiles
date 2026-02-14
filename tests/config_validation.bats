#!/usr/bin/env bats

load test_helper/common-setup

@test "chezmoi.toml is valid TOML" {
    python3 -c "import tomllib; tomllib.load(open('${REPO_DIR}/chezmoi.toml', 'rb'))"
}

@test "chezmoi.toml.minimal.example is valid TOML" {
    python3 -c "import tomllib; tomllib.load(open('${REPO_DIR}/chezmoi.toml.minimal.example', 'rb'))"
}

@test "chezmoi.toml.personal.example is valid TOML" {
    python3 -c "import tomllib; tomllib.load(open('${REPO_DIR}/chezmoi.toml.personal.example', 'rb'))"
}

@test "chezmoi.toml.work.example is valid TOML" {
    python3 -c "import tomllib; tomllib.load(open('${REPO_DIR}/chezmoi.toml.work.example', 'rb'))"
}

@test "CI workflow is valid YAML" {
    python3 -c "import yaml; yaml.safe_load(open('${REPO_DIR}/.github/workflows/ci.yml'))"
}

@test "Makefile has valid syntax" {
    if [[ -f "${REPO_DIR}/Makefile" ]]; then
        make -n -f "${REPO_DIR}/Makefile" help &>/dev/null || make -n -f "${REPO_DIR}/Makefile" &>/dev/null
    else
        skip "No Makefile present"
    fi
}

@test "Git config is valid" {
    if [[ -f "${REPO_DIR}/.config/git/config" ]]; then
        git config --file "${REPO_DIR}/.config/git/config" --list &>/dev/null
    else
        skip "No .config/git/config present"
    fi
}
