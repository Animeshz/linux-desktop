_: self: super:

{
  eww = super.eww.overrideAttrs (o: {
    patches = (o.patches or [ ]) ++ [
      # ./root-window-style.patch
    ];
  });
}
