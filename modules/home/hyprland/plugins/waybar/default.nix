{
  config,
  osConfig,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (osConfig.${namespace}.de) hyprland;
  hyprlandHome = config.${namespace}.hyprland;
  inherit (config.${namespace}.hyprland.plugins) waybar;
  inherit (config.${namespace}.hyprland) workspace;

in
{
  options.${namespace}.hyprland.plugins.waybar = {
    enable = mkEnableOption "Enable waybar for hyprland";
  };
  config = mkIf (hyprland.enable && waybar.enable) {
    stylix = {
      targets = {
        waybar = {
          enable = true;
          addCss = true;
          enableCenterBackColors = false;
          enableLeftBackColors = true;
          enableRightBackColors = true;
          font = "monospace";
        };
      };
    };
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          output = [ "DP-3" ];
          modules-left = [
            "custom/menu"
            "hyprland/workspaces"
          ];
          modules-center = [
            "clock"
          ];
          modules-right = [
            "network"
            "bluetooth"
            "cpu"
            "pulseaudio"
          ];

          "custom/menu" = {
            "format" = "<span font='nf-md-nix'>󱄅</span>";
            "on-click" = hyprlandHome.aliases.launchMenu;
          };
          "hyprland/workspaces" = {
            on-click = "activate";
            "format" = "{icon}";
            "format-icons" =
              let
                toIconMap = entry: {
                  name = toString entry.idx;
                  value = entry.icon;
                };
              in
              lib.foldl' lib.recursiveUpdate
                {
                  "urgent" = "";
                  "active" = "";
                  "default" = "";
                }
                [
                  (builtins.listToAttrs (map toIconMap workspace.onEmpty))
                ];
            "persistent-workspaces" = {
              "1" = [ ];
              "2" = [ ];
              "3" = [ ];
              "4" = [ ];
              "5" = [ ];
            };
          };
          "wlr/taskbar" = {
            all-outputs = false;
            icon-limit = 30;
            max-length = 40;
            format = "{icon}";
            icon-theme = config.gtk.iconTheme.name;
          };
          "network" = {
            "format-icons" = [
              "󰤯"
              "󰤟"
              "󰤢"
              "󰤥"
              "󰤨"
            ];
            "format" = "{icon}";
            "format-wifi" = "{icon}";
            "format-ethernet" = "󰀂";
            "format-disconnected" = "󰤮";
            "tooltip-format-wifi" = "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
            "tooltip-format-ethernet" = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
            "tooltip-format-disconnected" = "Disconnected";
            "interval" = 3;
            "spacing" = 1;
            "on-click" = hyprlandHome.aliases.launchWifiSelector;
          };
          "bluetooth" = {
            "format" = "";
            "format-disabled" = "󰂲";
            "format-connected" = "";
            "tooltip-format" = "Devices connected: {num_connections}";
            "on-click" = hyprlandHome.aliases.launchBluetoothManager;
          };
          "cpu" = {
            "interval" = 5;
            "format" = "󰍛";
            "on-click" = hyprlandHome.aliases.launchBtop;
          };
          "pulseaudio" = {
            "format" = "{icon} ";
            "on-click" = hyprlandHome.aliases.launchAudioVisualizer;
            "on-click-right" = hyprlandHome.aliases.launchAudioManager;
            "tooltip-format" = "Playing at {volume}%";
            "scroll-step" = 5;
            "format-muted" = "";
            "format-icons" = {
              "default" = [
                ""
                ""
                ""
              ];
            };
          };
          "clock" = {
            "format" = "{:L%A %H:%M}";
            "format-alt" = "{:L%d %B W%V %Y}";
            "tooltip" = false;
            "on-click-right" = hyprlandHome.aliases.launchCalendar;
          };
        };
      };
      # TODO: extract these color from stylix.
      style = ''
        #workspaces button {
          border: 0px;
          padding: 0px 6px;
          margin: 4px;
          border-radius: 50%;
          background-color: transparent;
        }
      '';
      systemd = {
        enableDebug = false;
        # https://developer.gnome.org/documentation/tools/inspector.html
        enableInspect = true;
      };
    };
  };
}
