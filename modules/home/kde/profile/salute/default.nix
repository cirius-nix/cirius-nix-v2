{
  namespace,
  lib,
  config,
  pkgs,
  ...
}: {
  options.${namespace}.kde.profile.salute = {
    enable = lib.mkEnableOption "Enable salute profile";
  };
  config = let
    cfg = config.${namespace}.kde.profile.salute;
    inherit (cfg.variables) themeDrv iconDrv;
    variant = lib.${namespace}.ifNull config.stylix.polarity "dark";
    wallpaper = "${themeDrv}/${themeDrv.wallpaper.${variant}}";
    base16Scheme =
      if variant == "dark"
      then "${pkgs.base16-schemes}/share/themes/espresso.yaml"
      else "${pkgs.base16-schemes}/share/themes/atelier-forest-light.yaml";
  in
    lib.mkIf (pkgs.stdenv.isLinux && cfg.enable && config.programs.plasma.enable) {
      home.packages = [themeDrv iconDrv];
      stylix = {
        # stop to use stylix themes.
        targets = lib.${namespace}.mustDisableAll ["qt" "kde" "gtk"] {};
        image = lib.mkForce wallpaper;
        base16Scheme = lib.mkForce base16Scheme;
      };
      programs.plasma = {
        workspace = {
          iconTheme = iconDrv.theme;
          theme = themeDrv.theme;
          # plasma-apply-lookandfeel --list
          lookAndFeel = themeDrv.lookAndFeel.${variant};
          # colors
          colorScheme = themeDrv.colorScheme.${variant};

          # see $HOME/.config/kwinrc
          windowDecorations = {
            library = themeDrv.decoration.lib;
            theme = themeDrv.decoration.${variant};
          };
          # see $HOME/.config/ksplashrc
          inherit (themeDrv) splashScreen;
          inherit wallpaper;
        };
        configFile = {
          "kdeglobals"."KDE"."widgetStyle" = "Breeze";
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
              "wobblywindowsEnabled" = lib.mkForce false;
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
