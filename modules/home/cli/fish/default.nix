{ config, lib, pkgs, ... }:

let
  cfg = config.united.cli.fish;
  mkPlugin = name: with pkgs.nvfetcher-sources."${name}"; { name = pname; inherit src; };
in
with lib;
{
  options.united.cli.fish.enable = mkEnableOption "fish";

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
      functions = import ./functions.nix;
      plugins = map (n: mkPlugin n) ["nix-fish" "nvm-fish"];

      shellAbbrs = {
        xi = "sudo xbps-install";
        xp = "sudo xbps-pkgdb";
        xq = "xbps-query -Rs";
        xf = "xbps-query -Rf";
        xx = "xbps-query -Rx";
        xX = "xbps-query -RX";
        xr = "sudo xbps-remove -R";

        ng = "nix store gc --debug";
        nr = "nix registry list";
        npi = "nix profile install";
        npr = "nix profile remove";
        nph = "nix profile history";
      };

      shellInit = ''
        set fish_greeting
      '';
    };

    home.sessionPath = [
      "/usr/bin"
      "/usr/local/bin"
      "/usr/lib/ruby/gems/3.2.0/bin"
      "/opt/flutter/bin"
      "/opt/Telegram"

      "$HOME/.local/bin"
      "$HOME/.yarn/bin"
      "$HOME/.cargo/bin"
      "$HOME/.emacs.d/bin"
      "$HOME/.pub-cache/bin"
      "$HOME/.nix-profile/bin"
      "$HOME/.platformio/penv/bin"

      "$GOPATH/bin"
      "$ANDROID_HOME/emulator"
      "$ANDROID_HOME/tools/bin"
      "$ANDROID_HOME/cmdline-tools/bin"
      "$PNPM_HOME"
    ];

    # TODO: Maybe clean it up sometime later
    home.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
      PKG_CONFIG_PATH = "/usr/lib/pkgconfig";
      ANT_HOME = "/usr/share/apache-ant";                                # for jar builds (mainly emuArm)
      PNPM_HOME = "/home/animesh/.local/share/pnpm";
      RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
      PATH = "$PATH:$(${pkgs.ruby}/bin/gem env 2>/dev/null | ${pkgs.gnugrep}/bin/grep 'EXECUTABLE DIRECTORY' | ${pkgs.gnused}/bin/sed --quiet \"s/.*EXECUTABLE DIRECTORY: \(.*\)/\1/p\"):$(${pkgs.fd}/bin/fd -td -d1 . ~/.scripts 2>/dev/null | tr '\\n' ':')";
    };

    home.shellAliases = {
      sudo = "sudo ";  # Hack to run alias w/sudo: https://askubuntu.com/a/22043/669216 (does not work in fish)
      snvim = "sudo -E nvim";
      nv = "kitty-nopad nvim";
      snv = "sudo -E kitty-nopad nvim";
      hc = "herbstclient";
      tree = "tree -C";
      ":q" = "exit";
      lsblk = "lsblk -o NAME,MODEL,MAJ:MIN,TRAN,FSTYPE,RM,SIZE,RO,LABEL,MOUNTPOINTS";

      # for more aliases, refer inxi module
    };
  };
}
