{ pkgs, lib, emacsPackages, ...}:

emacsPackages.trivialBuild {
  inherit (pkgs.nvfetcher-sources.emacs-pcre) pname version src;

  nativeBuildInputs = with pkgs; [ pkg-config pcre ];

  preBuild = "make all";
  postInstall = ''
    install pcre-core.so $LISPDIR
  '';
}
