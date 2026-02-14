#!/usr/bin/env bats

load test_helper/common-setup

@test "template files have balanced braces" {
    # Files that generate code (GitHub Actions, Groovy, HCL) with their own brace structure
    local skip_list="cicd.zsh.tmpl groovy_workflows.zsh.tmpl github_workflows.zsh.tmpl hashicorp_workflows.zsh.tmpl"
    
    local failures=0
    while IFS= read -r tmpl; do
        local basename=$(basename "$tmpl")
        
        # Skip code-generating files with embedded brace structures
        if echo "$skip_list" | grep -qw "$basename"; then
            continue
        fi
        
        # Strip chezmoi template directives before counting braces
        local content
        content=$(sed 's/{{[^}]*}}//g' "$tmpl")
        local opens=$(echo "$content" | grep -o '{' | wc -l | tr -d ' ')
        local closes=$(echo "$content" | grep -o '}' | wc -l | tr -d ' ')
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
