{ pkgs, lib, emacsPackages, ...}:

emacsPackages.trivialBuild {
  pname = "emacs-pcre";
  src = pkgs.nvfetcher-sources.emacs-pcre.src;

  nativeBuildInputs = with pkgs; [ pcre ];

  preBuild = "make all";
  postInstall = ''
    install pcre-core.so $LISPDIR
  '';
}
