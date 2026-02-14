#!/usr/bin/env bats

load test_helper/common-setup

# Test that all templates render without errors against each profile
@test "all templates render with minimal profile" {
    command -v chezmoi >/dev/null 2>&1 || skip "chezmoi not installed"
    local config="${REPO_DIR}/tests/fixtures/chezmoi-minimal.toml"
    local failures=0

    while IFS= read -r -d '' tmpl; do
        local name="${tmpl#${REPO_DIR}/}"
        if ! chezmoi --config="$config" execute-template < "$tmpl" > /dev/null 2>&1; then
            echo "FAIL: $name" >&2
            failures=$((failures + 1))
        fi
    done < <(find "${REPO_DIR}/home" -name "*.tmpl" -type f -print0)
    [ "$failures" -eq 0 ]
}

@test "all templates render with personal profile" {
    command -v chezmoi >/dev/null 2>&1 || skip "chezmoi not installed"
    local config="${REPO_DIR}/tests/fixtures/chezmoi-personal.toml"
    local failures=0

    while IFS= read -r -d '' tmpl; do
        local name="${tmpl#${REPO_DIR}/}"
        if ! chezmoi --config="$config" execute-template < "$tmpl" > /dev/null 2>&1; then
            echo "FAIL: $name" >&2
            failures=$((failures + 1))
        fi
    done < <(find "${REPO_DIR}/home" -name "*.tmpl" -type f -print0)
    [ "$failures" -eq 0 ]
}

@test "all templates render with work profile" {
    command -v chezmoi >/dev/null 2>&1 || skip "chezmoi not installed"
    local config="${REPO_DIR}/tests/fixtures/chezmoi-work.toml"
    local failures=0

    while IFS= read -r -d '' tmpl; do
        local name="${tmpl#${REPO_DIR}/}"
        if ! chezmoi --config="$config" execute-template < "$tmpl" > /dev/null 2>&1; then
            echo "FAIL: $name" >&2
            failures=$((failures + 1))
        fi
    done < <(find "${REPO_DIR}/home" -name "*.tmpl" -type f -print0)
    [ "$failures" -eq 0 ]
}

@test "rendered templates contain no raw template markers" {
    command -v chezmoi >/dev/null 2>&1 || skip "chezmoi not installed"
    local config="${REPO_DIR}/tests/fixtures/chezmoi-minimal.toml"
    local failures=0

    # Skip files that legitimately output {{ markers (GitHub Actions, Packer, etc.)
    local skip_patterns=(
        "cicd.zsh.tmpl"
        "github_workflows.zsh.tmpl"
        "hashicorp_workflows.zsh.tmpl"
    )

    while IFS= read -r -d '' tmpl; do
        local name="${tmpl#${REPO_DIR}/}"
        local basename="${tmpl##*/}"

        # Check if this file should be skipped
        local should_skip=0
        for pattern in "${skip_patterns[@]}"; do
            if [[ "$basename" == "$pattern" ]]; then
                should_skip=1
                break
            fi
        done

        if [[ "$should_skip" -eq 1 ]]; then
            continue
        fi

        local rendered
        rendered=$(chezmoi --config="$config" execute-template < "$tmpl" 2>/dev/null) || continue
        if echo "$rendered" | grep -q '{{'; then
            echo "FAIL (raw markers): $name" >&2
            failures=$((failures + 1))
        fi
    done < <(find "${REPO_DIR}/home" -name "*.tmpl" -type f -print0)
    [ "$failures" -eq 0 ]
}
