check_distro() {
    echo_step "Detecting distro"
    local os=$(uname -o)

    [[ -f /etc/os-release ]] || exit_with_failure "Unable to detect distro"
    distro="$(source /etc/os-release && printf '%s\n' "${ID}")"
    echo_step_info "$distro"

    if (cd $SCRIPT_DIR && { command -v fd &>/dev/null && fd -td -d1 || find -maxdepth 1 -type d; } | grep -q "^\./$distro$"); then
        echo_success
    else
        exit_with_failure "Unsupported distro"
    fi
}

check_arch() {
    echo_step "Detecting architecture"

    arch=$(uname -m)
    echo_step_info "$arch"

    if (cd $SCRIPT_DIR/$distro && { command -v fd &>/dev/null && fd -td -d1 || find -maxdepth 1 -type d -o -type l; } | grep -q "^\./$arch$"); then
        echo_success
    else
        exit_with_failure "Unsupported architecture"
    fi
}

check_network() {
    echo_step "Checking network connectivity"

    if ping -q -w 1 -c 1 $(ip r | grep default | cut -d ' ' -f 3) &> /dev/null; then
        echo_step_info "connected"
        echo_success
    else
        exit_with_failure "Cannot connect to internet"
    fi
}

check_superuser() {
    echo_step "Checking superuser privileges"
    if [[ $EUID -eq 0 ]]; then
        echo_success
    else
        echo_step_info "user: $(whoami)"
        exit_with_failure "This script must be run as root"
    fi
}

check_user() {
    echo_step "Checking current local user"
    user=$(stat -c '%U' "$0") || exit_with_failure
    user_home=$(cat /etc/passwd | awk "/^$user:/" | cut -d: -f6)
    echo_step_info "$user"
    echo_success
}

check_cmds_step() {
    echo_step "  $1"

    if command_exists "$1"; then
        echo_success
    else
        echo_warning "" "NOT INSTALLED"
        not_founds+=("$1")
    fi
}
check_commands_availability() {
    echo_step "Checking if required commands are available"; echo
    local not_founds=()
    for program in "$@"; do
        check_cmds_step $program
    done

    if [[ ${#not_founds} -ne 0 ]]; then
        echo_step "Do you want to install the packages providing the commands? (Y/n) "
        read -n1 ans
        if [[ $ans != 'y' && $(LC_CTYPE=C printf '%d' "'$ans") != '0' ]]; then
            exit_with_failure "Cannot continue without required commands"
        fi

        echo
        sync_install_pkg
        sync_locate_cmd

        echo_step "  Finding package(s) providing the commands"
        pkgs=($(TERM=linux; for cmd in "${not_founds[@]}"; do locate_cmd $cmd; done))
        [[ $? = 0 ]] && echo_success || exit_with_failure "some packages can't be located"

        for pkg in "${pkgs[@]}"; do
            install_pkg $pkg
        done
    fi
}
