{ bundlerApp }:

bundlerApp {
  pname = "puppet";
  exes = ["puppet" "facter"];
  gemdir = ./.;
}