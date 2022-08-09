# To reflect the changes run: "set -e fish_initialized" and open another fish-shell

if not set -q fish_initialized

    abbr nqq notepadqq
    abbr pmem 'sudo ps_mem'

    abbr xi 'sudo xbps-install'
    abbr xp 'sudo xbps-pkgdb'
    abbr xq 'xbps-query -Rs'
    abbr xf 'xbps-query -Rf'
    abbr xx 'xbps-query -Rx'
    abbr xX 'xbps-query -RX'
    abbr xr 'sudo xbps-remove -R'

    # abbr ne 'nix-env'
    abbr nc 'nix-channel --add'
    abbr nu 'nix-channel --update'
    abbr ns 'nix-shell'
    abbr ng 'nix-collect-garbage -d'

    set -U fish_initialized
end
