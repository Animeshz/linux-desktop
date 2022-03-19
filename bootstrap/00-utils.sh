#!/usr/bin/env bash

# Utility functions to be used in different places of the boostrapping process

command_exists() {
    command -v "$1" 1>/dev/null && true || false
}

# <<<
# Highly inspired by Cyclenerd/postinstall & wavefrontHQ/install
#
# Original Author: wavefrontHQ
# Licensed: Apache-2.0 (https://github.com/wavefrontHQ/install/blob/master/LICENSE)
# >>>

# echo_title() outputs a title padded by =, in yellow.
function echo_title() {
    TITLE=$1
    NCOLS=$(tput cols)
    NEQUALS=$((($NCOLS-${#TITLE})/2-1))
    EQUALS=$(printf '=%.0s' $(seq 1 $NEQUALS))
    tput setaf 3  # 3 = yellow
    >&2 echo "$EQUALS $TITLE $EQUALS"
    tput sgr0  # reset terminal
}

# echo_step() outputs a step collored in cyan, without outputing a newline.
function echo_step() {
    tput setaf 6  # 6 = cyan
    >&2 echo -n "$1"
    tput sgr0  # reset terminal
}

# echo_step_info() outputs additional step info in cyan, without a newline.
function echo_step_info() {
    tput setaf 6  # 6 = cyan
    >&2 echo -n " ($1)"
    tput sgr0  # reset terminal
}

fetch_cursor_x_position() {
    local pos
    IFS='[;' read -p $'\e[6n' -d R -a pos -rs || >&2 echo "failed with error: $? ; ${pos[*]}"
    echo "${pos[2]}"
}
# echo_right() outputs a string at the rightmost side of the screen.
function echo_right() {
    TEXT=$1
    remaining_chars=$(($(tput cols) - $(fetch_cursor_x_position)))
    echo
    if (($remaining_chars > ${#TEXT})); then
        tput cuu1         # go a line up
    fi
    tput cuf $(tput cols) # go to end
    tput cub ${#TEXT}     # get back n characters
    >&2 echo $TEXT
}

# echo_failure() outputs [ FAILED ] in red, at the rightmost side of the screen along with a message in new line.
function echo_failure() {
    tput setaf 1  # 1 = red
    echo_right "[ ${2:-FAILED} ]"
    [[ -n $1 ]] && >&2 echo "FAILURE: $1"
    tput sgr0  # reset terminal
}

# echo_success() outputs [ OK ] in green, at the rightmost side of the screen.
function echo_success() {
    tput setaf 2  # 2 = green
    echo_right "[ OK ]"
    tput sgr0  # reset terminal
}

# echo_warning() outputs a message and [ WARNING ] in yellow, at the rightmost side of the screen.
function echo_warning() {
    tput setaf 3  # 3 = yellow
    echo_right "[ ${2:-WARNING} ]"
    tput sgr0  # reset terminal
    [[ -n $1 ]] && >&2 echo "    ($1)"
}

# exit_with_failure() calls echo_failure() and exit 1.
function exit_with_failure() {
    echo_failure "$1" "$2"
    exit 1
}
