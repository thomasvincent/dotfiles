#!/usr/bin/env bats

load test_helper/common-setup

@test "zsh modules pass syntax check" {
    local failures=0
    for tmpl in "${ZSH_DIR}"/*.zsh.tmpl; do
        [[ -f "$tmpl" ]] || continue
        local name=$(basename "$tmpl")
        local rendered="${BATS_TMPDIR}/${name%.tmpl}"
        strip_template_markers "$tmpl" > "$rendered"
        if ! zsh -n "$rendered" 2>/dev/null; then
            echo "FAIL: $name" >&2
            failures=$((failures + 1))
        fi
    done
    [ "$failures" -eq 0 ]
}
