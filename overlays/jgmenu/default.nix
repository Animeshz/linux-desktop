_: self: super:

{
  jgmenu = super.jgmenu.overrideAttrs (o: {
    patches = (o.patches or [ ]) ++ [
      # https://github.com/jgmenu/jgmenu/issues/209 (until the merge)
      ./unselected-default.patch
    ];
  });
}
