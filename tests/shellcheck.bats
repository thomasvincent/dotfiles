#!/usr/bin/env bats

load test_helper/common-setup

@test "rendered zsh modules pass shellcheck" {
    command -v shellcheck >/dev/null 2>&1 || skip "shellcheck not installed"
    command -v chezmoi >/dev/null 2>&1 || skip "chezmoi not installed"

    local failures=0
    local config="${REPO_DIR}/tests/fixtures/chezmoi-minimal.toml"

    for tmpl in "${ZSH_DIR}"/*.zsh.tmpl; do
        [[ -f "$tmpl" ]] || continue
        local name=$(basename "$tmpl")
        local rendered="${BATS_TMPDIR}/${name%.tmpl}"

        # Render with chezmoi; skip if rendering fails (template needs OS context)
        if ! chezmoi --config="$config" execute-template < "$tmpl" > "$rendered" 2>/dev/null; then
            echo "SKIP (render failed): $name" >&2
            continue
        fi

        # Skip empty renders (conditionally excluded modules)
        [[ -s "$rendered" ]] || continue

        if ! shellcheck --shell=bash --severity=error "$rendered" 2>/dev/null; then
            echo "FAIL: $name" >&2
            failures=$((failures + 1))
        fi
    done
    [ "$failures" -eq 0 ]
}
