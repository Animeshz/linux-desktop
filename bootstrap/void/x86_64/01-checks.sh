check_pkgs_step() {
    echo_step "  $1"

    if query_pkg "$1"; then
        echo_success
    else
        echo_warning "" "NOT INSTALLED"
        not_founds+=("$1")
    fi
}

check_pkg_availability() {
    echo_step "Checking if required packages are available"; echo
    for program in "$@"; do
        check_cmds_step $program
    done
}
