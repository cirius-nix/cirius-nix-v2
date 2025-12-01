{
  config,
  namespace,
  lib,
  ...
} @ params:
lib.${namespace}.kde.applyAttrOnEnabled params {
  config = let
    inherit (config.${namespace}.kde.profile.tahoe) variables;
  in {
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
