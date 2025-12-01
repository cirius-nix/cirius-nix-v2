{
  config,
  namespace,
  lib,
  ...
} @ params:
lib.${namespace}.kde.onEnabled params {
  options.${namespace}.kde = {
    disableDefaultShortcuts = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Disable default KDE Plasma shortcuts.";
    };
  };
  config = lib.mkIf config.${namespace}.kde.disableDefaultShortcuts {
    programs.plasma = {
      shortcuts = let
        taskManagerEntryShortcuts = builtins.listToAttrs (
          map (
            i: let
              key = "activate task manager entry ${toString i}";
              value = "none";
            in {
              name = key;
              value = value;
            }
          ) (builtins.genList (i: i + 1) 10)
        );
      in {
        "services/org.kde.konsole.desktop"."_launch" = "None";
        "kwin" = let
          keys =
            [
              "Activate Window Demanding Attention"
              "Cycle Overview"
              "Cycle Overview Opposite"
              "Decrease Opacity"
              "Edit Tiles"
              "Expose"
              "ExposeAll"
              "ExposeClass"
              "ExposeClassCurrentDesktop"
              "Grid View"
              "Increase Opacity"
              "Kill Window"
              "Move Tablet to Next Output"
              "MoveMouseToCenter"
              "MoveMouseToFocus"
              "MoveZoomDown"
              "MoveZoomLeft"
              "MoveZoomRight"
              "MoveZoomUp"
              "Overview"
              "Setup Window Shortcut"
              "Show Desktop"
              "Switch One Desktop Down"
              "Switch One Desktop Up"
              "Switch One Desktop to the Left"
              "Switch One Desktop to the Right"
              "Switch Window Down"
              "Switch Window Left"
              "Switch Window Right"
              "Switch Window Up"
            ]
            ++ (let
              gen = n: builtins.genList (x: "${n} ${toString (x + 1)}") 20;
            in
              builtins.concatLists [
                (gen "Switch to Desktop")
                (gen "Window to Desktop")
                (gen "Window to Screen")
                (gen "Switch to Screen")
              ])
            ++ [
              "Switch to Next Desktop"
              "Switch to Next Screen"
              "Switch to Previous Desktop"
              "Switch to Previous Screen"
              "Switch to Screen Above"
              "Switch to Screen Below"
              "Switch to Screen to the Left"
              "Switch to Screen to the Right"
              "Toggle Night Color"
              "Toggle Window Raise/Lower"
              "Walk Through Windows"
              "Walk Through Windows (Reverse)"
              "Walk Through Windows Alternative"
              "Walk Through Windows Alternative (Reverse)"
              "Walk Through Windows of Current Application"
              "Walk Through Windows of Current Application (Reverse)"
              "Walk Through Windows of Current Application Alternative"
              "Walk Through Windows of Current Application Alternative (Reverse)"
              "Window Above Other Windows"
              "Window Below Other Windows"
              "Window Close"
              "Window Custom Quick Tile Bottom"
              "Window Custom Quick Tile Left"
              "Window Custom Quick Tile Right"
              "Window Custom Quick Tile Top"
              "Window Fullscreen"
              "Window Grow Horizontal"
              "Window Grow Vertical"
              "Window Lower"
              "Window Maximize"
              "Window Maximize Horizontal"
              "Window Maximize Vertical"
              "Window Minimize"
              "Window Move"
              "Window Move Center"
              "Window No Border"
              "Window On All Desktops"
              "Window One Desktop Down"
              "Window One Desktop Up"
              "Window One Desktop to the Left"
              "Window One Desktop to the Right"
              "Window One Screen Down"
              "Window One Screen Up"
              "Window One Screen to the Left"
              "Window One Screen to the Right"
              "Window Operations Menu"
              "Window Pack Down"
              "Window Pack Left"
              "Window Pack Right"
              "Window Pack Up"
              "Window Quick Tile Bottom"
              "Window Quick Tile Bottom Left"
              "Window Quick Tile Bottom Right"
              "Window Quick Tile Left"
              "Window Quick Tile Right"
              "Window Quick Tile Top"
              "Window Quick Tile Top Left"
              "Window Quick Tile Top Right"
              "Window Raise"
              "Window Resize"
              "Window Shrink Horizontal"
              "Window Shrink Vertical"
              "Window to Next Desktop"
              "Window to Next Screen"
              "Window to Previous Desktop"
              "Window to Previous Screen"
              "disableInputCapture"
              "view_actual_size"
              "view_zoom_in"
              "view_zoom_out"
            ];
        in
          builtins.listToAttrs (
            map (
              key: {
                name = key;
                value = "none";
              }
            )
            keys
          );
        "plasmashell" =
          {
            "manage activities" = "none";
          }
          // taskManagerEntryShortcuts;
      };
    };
  };
}
