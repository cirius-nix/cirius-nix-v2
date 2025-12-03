{
  config,
  namespace,
  lib,
  ...
} @ params:
lib.${namespace}.kde.onEnabled params {
  options.${namespace}.kde.profile.tahoe.panels.top = {
    enable = lib.mkEnableOption "Enable tahoe profile";
  };
  config = let
    cfg = config.${namespace}.kde.profile.tahoe.panels.top;
    inherit (config.${namespace}.kde.profile.tahoe) variables;
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
            "TahoeLauncher"
            "org.kde.plasma.appmenu"
            "org.kde.plasma.panelspacer"
            "org.kde.plasma.systemtray"
            {
              name = "org.kde.plasma.digitalclock";
              config = {};
            }
            "org.kde.plasma.userswitcher"
          ];
        }
      ];
    };
}
