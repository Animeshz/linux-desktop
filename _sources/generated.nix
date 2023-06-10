# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  emacs = {
    pname = "emacs";
    version = "b5346f0e48d3623ea46b35e9513ca17ceee43fe7";
    src = fetchFromGitHub {
      owner = "Animeshz";
      repo = ".emacs.d";
      rev = "b5346f0e48d3623ea46b35e9513ca17ceee43fe7";
      fetchSubmodules = false;
      sha256 = "sha256-GX0VvjRoqp5UhoPsQRlUAjpo0OXgyXrhLPJs6DECV/A=";
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
  nix-env-fish = {
    pname = "nix-env-fish";
    version = "7b65bd228429e852c8fdfa07601159130a818cfa";
    src = fetchFromGitHub {
      owner = "lilyball";
      repo = "nix-env.fish";
      rev = "7b65bd228429e852c8fdfa07601159130a818cfa";
      fetchSubmodules = false;
      sha256 = "sha256-RG/0rfhgq6aEKNZ0XwIqOaZ6K5S4+/Y5EEMnIdtfPhk=";
    };
    date = "2021-11-29";
  };
  nvm-fish = {
    pname = "nvm-fish";
    version = "c69e5d1017b21bcfca8f42c93c7e89fff6141a8a";
    src = fetchFromGitHub {
      owner = "jorgebucaran";
      repo = "nvm.fish";
      rev = "c69e5d1017b21bcfca8f42c93c7e89fff6141a8a";
      fetchSubmodules = false;
      sha256 = "sha256-LV5NiHfg4JOrcjW7hAasUSukT43UBNXGPi1oZWPbnCA=";
    };
    date = "2023-04-30";
  };
}
