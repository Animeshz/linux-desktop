export HOME_MANAGER_BACKUP_EXT := "bak"


build-home:
  nix build '.#homeConfigurations.animesh@framework.activation-script'

switch-home: build-home
  ./result/activate

generations-home:
  @cd ~/.local/state/nix/profiles && ls --color=always -gG --time-style=long-iso --sort time home-manager-*-link \
    | cut -d' ' -f 4- \
    | sed -E 's/home-manager-([[:digit:]]*)-link/: id \1/'


# === WARN: System config application not tested (may break non-nixos systems) ===
build-system:
  nix build '.#homeConfigurations.animesh@framework.activation-script'

switch-system: build-system
  ./result/activate
