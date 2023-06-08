{ pkgs, lib, stdenv, ...}:

stdenv.mkDerivation {
  name = "emacs-pcre";
  src = pkgs.sources.emacs-pcre.src;

  nativeBuildInputs = with pkgs; [ emacs gnumake pkg-config pcre ];
  buildPhase = "make all";
  installPhase = ''
    mkdir -p $out/lib
    cp pcre-core.so $out/lib
  '';
}
