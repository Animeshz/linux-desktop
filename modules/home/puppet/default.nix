{ pkgs, lib, config, ... }:

let
  cfg = config.puppet;
in
with lib;
with lib.home-manager;
{
  imports = [ ./etc.nix ];

  options = {
    puppet.enable = mkEnableOption "Install and configure puppet";

    puppet.extraModulePaths = mkOption {
      type = types.listOf types.path;
      default = [];
    };

    # Puppet's Resource Abstraction Layer (RAL) states
    puppet.ral = mkOption {
      # resource :: title :: attributes
      type = with types; attrsOf (hm.types.dagOf (attrsOf (oneOf [bool int str path])));
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

    puppet.facts = mkOption {
      type = with types; attrsOf str;
      default = {};
    };
  };

  config = mkIf cfg.enable {
    apps.dev.ruby = {
      enable = mkForce true;
      gems = epkgs: [ pkgs.custom.puppet ];
    };

    home.activation.puppetRAL =
      let
        stringEscape = lib.strings.escape ["\"" "'"];

        modulePaths = concatStringsSep ":" (["/etc/puppet/modules"] ++ cfg.extraModulePaths);
        sortedRal = hm.dag.topoSort (lib.internal.reduceLevel cfg.ral);

        factsDir = pkgs.runCommand "puppet-facts" {} ''
          mkdir -p $out

          ${concatStringsSep "\n"
            (map
              (fact: ''echo 'Facter.add("${fact}") do setcode "${stringEscape cfg.facts."${fact}"}" end' > $out/${fact}.rb'')
              (builtins.attrNames cfg.facts))}
        '';

        mkResource = res:
          let
            resourceName = builtins.elemAt (builtins.split "\\." res.name) 0;
            nameLen = builtins.stringLength resourceName;
            resourceTitle = builtins.substring (nameLen + 1) ((builtins.stringLength res.name) - nameLen - 1) res.name;
            resourceAttributes = concatStringsSep ","
              (map
                (attr: "${attr} => \"${toString res.data."${attr}"}\"")
                (builtins.attrNames res.data));
          in "${resourceName} { '${resourceTitle}': ${resourceAttributes} }";

        resourceFile = pkgs.writeText "manifest.puppet"
          (if sortedRal ? result then concatStringsSep "\n" (map mkResource sortedRal.result)
           else abort ("Dependency cycle in activation script: " + builtins.toJSON sortedCommands));

      in hm.dag.entryBetween [ "dconfSettings" ] [ "installPackages" ] ''
        export PATH="/run/current-system/sw/bin:/usr/bin:$PATH"
        export FACTERLIB="${factsDir}"

        if [[ -v DRY_RUN ]]; then
          ${pkgs.custom.puppet}/bin/puppet apply ${resourceFile} --modulepath ${modulePaths} --noop
        else
          sudo -E ${pkgs.custom.puppet}/bin/puppet apply ${resourceFile} --modulepath ${modulePaths}
        fi
      '';
  };
}
