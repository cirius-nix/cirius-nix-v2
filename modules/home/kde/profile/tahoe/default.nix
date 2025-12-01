{
  config,
  namespace,
  lib,
  pkgs,
  inputs,
  ...
} @ params:
lib.${namespace}.kde.onEnabled params {
  options.${namespace}.kde.profile.tahoe.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Tahoe KDE profile.";
  };
  config = let
    cfg = config.${namespace}.kde.profile.tahoe;
    variant = config.stylix.polarity;

    themeDrv = inputs.tahoekde.packages.${pkgs.stdenv.hostPlatform.system}.tahoekde;
    iconDrv = pkgs.${namespace}.tahoeicon.override {inherit variant;};
    launcherDrv = pkgs.${namespace}.tahoelauncher;
    gtkThemeDrv = pkgs.${namespace}.tahoegtk;
  in
    lib.mkIf cfg.enable {
      home.packages =
        (with pkgs; [
          kdePackages.qtstyleplugin-kvantum
          kdePackages.ksystemlog
          kdePackages.qtdeclarative
        ])
        ++ [
          themeDrv
          iconDrv
          launcherDrv
          pkgs.${namespace}.tahoekde
          gtkThemeDrv
        ];
      stylix = {
        targets = {
          qt.enable = lib.mkForce false;
          kde.enable = lib.mkForce false;
          gtk.enable = lib.mkForce false;
        };
        opacity.terminal = lib.mkForce 0.8;
      };
      gtk.theme.name = gtkThemeDrv.themeName;
      programs.plasma = {
        workspace = {
          theme = themeDrv.theme.${variant};
          colorScheme = themeDrv.colorScheme.${variant};
          # FIXME: detected pref issue with kwin lib.
          # windowDecorations = {
          #   library = themeDrv.aurorae.lib;
          #   theme = themeDrv.aurorae.${variant};
          # };
          wallpaper = lib.mkDefault config.stylix.image;
        };
        configFile = {
          "kdeglobals" = {
            "KDE"."widgetStyle" = lib.mkForce "kvantum";
          };
          "kvantum.kvconfig" = {
            "General" = {
              "theme" = themeDrv.kvantum.${variant};
            };
          };
          "kwinrc" = {
            "Effect-blurplus" = {
              "BottomCornerRadius" = 24;
              "TopCornerRadius" = 24;
              "BlurMatching" = false;
              "BlurNonMatching" = true;
              "FakeBlur" = false;
            };
            "EdgeBarrier" = {
              "CornerBarrier" = false;
            };
            "Windows" = {
              "ElectricBorderMaximize" = false;
              "ElectricBorderTiling" = false;
            };
            "Plugins" = {
              "forceblurEnabled" = true;
              "blurEnabled" = false;
              "glideEnabled" = true;
              "magiclampEnabled" = true;
              # True will make blur effect become buggy.
              "wobblywindowsEnabled" = false;
            };
            "org.kde.kdecoration2" = {
              "ButtonsOnLeft" = "XIA";
              "ButtonsOnRight" = "HSM";
            };
          };
        };
      };
    };
}
