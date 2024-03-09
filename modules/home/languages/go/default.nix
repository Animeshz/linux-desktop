{ config, lib, ... }:

with lib;
let
  cfg = config.united.languages.go;
in {
  options.united.languages.go.enable = mkEnableOption "go";

  config = mkIf cfg.enable {
    home.sessionVariables = {
      GOROOT = "/usr/lib/go";
      GOPATH = "$HOME/.go";
    };
  };
}

