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
        inherit (variables.panels.bottom) height offset minLength maxLength;
        floating = variables.panels.bottom.offset != 0;
        location = "bottom";
        lengthMode = "fit";
        hiding = "dodgewindows";
        alignment = "center";
        opacity = "translucent";
        widgets = [
          "org.kde.plasma.pager"
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
    ];
  };
}
