# if status is-interactive
    # Commands to run in interactive sessions can go here
# end

function fish_user_key_bindings
    fish_default_key_bindings -M insert
    #fish_vi_key_bindings --no-erase insert

    bind \cX "fish_commandline_append ' | xclip -sel clip'"
    bind \cV "fish_commandline_prepend_full 'xclip -sel clip -o |'"  # https://github.com/fish-shell/fish-shell/issues/8763
end

fish_add_path (fd -td -d1 . ~/.scripts 2>/dev/null || find ~/.scripts -type d -maxdepth 1)
fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin
fish_add_path ~/.emacs.d/bin
fish_add_path /usr/lib/ruby/gems/3.0.0/bin
fish_add_path /opt/flutter/bin
fish_add_path ~/Projects/RustProjects/eww/target/release

set fish_greeting
starship init fish | source

# https://stackoverflow.com/a/42265848/11377112
set -x GPG_TTY (tty)
set -x PKG_CONFIG_PATH /usr/lib/pkgconfig
set -x CHROME_EXECUTABLE /bin/brave-browser-stable  # for flutter

export PATH="$PATH:$HOME/.spicetify"
