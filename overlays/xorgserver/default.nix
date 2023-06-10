_: self: super:

{
  # See modules/../xorg.nix
  #
  # xorg = super.xorg // {
  #   xorgserver = super.xorg.xorgserver.overrideAttrs (old: {
  #     configureFlags = old.configureFlags ++ [ "--enable-suid-wrapper" ];
  #     postInstall = old.postInstall + ''
  #       mkdir -p $out/etc/X11
  #       echo "needs_root_rights=yes" >> $out/etc/X11/Xwrapper.config
  #     '';
  #   });
  # };
}
