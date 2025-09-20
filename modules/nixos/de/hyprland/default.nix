{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.de) hyprland;
in
{
  options.${namespace}.de.hyprland = {
    enable = mkEnableOption "Enable hyprland";
  };
  config = mkIf hyprland.enable {
    environment.systemPackages = [
      pkgs.hyprland-qtutils
      pkgs.hyprland-qt-support
      pkgs.hyprpolkitagent
    ];
    environment.variables = {
      # TODO: use hyprqt6engine instead
      "QT_QPA_PLATFORMTHEME" = "qt6ct";
      "MOZ_LEGACY_PROFILES" = "1";
    };
    programs.hyprland = {
      enable = true;
    };
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };
}
