{
  namespace,
  lib,
  ...
} @ params:
lib.${namespace}.kde.onEnabled params {
  options.${namespace}.kde.profile.tahoe.variables = {
    # Panels configurations.
    panels = let
      panelOption = default: {
        height = lib.mkOption {
          type = lib.types.int;
          default = lib.attrByPath ["height"] 40 default;
          description = "Panel height/height in pixels.";
        };
        offset = lib.mkOption {
          type = lib.types.int;
          default = lib.attrByPath ["offset"] 8 default;
          description = "Panel offset from screen edge in pixels.";
        };
      };
    in {
      top = panelOption {
        height = 32;
        offset = 0;
      };
      bottom =
        (panelOption {
          height = 64;
        })
        // {
          minLength = lib.mkOption {
            type = lib.types.int;
            default = 500;
            description = "Minimum length of the bottom panel in pixels.";
          };
          maxLength = lib.mkOption {
            type = lib.types.int;
            default = 1000;
            description = "Maximum length of the bottom panel in pixels.";
          };
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
  };
}
