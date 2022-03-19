#!/usr/bin/env bash

finalize() {
    if [[ $POST_SPARSE_HIDE = 1 ]]; then
        echo_step "Running dothide"
        echo_success
        # dothide alias not sourced
        # run_with_user $user dothide && echo_success || exit_with_failure
    fi
}
