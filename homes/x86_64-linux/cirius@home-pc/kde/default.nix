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
      themeProfile = "salute";
      xwaylandScale = 1.5;
      profile.salute = {
        panels = lib.${namespace}.enableAll ["bottom" "top"] {};
        variables = {
          iconLaunchers = [
            "applications:org.kde.dolphin.desktop"
            "applications:Alacritty.desktop"
            "applications:datagrip.desktop"
            "applications:obsidian.desktop"
            "applications:zen-twilight.desktop"
            "applications:spotify.desktop"
          ];
        };
      };
      profile.tahoe = {
        variables = {
          iconLaunchers = [
            "applications:org.kde.dolphin.desktop"
            "applications:Alacritty.desktop"
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
