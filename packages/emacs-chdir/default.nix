{ pkgs, lib, emacsPackages, ...}:

emacsPackages.trivialBuild {
  inherit (pkgs.nvfetcher-sources.emacs-chdir) pname version src;

  preBuild = "make all";
  postInstall = ''
    install chdir-core.so $LISPDIR
  '';
}
