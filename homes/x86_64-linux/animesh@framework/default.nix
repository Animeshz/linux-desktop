{ lib, ... }:

with lib;
with lib.internal;
{
  home.stateVersion = "23.05";

  apps.emacs = enabled;
}
