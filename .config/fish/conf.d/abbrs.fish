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


    # === NIX START ===

    # abbr ne 'nix-env'
    abbr nc 'nix-channel --add'
    abbr nu 'nix-channel --update'
    abbr ns 'nix-shell'
    abbr ng 'nix-collect-garbage -d'
    abbr no 'nix store optimise'

    abbr nr 'nix registry list'
    abbr npi 'nix profile install'
    abbr npr 'nix profile remove'
    abbr nph 'nix profile history'
    abbr nproll 'nix profile rollback --to'

    abbr nfs 'nix shell'
    abbr nfr 'nix run'
    abbr nfd 'nix develop'

    abbr nfshow 'nix flake show'
    abbr nfmeta 'nix flake metadata'

    # === NIX END ===


    set -U fish_initialized
end
