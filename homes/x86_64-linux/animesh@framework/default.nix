{ lib, ... }:

with lib;
with lib.internal;
{
  home.stateVersion = "23.05";
  nix.extraOptions = "max-jobs = auto";

  apps.emacs = enabled;

  apps.git = {
    user = "Animesh Sahu";
    email = "animeshsahu19@yahoo.com";
    signingkey = "541C03D55917185E";
  };
}
