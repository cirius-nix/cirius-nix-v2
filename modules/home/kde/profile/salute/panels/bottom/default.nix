{
  config,
  namespace,
  lib,
  ...
}: {
  options.${namespace}.kde.profile.salute.panels.bottom = {
    enable = lib.mkEnableOption "Enable salute profile";
  };
  config = let
    cfg = config.${namespace}.kde.profile.salute.panels.bottom;
    inherit (config.${namespace}.kde.profile.salute) variables;
  in
    lib.mkIf (config.programs.plasma.enable && cfg.enable) {
      programs.plasma.panels = [
        # left
        {
          inherit (variables.panels.bottom) height offset;
          maxLength = 1000;
          location = "bottom";
          alignment = "left";
          lengthMode = "fit";
          hiding = "dodgewindows";
          floating = variables.panels.bottom.offset != 0;
          opacity = "translucent";
          widgets = [
            "org.kde.plasma.clipboard"
            "org.kde.plasma.marginsseparator"
            "org.kde.plasma.colorpicker"
            "org.kde.plasma.marginsseparator"
            {
              name = "org.kde.plasma.icontasks";
              config = {
                General = {
                  launchers = variables.iconLaunchers;
                  groupingStrategy = 0; # 0 does not group, 1 group by name
                  showOnlyCurrentActivity = true;
                  showOnlyCurrentDesktop = false;
                };
              };
            }
          ];
        }
        # center
        {
          inherit (variables.panels.bottom) height offset;
          maxLength = 1000;
          location = "bottom";
          alignment = "center";
          lengthMode = "fit";
          hiding = "dodgewindows";
          floating = variables.panels.bottom.offset != 0;
          opacity = "translucent";
          widgets = [
            {
              name = "org.dhruv8sh.kara";
              config = {
                "general" = {
                  highLightOpacityFull = false;
                  spacing = 8;
                };
                "type2" = {"template" = "%roman";};
              };
            }
          ];
        }
        # right
        {
          inherit (variables.panels.bottom) height offset;
          maxLength = 1000;
          location = "bottom";
          alignment = "right";
          lengthMode = "fit";
          hiding = "dodgewindows";
          floating = variables.panels.bottom.offset != 0;
          opacity = "translucent";
          widgets = [
            {
              name = "plasmusic-toolbar";
              config = {
                General = {
                  # progress bar in panel
                  "mediaProgressInPanel" = true;
                  "panelBackgroundRadius" = 8;
                  # icon
                  "panelIcon" = "view-media-track";
                  "colorsFromAlbumCover" = true;
                  "useAlbumCoverAsPanelIcon" = true;
                  "fallbackToIconWhenArtNotAvailable" = true;
                  # behavioor
                  "showWhenNoMedia" = true;
                  "noMediaText" = "No Media Playing";
                };
              };
            }
            "org.kde.plasma.showdesktop"
          ];
        }
      ];
    };
}
