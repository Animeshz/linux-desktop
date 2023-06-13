{ bundlerApp }:

bundlerApp {
  pname = "puppet";
  exes = ["puppet" "facter"];
  gemdir = ./.;

  # Not possible when specifying gem with :git
  # See: https://github.com/NixOS/nixpkgs/issues/128223
  installManpages = false;
}