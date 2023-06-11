{ pkgs, lib, config, ... }:

with lib;
let
  dynamicExports = config.lib.shell.exportAll config.home.dynamicSessionVariables;
  fishDynamicExports = concatStringsSep "\n" (attrValues (mapAttrs (var: value: "set -gx ${var} \"${value}\"") config.home.dynamicSessionVariables));
in
{
  options = {
    home.dynamicSessionVariables = mkOption {
      type = with types; lazyAttrsOf (oneOf [ str path int float ]);
      default = {};
    };
  };

  config = {
    programs.bash.initExtra = dynamicExports;
    programs.zsh.initExtra = dynamicExports;
    programs.fish.interactiveShellInit = fishDynamicExports;
  };
}