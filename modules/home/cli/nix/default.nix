_:
{
  imports = [
    ./pin-inputs.nix
    ./setup-comma.nix
  ];

  nix.extraOptions = "max-jobs = auto";
}
