{ config, lib, ... }:

with lib;
let
  cfg = config.united.languages.android;
in {
  options.united.languages.android.enable = mkEnableOption "android";

  config = mkIf cfg.enable {
    home.sessionVariables = {
      ANDROID_HOME = "$HOME/.android-data/Sdk";
      NDK_HOME = "$HOME/.android-data/Ndk";
    };
  };
}


