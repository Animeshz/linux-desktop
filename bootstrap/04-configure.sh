POST_SPARSE_HIDE=1
SCRIPTS_URL="https://github.com/Animeshz/scripts"
SCRIPTS_HOME="$user_home/.scripts"
SCREEN_SIZES=

source "$SCRIPT_DIR/$distro/04-configure.sh"

configure_global() {
    # ask for monitor size(s) based on connected monitors
    SCREEN_SIZES=$(xrandr \
    | awk '/ connected/{print "Screen size for monitor "$1" ("$4")"}' \
    | xargs -I{} enquirer input -m "{}") || exit 1
}
