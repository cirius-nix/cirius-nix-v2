{
  config,
  namespace,
  lib,
  ...
}: {
  options.${namespace}.kde.profile.salute.panels.top = {
    enable = lib.mkEnableOption "Enable salute profile";
    windowTitleUndefined = lib.${namespace}.strlib.mkOption "KDE Plasma" "Window title bar appearance when no window is focused";
  };
  config = let
    cfg = config.${namespace}.kde.profile.salute.panels.top;
    inherit (config.${namespace}.kde.profile.salute) variables;
  in
    lib.mkIf (config.programs.plasma.enable && cfg.enable) {
      programs.plasma.panels = [
        {
          inherit (variables.panels.top) height offset;
          location = "top";
          lengthMode = "fill";
          alignment = "center";
          floating = variables.panels.top.offset != 0;
          opacity = "translucent";
          widgets = [
            "org.kde.plasma.kickerdash"
            "org.kde.plasma.marginsseparator"
            {
              name = "com.github.antroids.application-title-bar";
              config = {
                Appearance = {
                  inherit (cfg) windowTitleUndefined;
                  "widgetElementsDisabledMode" = "Hide";
                  "widgetElements" = [
                    "windowIcon"
                    "windowTitle"
                  ];
                  "windowTitleFontSize" = 10;
                  "overrideElementsMaximized" = true;
                  "widgetElementsMaximized" = [
                    "windowCloseButton"
                    "windowMaximizeButton"
                    "windowMinimizeButton"
                    "windowIcon"
                    "windowTitle"
                  ];
                };
              };
            }
            "org.kde.plasma.marginsseparator"
            "org.kde.plasma.appmenu"
            # "org.kde.plasma.panelspacer"
            "luisbocanegra.panelspacer.extended"
            {
              name = "org.kde.plasma.systemtray";
              config = {
                "General" = {
                  extraItems = [
                    "org.kde.plasma.cameraindicator"
                    "org.kde.plasma.clipboard"
                    "org.kde.plasma.devicenotifier"
                    "org.kde.plasma.weather"
                    "org.kde.kdeconnect"
                    "org.kde.plasma.keyboardindicator"
                    "org.kde.plasma.notifications"
                    "org.kde.plasma.trash"
                  ];
                  shownItems = [
                    "org.kde.kdeconnect"
                    "org.kde.plasma.keyboardindicator"
                    "Fcitx"
                    "org.kde.plasma.notifications"
                  ];
                  hiddenItems = ["blueman"];
                  disabledStatusNotifiers = [
                    "org.kde.plasma.cameraindicator"
                    "org.kde.plasma.clipboard"
                  ];
                  knownItems = [
                    "org.kde.plasma.cameraindicator"
                    "org.kde.plasma.clipboard"
                    "org.kde.plasma.manage-inputmethod"
                    "org.kde.plasma.keyboardlayout"
                    "org.kde.plasma.bluetooth"
                    "org.kde.kdeconnect"
                    "org.kde.plasma.devicenotifier"
                    "org.kde.plasma.notifications"
                    "org.kde.plasma.mediacontroller"
                    "org.kde.plasma.brightness"
                    "org.kde.plasma.weather"
                    "org.kde.kscreen"
                    "org.kde.plasma.volume"
                    "org.kde.plasma.battery"
                    "org.kde.plasma.networkmanagement"
                    "org.kde.plasma.keyboardindicator"
                  ];
                };
              };
            }
            "org.kde.plasma.marginsseparator"
            {
              name = "kdeControlStation";
              config = {
                "Appearance" = {
                  "animations" = true;
                  "darkTheme" = variables.themeDrv.lookAndFeel.dark;
                  "lightTheme" = variables.themeDrv.lookAndFeel.light;
                  "brightness_widget_thin" = true;
                  "showSessionActions" = false;
                  "transparency" = true;
                  "volume_widget_thin" = true;
                };
              };
            }
            "org.kde.plasma.digitalclock"
          ];
        }
      ];
    };
}
