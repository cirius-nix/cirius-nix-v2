{
  lib,
  config,
  namespace,
  ...
} @ inputs:
lib.${namespace}.hyprland.applyAttrOnEnabled inputs {
  options.${namespace}.hyprland.monitor = let
    inherit (lib.${namespace}) mkListOption mkStrOption mkEnumOption;
    monitorEntryType = lib.types.submodule {
      options = {
        output = mkStrOption "" "Name of the monitor.";
        disabled = mkEnumOption [0 1] 0 "Disable the monitor (0=enabled, 1=disabled).";
        mode = mkStrOption "preferred" "Resolution of the monitor.";
        position = mkStrOption "0x0" "Position of the monitor.";
        scale = mkStrOption "1.0" "Scale of the monitor.";
        transform = mkEnumOption [0 1 2 3 4 5 6 7] 0 "Transform of normal,90,180,270,flipped,flipped-90,flipped-180,flipped-270";
        cm = mkEnumOption ["auto" "srgb" "dcip3" "dp3" "adobe" "wide" "edid" "hdr" "hdredid"] "auto" "Color mode of the monitor.";
        apps = mkListOption lib.types.str [] "List of application IDs to open on this monitor.";
      };
    };
  in {
    list = mkListOption monitorEntryType [] "List of monitors to config.";
  };
  config = let
    monitorList = config.${namespace}.hyprland.monitor.list;
    allApps = config.${namespace}.hyprland.app.list;
  in {
    wayland.windowManager.hyprland.settings = {
      monitor = let
        mapFn = e:
          if e.disabled == 1
          then "${e.output}, disable"
          else null;
        disabledMonitors = lib.filter (x: x != null) (builtins.map mapFn monitorList);
      in
        disabledMonitors;
      monitorv2 = let
        mapFn = e: {inherit (e) output mode position scale transform cm;};
        definitions = builtins.map mapFn monitorList;
      in
        definitions;
      workspace = let
        inherit (lib.${namespace}.hyprland) getAppById;
        # Map one monitor to its workspace entries
        monitorToWorkspaces = monitorIndex: monitor: let
          appEntries =
            lib.imap (
              index: appId: let
                app = getAppById appId allApps;
                entryIndex = builtins.toString ((monitorIndex - 1) * 10 + index);
              in "${entryIndex}, monitor:${monitor.output}, defaultName:${app.wsName}, on-created-empty:${
                if app.command != ""
                then app.command
                else app.id
              }"
            )
            monitor.apps;
        in
          if monitor.disabled == 1
          then []
          else appEntries;
      in
        builtins.concatLists (lib.imap monitorToWorkspaces monitorList);
    };
  };
}
