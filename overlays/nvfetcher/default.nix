_: final: prev:

{
  sources = import ../../_sources/generated.nix { inherit (final) fetchurl fetchgit fetchFromGitHub dockerTools; };
}
