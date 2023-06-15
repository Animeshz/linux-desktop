_: self: super:

{
  nvfetcher-sources = import ../../_sources/generated.nix { inherit (self) fetchurl fetchgit fetchFromGitHub dockerTools; };
}
