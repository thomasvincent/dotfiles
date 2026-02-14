#!/usr/bin/env bats

load test_helper/common-setup

@test "template files have balanced braces" {
    local failures=0
    while IFS= read -r tmpl; do
        local opens=$(grep -o '{{' "$tmpl" | wc -l | tr -d ' ')
        local closes=$(grep -o '}}' "$tmpl" | wc -l | tr -d ' ')
        if [ "$opens" -ne "$closes" ]; then
            echo "FAIL: $(basename "$tmpl"): $opens opens vs $closes closes" >&2
            failures=$((failures + 1))
        fi
    done < <(find "${HOME_DIR}" -name '*.tmpl' -type f)
    [ "$failures" -eq 0 ]
}

@test "template if/end blocks are balanced" {
    local failures=0
    while IFS= read -r tmpl; do
        local ifs=$(grep -cE '\{\{-?\s*(if|range)' "$tmpl" || true)
        local ends=$(grep -cE '\{\{-?\s*end' "$tmpl" || true)
        if [ "$ifs" -ne "$ends" ]; then
            echo "FAIL: $(basename "$tmpl"): $ifs if/range vs $ends end" >&2
            failures=$((failures + 1))
        fi
    done < <(find "${HOME_DIR}" -name '*.tmpl' -type f)
    [ "$failures" -eq 0 ]
}

@test "no empty if conditions" {
    local failures=0
    while IFS= read -r tmpl; do
        if grep -qE '\{\{-?\s*if\s*-?\}\}' "$tmpl" 2>/dev/null; then
            echo "FAIL: $(basename "$tmpl"): empty if condition found" >&2
            failures=$((failures + 1))
        fi
    done < <(find "${HOME_DIR}" -name '*.tmpl' -type f)
    [ "$failures" -eq 0 ]
}
