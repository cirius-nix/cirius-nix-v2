{
  pkgs,
  lib,
  osConfig ? {},
  ...
}: let
  namespace = "cirius-v2";
in {
  ${namespace} = lib.${namespace}.kde.onEnabled {inherit namespace pkgs osConfig;} {
    kde = {
      themeProfile = "tahoe";
      profile.tahoe = {
        variables = {
          iconLaunchers = [
            "applications:org.kde.dolphin.desktop"
            "applications:Alacritty.desktop"
            "applications:apidog.desktop"
            "applications:datagrip.desktop"
            "applications:obsidian.desktop"
            "applications:zen-twilight.desktop"
            "applications:spotify.desktop"
          ];
        };
      };
    };
  };
}
