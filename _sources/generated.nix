# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  emacs = {
    pname = "emacs";
    version = "63874a8999f3afbae9b1df54f4371fa039319c28";
    src = fetchFromGitHub {
      owner = "Animeshz";
      repo = ".emacs.d";
      rev = "63874a8999f3afbae9b1df54f4371fa039319c28";
      fetchSubmodules = false;
      sha256 = "sha256-5jrsiYeH/1v0/mG7UBTnMC7CL31ObzxMMvmoAtQcI1Y=";
    };
    date = "2023-06-09";
  };
  emacs-pcre = {
    pname = "emacs-pcre";
    version = "bc63431cff76dae6ccbff6470173c96ff037fae7";
    src = fetchFromGitHub {
      owner = "syohex";
      repo = "emacs-pcre";
      rev = "bc63431cff76dae6ccbff6470173c96ff037fae7";
      fetchSubmodules = false;
      sha256 = "sha256-5rluKQb0nJkKbU64EfnN1prvS/y5RL58ApUp79rEr0I=";
    };
    date = "2016-09-04";
  };
}
