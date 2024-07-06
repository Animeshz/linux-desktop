{ config, lib, ... }:

with lib;
let
  cfg = config.united.languages.android;
in {
  options.united.languages.android.enable = mkEnableOption "android";

  config = mkIf cfg.enable {
    home.sessionVariables = {
      JAVA_HOME = "/usr/lib/jvm/default-jdk";
      ANDROID_HOME = "$HOME/.android-data/Sdk";
      NDK_HOME = "$HOME/.android-data/Ndk";
    };
  };
}


