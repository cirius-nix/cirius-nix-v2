params: let
  inherit (params) namespace lib;
in
  lib.${namespace}.kde.onEnabled params {
    options.${namespace}.kde.profile.salute.variables = {
      # Panels configurations.
      panels = {
        top = lib.${namespace}.kde.panel.mkOption {
          height = 32;
          offset = 0;
        };
        bottom = lib.${namespace}.kde.panel.mkOption {
          height = 32;
        };
      };
      iconLaunchers = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "applications:org.kde.dolphin.desktop"
          "applications:org.kde.konsole.desktop"
        ];
        description = "List of application launchers to include in the bottom panel.";
      };
      themeDrv = lib.mkOption {
        type = lib.types.package;
        default = params.pkgs.${namespace}.leafkde;
        description = "Theme drv to use for the salute profile.";
      };
      iconDrv = lib.mkOption {
        type = lib.types.package;
        default = params.pkgs.${namespace}.monochromeicon;
        description = "Icon drv to use for the salute profile.";
      };
    };
  }
