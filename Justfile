export HOME_MANAGER_BACKUP_EXT := "bak"


build-home:
  nix build '.#homeConfigurations.animesh@framework.activation-script'

switch-home arg='': build-home
  #!/bin/sh
  [ '{{arg}}' = '--dry-run' ] && export DRY_RUN=1
  ./result/activate

generations-home:
  @cd ~/.local/state/nix/profiles && ls --color=always -gG --time-style=long-iso --sort time home-manager-*-link \
    | cut -d' ' -f 4- \
    | sed -E 's/home-manager-([[:digit:]]*)-link/: id \1/'


# === WARN: System config application not tested (may break non-nixos systems) ===
build-system:
  nix run 'github:Animeshz/system-manager/system_packages' -- build --flake .

switch-system: build-system
  sudo ./result/bin/activate


nvfetcher:
  nix run nixpkgs#nvfetcher

bundix:
  #!/bin/sh
  for i in packages/*; do
    cd $i 1>/dev/null
    [ -f Gemfile ] && nix run nixpkgs#bundix -- -l
    cd - 1>/dev/null
  done

treeview arg='.':
  #!/bin/sh
  cd {{arg}} 1>/dev/null
  fd .nix | tree --fromfile --noreport | sed "1s|.*|{{arg}}|"
  cd - 1>/dev/null
