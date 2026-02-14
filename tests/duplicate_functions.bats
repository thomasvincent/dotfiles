#!/usr/bin/env bats

load test_helper/common-setup

@test "no duplicate function names across modules" {
    local all_funcs="${BATS_TMPDIR}/all_funcs.txt"
    for tmpl in "${ZSH_DIR}"/*.zsh.tmpl; do
        [[ -f "$tmpl" ]] || continue
        strip_template_markers "$tmpl" | grep -oE '^(function [a-zA-Z_][a-zA-Z0-9_-]*|[a-zA-Z_][a-zA-Z0-9_-]*\(\))' | sed -E 's/^function //; s/\(\)$//'
    done | sort > "$all_funcs"
    local dupes=$(uniq -d "$all_funcs")
    [ -z "$dupes" ] || { echo "Duplicate functions: $dupes" >&2; return 1; }
}
