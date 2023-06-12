# Taken from mix-of:
# - https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/system/etc/etc.nix
# - https://github.com/nix-community/home-manager/blob/master/modules/lib/file-type.nix
#
# Major part from nixpkgs, whereas added force & onChange from home-manager.
#
# Please don't sue me ;P
#
# LICENSE:
# - https://github.com/NixOS/nixpkgs/blob/master/COPYING
# - https://github.com/nix-community/home-manager/blob/master/LICENSE

{ pkgs, lib, config, ... }:

let
  cfgs = config.environment.etc;
in
with lib;
{
  options = {
    environment.etc = mkOption {
      default = {};

      example = literalExpression ''
        { example-configuration-file =
            { source = "/nix/store/.../etc/dir/file.conf.example";
              mode = "0440";
            };
          "default/useradd".text = "GROUP=100 ...";
        }
      '';

      description = lib.mdDoc ''
        Set of files that have to be linked in {file}`/etc`.
      '';

      type = with types; attrsOf (submodule (
        { name, config, options, ... }:
        { options = {

            enable = mkOption {
              type = types.bool;
              default = true;
              description = lib.mdDoc ''
                Whether this /etc file should be generated.  This
                option allows specific /etc files to be disabled.
              '';
            };

            target = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                Name of symlink (relative to
                {file}`/etc`).  Defaults to the attribute
                name.
              '';
            };

            text = mkOption {
              default = null;
              type = types.nullOr types.lines;
              description = lib.mdDoc "Text of the file.";
            };

            source = mkOption {
              type = types.path;
              description = lib.mdDoc "Path of the source file.";
            };

            executable = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = ''
                Set the execute bit. If <literal>null</literal>, defaults to the mode
                of the <varname>source</varname> file or to <literal>false</literal>
                for files created through the <varname>text</varname> option.
              '';
            };

            mode = mkOption {
              type = types.str;
              default = "symlink";
              example = "0600";
              description = lib.mdDoc ''
                If set to something else than `symlink`,
                the file is copied instead of symlinked, with the given
                file mode, and NOTE: executable option is ignored in this case.
              '';
            };

            uid = mkOption {
              default = 0;
              type = types.int;
              description = lib.mdDoc ''
                UID of created file. Only takes effect when the file is
                copied (that is, the mode is not 'symlink').
                '';
            };

            gid = mkOption {
              default = 0;
              type = types.int;
              description = lib.mdDoc ''
                GID of created file. Only takes effect when the file is
                copied (that is, the mode is not 'symlink').
              '';
            };

            user = mkOption {
              default = "+${toString config.uid}";
              type = types.str;
              description = lib.mdDoc ''
                User name of created file.
                Only takes effect when the file is copied (that is, the mode is not 'symlink').
                Changing this option takes precedence over `uid`.
              '';
            };

            group = mkOption {
              default = "+${toString config.gid}";
              type = types.str;
              description = lib.mdDoc ''
                Group name of created file.
                Only takes effect when the file is copied (that is, the mode is not 'symlink').
                Changing this option takes precedence over `gid`.
              '';
            };

            recursive = mkOption {
              type = types.bool;
              default = false;
              description = ''
                If the file source is a directory, then this option
                determines whether the directory should be recursively
                linked to the target location. This option has no effect
                if the source is a file.
                </para><para>
                If <literal>false</literal> (the default) then the target
                will be a symbolic link to the source directory. If
                <literal>true</literal> then the target will be a
                directory structure matching the source's but whose leafs
                are symbolic links to the files of the source directory.
              '';
            };

            # TODO: keep checking https://puppetcommunity.slack.com/archives/C0W298S9G/p1686567665824629
            # onChange = mkOption {
            #   type = types.lines;
            #   default = "";
            #   description = ''
            #     Shell commands to run when file has changed between
            #     generations. The script will be run
            #     <emphasis>after</emphasis> the new files have been linked
            #     into place.
            #     </para><para>
            #     Note, this code is always run when <literal>recursive</literal> is
            #     enabled.
            #   '';
            # };

            force = mkOption {
              type = types.bool;
              default = false;
              description = ''
                Whether the target path should be unconditionally replaced
                by the managed file source. Warning, this will silently
                delete the target regardless of whether it is a file or
                link.
              '';
            };

            # Absolute path, for internal use
            targetEtc = mkOption { type = types.str; internal = true; };
          };

          config = {
            target = mkDefault name;
            targetEtc = "/etc/${config.target}";
            source = mkIf (config.text != null) (
              mkDefault (pkgs.writeTextFile {
                inherit (config) text;
                executable = config.executable == true; # can be null
                name = "etc-" + baseNameOf name;
              })
            );
          };
        }));
    };
  };

  config = {
    puppet.ral = {
      file = lib.concatMapAttrs
        (_: cfg: {
          "${cfg.targetEtc}" = lib.home-manager.hm.dag.entryAnywhere {
            path = cfg.targetEtc;
            source = mkIf (cfg.mode != "symlink") cfg.source;
            target = mkIf (cfg.mode == "symlink") cfg.source;
            recurse = if cfg.recursive then "true" else "false";
            ensure = if (!cfg.enable) then "absent" else if (cfg.mode == "symlink") then "link" else "present";
            backup = "$([ -n \"$HOME_MANAGER_BACKUP_EXT\" ] && echo \".$HOME_MANAGER_BACKUP_EXT\" || echo '')";
            mode = mkIf (cfg.mode != "symlink" || cfg.executable == true) (if (cfg.mode != "symlink") then cfg.mode else "a+x");
            owner = cfg.user;
            group = cfg.group;
            force = if cfg.force then "true" else "false";

            # TODO: keep checking https://puppetcommunity.slack.com/archives/C0W298S9G/p1686567665824629
            # notify = ;
          };
        })
        cfgs;
    };
  };
}