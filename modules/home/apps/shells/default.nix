_:

{
  programs.fish.shellInit = ''
    set fish_greeting

    # TODO: make launch generic + multi-shell
    if [ -z $DISPLAY ] && [ $(tty) = "/dev/tty1" ];
       pgrep herbstluftwm || startx
    end
  '';

  programs.fish.functions = {

    fish_user_key_bindings = {
      description = "Sets keybinds";
      body = ''
        fish_default_key_bindings -M insert
        #fish_vi_key_bindings --no-erase insert

        bind \cX "fish_commandline_append ' | xclip -sel clip'"
        bind \cV "fish_commandline_prepend_full 'xclip -sel clip -o |'"  # https://github.com/fish-shell/fish-shell/issues/8763
      '';
    };

    fish_commandline_prepend_full = {
      description = "Allow meta-characters like pipe to be toggled (https://github.com/fish-shell/fish-shell/issues/8763)";
      body = ''
        if not commandline | string length -q
            commandline -r $history[1]
        end

        set -l escaped (string escape --style=regex -- $argv[1])
        set -l process (commandline | string collect)
        if set process (string replace -r -- "^$escaped " "" $process)
            commandline --replace -- $process
        else
            set -l cursor (commandline -C)
            commandline -C 0
            commandline -i -- "$argv[1] "
            commandline -C (math $cursor + (string length -- "$argv[1] "))
        end
      '';
    };

  };
}