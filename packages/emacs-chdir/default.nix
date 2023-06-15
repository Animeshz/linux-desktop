{ pkgs, lib, emacsPackages, ...}:

emacsPackages.trivialBuild {
  pname = "emacs-chdir";
  src = pkgs.nvfetcher-sources.emacs-chdir.src;

  preBuild = "make all";
  postInstall = ''
    install chdir-core.so $LISPDIR
  '';
}