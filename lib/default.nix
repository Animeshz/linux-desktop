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
}
