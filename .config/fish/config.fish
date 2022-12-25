# if status is-interactive
    # Commands to run in interactive sessions can go here
# end

function fish_user_key_bindings
    fish_default_key_bindings -M insert
    #fish_vi_key_bindings --no-erase insert

    bind \cX "fish_commandline_append ' | xclip -sel clip'"
    bind \cV "fish_commandline_prepend_full 'xclip -sel clip -o |'"  # https://github.com/fish-shell/fish-shell/issues/8763
end

function cmd_exists
    command -v $argv[1] 1>/dev/null && true || false
end

set -x EDITOR nvim

# For GOROOT to not takeover /usr/bin
fish_add_path /usr/bin
fish_add_path /usr/local/bin
fish_add_path /usr/lib/ruby/gems/3.1.0/bin
fish_add_path /opt/flutter/bin
fish_add_path /opt/cmdline-tools/bin

fish_add_path (fd -td -d1 . ~/.scripts 2>/dev/null || find ~/.scripts -type d -maxdepth 1)
fish_add_path ~/.local/bin
fish_add_path ~/.yarn/bin
fish_add_path ~/.cargo/bin
fish_add_path ~/.emacs.d/bin
fish_add_path -a ~/.nix-profile/bin
fish_add_path -a ~/.platformio/penv/bin

fish_add_path ~/Projects/RustProjects/eww/target/release
fish_add_path ~/Projects/main/templates

set fish_greeting
cmd_exists starship && starship init fish | source
cmd_exists zoxide && zoxide init fish | source
[ -f ~/.config/env-tokens ] && source ~/.config/env-tokens

# https://stackoverflow.com/a/42265848/11377112
set -x GPG_TTY (tty)
set -x PKG_CONFIG_PATH /usr/lib/pkgconfig
set -x CHROME_EXECUTABLE /bin/brave-browser-stable  # for flutter
set -x ANT_HOME /usr/share/apache-ant               # for jar builds (mainly emuArm)
set -x GOROOT /usr/lib/go
set -x GOPATH $HOME/.go
set -x ANDROID_HOME ~/.android-data/Sdk

if [ -f /usr/lib64/dri/iHD_drv_video.so ]; set -x LIBVA_DRIVER_NAME iHD; end

mkdir -p $GOPATH && fish_add_path $GOPATH/bin
fish_add_path $ANDROID_HOME/tools
fish_add_path $ANDROID_HOME/tools/bin
fish_add_path $ANDROID_HOME/cmdline-tools/latest/bin

export PATH="$PATH:$HOME/.spicetify"
alias dothide="yadm sparse-checkout set '/*' '!README.md' '!UNLICENSE' '!bootstrap' && yadm checkout --quiet"
alias dotunhide="yadm sparse-checkout set '/*' && yadm checkout --quiet"

# The next line updates PATH for Netlify's Git Credential Helper.
test -f '/home/animesh/.config/netlify/helper/path.fish.inc' && source '/home/animesh/.config/netlify/helper/path.fish.inc'
