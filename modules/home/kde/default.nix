params: let
  inherit (params) namespace lib;
  inherit (lib.${namespace}) enumlib intlib;
in
  lib.${namespace}.kde.onEnabled params
  {
    options.${namespace}.kde = {
      themeProfile = enumlib.mkOption ["tahoe" "salute"] "salute" "KDE theme profile to use.";
      numberDesktops = intlib.mkOption 8 "Number of virtual desktops to use.";
      xwaylandScale = enumlib.mkOption [1 1.5 2] 1 "Scale factor for XWayland windows.";
    };
    config = let
      inherit (params) config;
      cfg = config.${namespace}.kde;
      themeProfile = config.${namespace}.kde.themeProfile;
    in {
      ${namespace}.kde.profile.${themeProfile}.enable = lib.mkForce true;
      programs.plasma = {
        enable = true;
        overrideConfig = true;
        immutableByDefault = true;
        windows.allowWindowsToRememberPositions = true;
        workspace = {
          clickItemTo = "open";
        };
        kwin = {};
        kscreenlocker = {
          autoLock = true;
          lockOnResume = true;
          lockOnStartup = false;
          passwordRequired = true;
          passwordRequiredDelay = 3;
          timeout = 1800;
        };
        configFile = {
          "kdeglobals" = {
            "KDE" = {
              "widgetStyle" = "Breeze";
            };
          };
          "klipperrc"."General" = {
            "IgnoreSelection" = false;
            "KeepClipboardContents" = true;
            "SyncClipboard" = true;
          };
          "ksmserverrc"."General"."loginMode" = "emptySession";
          "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
          "kwinrc" = {
            "XWayland"."Scale" = cfg.xwaylandScale;
            "Wayland"."InputMethod" = let
              inputMethodCfg = params.osConfig.i18n.inputMethod;
            in
              lib.mkIf (inputMethodCfg.enable && inputMethodCfg.type == "fcitx5") "${params.pkgs.fcitx5}/share/applications/fcitx5-wayland-launcher.desktop";
            "Desktops"."Number" = {
              value = cfg.numberDesktops;
              immutable = true;
            };
            "Desktops.Rows" = {
              value =
                if cfg.numberDesktops <= 4
                then 1
                else if cfg.numberDesktops <= 8
                then 2
                else 3;
              immutable = true;
            };
          };
        };
      };
    };
  }
