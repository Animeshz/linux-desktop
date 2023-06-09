_: final: prev:

{
  eww = prev.eww.overrideAttrs (o: {
    patches = (o.patches or [ ]) ++ [
      ./root-window-style.patch
    ];
  });
}