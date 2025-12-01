{
  namespace,
  lib,
  ...
} @ params:
lib.${namespace}.gnome.applyAttrOnEnabled params
{
  options.${namespace}.gnome = {
  };
  # https://wiki.nixos.org/wiki/GNOME
  config = {
    dconf = {
      settings = let
        inherit (lib.gvariant) mkEmptyArray type;
        normalizeIndex = x:
          if x == 10
          then 0
          else x;
        normalizeIndexStr = x: toString (normalizeIndex x);

        metaIndexShortcuts = lib.foldl' lib.recursiveUpdate {} (builtins.genList
          (i: {
            "switch-to-application-${toString (i + 1)}" = mkEmptyArray type.string;
            "open-new-window-application-${toString (i + 1)}" = mkEmptyArray type.string;
          })
          9);

        navMetaIndexShortcuts = lib.foldl' lib.recursiveUpdate {} (builtins.genList
          (i: {
            "move-to-workspace-${toString (i + 1)}" = ["<Shift><Super>${normalizeIndexStr (i + 1)}"];
            "switch-to-workspace-${toString (i + 1)}" = ["<Super>${normalizeIndexStr (i + 1)}"];
          })
          9);
      in {
        # Launcher & accessibility
        "org/gnome/settings-daemon/plugins/media-keys" = {
          "control-center" = ["<Shift><Super>period"];
          "help" = mkEmptyArray type.string;
          "search" = ["F2"];
          # Launch web browser.
          "www" = ["<Super>B"];
          "screenreader" = mkEmptyArray type.string;
          "magnifier" = mkEmptyArray type.string;
          "magnifier-zoom-in" = ["<Super>equal"];
          "magnifier-zoom-out" = ["<Super>minus"];
          "increase-text-size" = ["<Shift><Super>equal"];
          "decrease-text-size" = ["<Shift><Super>minus"];
        };
        # Shell & screenshot
        "org/gnome/shell/keybindings" =
          {
            "toggle-overview" = ["<Super>"];
            "show-screenshot-ui" = ["<Shift><Super>S"];
            "screenshot" = mkEmptyArray type.string;
            "show-screen-recording-ui" = mkEmptyArray type.string;
            "screenshot-window" = ["<Shift><Super>W"];
          }
          // metaIndexShortcuts;
        # Navigation
        "org/gnome/desktop/wm/keybindings" =
          {
            "switch-applications" = ["<Alt>Tab"];
            "switch-applications-backward" = mkEmptyArray type.string;
            "switch-panels" = mkEmptyArray type.string;
            "switch-panels-backward" = mkEmptyArray type.string;
            "switch-group" = mkEmptyArray type.string;
            "switch-group-backward" = mkEmptyArray type.string;
            "switch-to-workspace-last" = mkEmptyArray type.string;
            "cycle-panels" = mkEmptyArray type.string;
            "cycle-panels-backward" = mkEmptyArray type.string;
            "cycle-windows" = mkEmptyArray type.string;
            "cycle-windows-backward" = mkEmptyArray type.string;
            "cycle-group" = mkEmptyArray type.string;
            "cycle-group-backward" = mkEmptyArray type.string;
            "move-to-monitor-up" = mkEmptyArray type.string;
            "move-to-monitor-down" = mkEmptyArray type.string;
            "move-to-monitor-left" = mkEmptyArray type.string;
            "move-to-monitor-right" = mkEmptyArray type.string;
            "move-to-workspace-left" = mkEmptyArray type.string;
            "move-to-workspace-right" = mkEmptyArray type.string;
            "move-to-workspace-last" = mkEmptyArray type.string;
            "switch-to-workspace-left" = mkEmptyArray type.string;
            "switch-to-workspace-right" = mkEmptyArray type.string;
            "close" = ["<Super>q"];
            "unmaximize" = mkEmptyArray type.string;
            "minimize" = ["<Super>down"];
            "maximize" = ["<Super>up"];
            "begin-move" = mkEmptyArray type.string;
            "begin-resize" = mkEmptyArray type.string;
            "toggle-maximized" = ["<Super>f"];
            "toggle-fullscreen" = ["<Shift><Super>f"];
          }
          // navMetaIndexShortcuts;
      };
    };
  };
}
