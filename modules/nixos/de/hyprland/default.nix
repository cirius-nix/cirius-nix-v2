{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.de) hyprland;
in {
  options.${namespace}.de.hyprland = {
    enable = mkEnableOption "Enable hyprland";
  };
  config = mkIf hyprland.enable {
    ${namespace}.base.sddm.enable = lib.mkForce true;
    environment.systemPackages = with pkgs; [
      hyprland-qtutils
      hyprland-qt-support
      hyprpolkitagent
      libsForQt5.qt5ct
      kdePackages.qt6ct
      kdePackages.qtwayland
      kitty
      alacritty
    ];
    environment.sessionVariables = {
      "QT_QPA_PLATFORM" = "wayland";
      "QT_QPA_PLATFORMTHEME" = "qt6ct";
      "QT_AUTO_SCREEN_SCALE_FACTOR" = "1";
      "QT_WAYLAND_DISABLE_WINDOWDECORATION" = "1";
      "MOZ_LEGACY_PROFILES" = "1";
      "NIXOS_OZONE_WL" = "1";
    };
    programs.hyprland = {
      enable = true;
    };
    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };
}
