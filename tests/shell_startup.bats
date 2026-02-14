#!/usr/bin/env bats

load test_helper/common-setup

@test "zsh starts without errors" {
    skip "requires applied dotfiles"
    TMP_ERR=$(mktemp)
    run zsh -i -c 'exit 0' 2>"$TMP_ERR"
    if [[ -s "$TMP_ERR" ]]; then
        cat "$TMP_ERR" >&2
        rm -f "$TMP_ERR"
        return 1
    fi
    rm -f "$TMP_ERR"
    [ "$status" -eq 0 ]
}
