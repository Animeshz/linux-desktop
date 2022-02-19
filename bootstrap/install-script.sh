#!/usr/bin/env bash

# Install Script for replicating the installation.
# Collects all the inputs at the start and installs everything.


# <<<
# Original Author: wavefrontHQ (https://github.com/wavefrontHQ/install)
# Licensed: Apache-2.0 (https://github.com/wavefrontHQ/install/blob/master/LICENSE)

# echo_title() outputs a title padded by =, in yellow.
function echo_title() {
    TITLE=$1
    NCOLS=$(tput cols)
    NEQUALS=$((($NCOLS-${#TITLE})/2-1))
    EQUALS=$(printf '=%.0s' $(seq 1 $NEQUALS))
    tput setaf 3  # 3 = yellow
    echo "$EQUALS $TITLE $EQUALS"
    tput sgr0  # reset terminal
}

# echo_step() outputs a step collored in cyan, without outputing a newline.
function echo_step() {
    tput setaf 6  # 6 = cyan
    echo -n "$1"
    tput sgr0  # reset terminal
}

# echo_step_info() outputs additional step info in cyan, without a newline.
function echo_step_info() {
    tput setaf 6  # 6 = cyan
    echo -n " ($1)"
    tput sgr0  # reset terminal
}

# echo_right() outputs a string at the rightmost side of the screen.
function echo_right() {
    TEXT=$1
    echo
    tput cuu1
    tput cuf $(tput cols)
    tput cub ${#TEXT}
    echo $TEXT
}

# echo_failure() outputs [ FAILED ] in red, at the rightmost side of the screen.
function echo_failure() {
    tput setaf 1  # 1 = red
    echo_right "[ FAILED ]"
    tput sgr0  # reset terminal
}

# echo_success() outputs [ OK ] in green, at the rightmost side of the screen.
function echo_success() {
    tput setaf 2  # 2 = green
    echo_right "[ OK ]"
    tput sgr0  # reset terminal
}

function echo_warning() {
    tput setaf 3  # 3 = yellow
    echo_right "[ WARNING ]"
    tput sgr0  # reset terminal
    echo "    ($1)"
}

# >>>

# exit_with_failure() calls echo_failure() and exit_with_message().
function exit_with_failure() {
	echo_failure
        echo
	echo "FAILURE: $1"
        exit 1
}

# ==================== Helper Functions ====================

validate_distro() {
    echo_step "Detecting distro"
    local os=$(uname -o)
    
    [[ -f /etc/os-release ]] || exit_with_failure "Unable to detect distro"
    distro="$(source /etc/os-release && printf '%s\n' "${PRETTY_NAME}")"
    echo_step_info "$distro"
    
    if [[ $distro = 'void' ]]; then
        echo_success
    else
        exit_with_failure "Unsupported distro"
    fi
}

validate_arch() {
    echo_step "Detecting architecture"
    
    arch=$(uname -m)
    echo_step_info "$arch"
    
    if [[ $arch = 'x86_64' ]]; then
        echo_success
    else
        exit_with_failure "Unsupported architecture"
    fi
}

# ==================== Validating Functions ====================

echo
echo_title "Checking Prerequisites"

validate_distro
validate_arch
