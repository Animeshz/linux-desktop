{ eww, ... }: self: super:

{
  eww = eww.packages."${self.system}".eww.overrideAttrs (o: {
    patches = (o.patches or [ ]) ++ [
      ./4.patch
    ];
  });
}
