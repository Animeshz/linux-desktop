finalize() {
    echo_step "Running dothide"
    dothide && echo_success || exit_with_failure
}
