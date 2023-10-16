{ lib, inputs, snowfall-inputs }:

{
  enabled = { enable = true; };
  disabled = { enable = false; };

  reduceLevel = input:
    lib.concatMapAttrs
      (outer: set: builtins.listToAttrs (map
        (inner: { name = "${outer}.${inner}"; value = set."${inner}"; })
        (lib.attrNames set)))
      input;

  nixGLWrapIntel = pkgs: pkg:
    let
      bins = "${pkg}/bin";
    in
    pkgs.buildEnv {
      name = "nixGL-${pkg.name}";
      paths =
        [ pkg ] ++
        (map
          (bin: pkgs.hiPrio (
            pkgs.writeShellScriptBin bin ''
              exec -a "$0" "${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel" "${bins}/${bin}" "$@"
            ''
          ))
          (builtins.attrNames (builtins.readDir bins)));
    };
}
