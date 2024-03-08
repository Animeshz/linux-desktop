{ lib, inputs, snowfall-inputs }:

{
  reduceLevel = input:
    lib.concatMapAttrs
      (outer: set: builtins.listToAttrs (map
        (inner: { name = "${outer}.${inner}"; value = set."${inner}"; })
        (lib.attrNames set)))
      input;

  selectorFunctionOf = type: lib.mkOptionType {
    name = "selectorFunctionOf";
    description = "Function that takes an attribute set and returns a mergable type";
    check = lib.isFunction;
    merge = _loc: defs: as: lib.mkMerge (map (select: select as) (lib.getValues defs));
  };

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
