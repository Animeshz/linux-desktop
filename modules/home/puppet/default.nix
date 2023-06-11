{ pkgs, lib, config, ... }:

let
  cfg = config.puppet;
in
with lib;
with lib.home-manager;
{
  options = {
    puppet.enable = mkEnableOption "Install and configure kitty";

    puppet.extraModulePaths = mkOption {
      type = types.listOf types.path;
      default = [];
    };

    # Puppet's Resource Abstraction Layer (RAL) states
    puppet.ral = mkOption {
      # resource :: title :: attributes
      type = with types; attrsOf (hm.types.dagOf (attrsOf (oneOf [bool int str])));
      default = {};
      example = ''
        with hm.dag;
        {
          service.adb = entryAnywhere { ensure = "stopped"; };
        }
      '';
      description = ''
        Commands given to Puppet's RAL on activation.
        See `puppet resource -h` for more info.

        Output is puppet resource defn which is impure and depend on system
        state. For example, one may set some user's shell, but other things like
        group are not affected and hence returned what they were.
      '';
    };
  };

  config = mkIf cfg.enable {
    dev.ruby = {
      enable = mkForce true;
      gems = epkgs: [ pkgs.custom.puppet ];
    };

    home.activation.puppetRAL =
      let
        modulePaths = concatStringsSep ":" (["/etc/puppet/modules"] ++ cfg.extraModulePaths);
        sortedRal = hm.dag.topoSort (lib.internal.reduceLevel cfg.ral);

        mkCmd = res:
          let
            identifierSplits = builtins.split "\\." res.name;
            resourceName = builtins.elemAt identifierSplits 0;
            resourceTitle = builtins.elemAt identifierSplits 2;
            resourceAttributes = concatStringsSep " " (map (attr: "${attr}=${toString res.data."${attr}"}") (builtins.attrNames res.data));
          in "${pkgs.custom.puppet}/bin/puppet resource ${resourceName} ${resourceTitle} ${resourceAttributes} --modulepath ${modulePaths}";

        bootstrappingCmds =
          if sortedRal ? result then concatStringsSep "; " (map mkCmd sortedRal.result)
          else abort ("Dependency cycle in activation script: " + builtins.toJSON sortedCommands);
      in
      hm.dag.entryAfter [ "installPackages" ] ''
        export PATH="/run/current-system/sw/bin:/usr/bin:$PATH"
        $DRY_RUN_CMD sudo sh -c -- "${bootstrappingCmds}"
      '';
  };
}