export HOME_MANAGER_BACKUP_EXT := "bak"


build:
  nix build '.#homeConfigurations.animesh@framework.activation-script'

dry-run: build
  DRY_RUN=1 ./result/activate

switch: build
  ./result/activate

list-generations:
  @cd ~/.local/state/nix/profiles && ls --color=always -gG --time-style=long-iso --sort time home-manager-*-link \
    | cut -d' ' -f 4- \
    | sed -E 's/home-manager-([[:digit:]]*)-link/: id \1/'

# Shows treeview of given folder (also used in generation of README)
treeview arg='.':
  #!/bin/sh
  cd {{arg}} 1>/dev/null
  fd .nix | tree --fromfile --noreport | sed "1s|.*|{{arg}}|"
  cd - 1>/dev/null


# Update all dependencies in nvfetcher.toml
nvfetcher:
  nix run nixpkgs#nvfetcher

# Update all gems in packages/**
bundix:
  #!/bin/sh
  for i in packages/*; do
    cd $i 1>/dev/null
    [ -f Gemfile ] && nix run nixpkgs#bundix -- -l
    cd - 1>/dev/null
  done

