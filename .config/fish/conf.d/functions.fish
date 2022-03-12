# Fork of /usr/share/fish/functions/fish_commandline_prepend.fish @ line 1 allowing meta-characters togglable
# See: https://github.com/fish-shell/fish-shell/issues/8763

function fish_commandline_prepend_full --description 'Prepend the given string to the command-line, or remove the prefix if already there, allowing meta-chars such as pipe to be toggled'
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
end
