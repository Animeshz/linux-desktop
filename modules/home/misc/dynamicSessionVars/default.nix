{ pkgs, lib, config, ... }:

with lib;
let
  dynamicExports = config.lib.shell.exportAll config.misc.dynamicSessionVariables;
  fishDynamicExports = concatStringsSep "\n" (attrValues (mapAttrs (var: value: "set -gx ${var} \"${value}\"") config.misc.dynamicSessionVariables));
in
{
  options = {
    # Session variables which may include a shell command, that readily need
    # to refresh on shell startup (rather than applied once at tty login).
    misc.dynamicSessionVariables = mkOption {
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