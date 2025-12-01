{
  lib,
  namespace,
  config,
  ...
} @ params:
lib.${namespace}.hyprland.applyAttrOnEnabled params {
  options.${namespace}.hyprland.misc.hyprpanel = let
    inherit (lib) mkEnableOption;
  in {
    enable = mkEnableOption "Enable hyprpanel for hyprland";
  };
  config = let
    inherit (lib) mkIf;
    inherit (config.${namespace}.hyprland.misc) hyprpanel;
  in
    mkIf hyprpanel.enable {
      programs.hyprpanel = {
        enable = true;
        # Configure and theme almost all options from the GUI.
        # See 'https://hyprpanel.com/configuration/settings.html'.
        # Default: <same as gui>
        settings = {
          "theme.bar.menus.monochrome" = false;
          # "wallpaper.pywal" = true;
          # "wallpaper.image" = "/home/cirius/Workspaces/github.com/personal/cirius-nix-v2/assets/wallpaper-4.jpg";
          "theme.matugen" = false;
          "theme.bar.transparent" = false;
          "theme.bar.buttons.style" = "default";
          "theme.font.size" = "1rem";
          terminal = "alacritty -e";
          "bar.layouts" = {
            "0" = {
              left = [
                "dashboard"
                "workspaces"
                "windowtitle"
              ];
              middle = [
                "media"
              ];
              right = [
                "volume"
                "network"
                "bluetooth"
                "systray"
                "notifications"
                "clock"
              ];
            };
          };
          "theme.bar.floating" = true;
          "theme.bar.buttons.enableBorders" = false;
          "theme.bar.border.location" = "none";
          "theme.bar.enableShadow" = false;
          "menus.clock.time.military" = true;
          "menus.clock.time.hideSeconds" = true;
          "menus.clock.weather.location" = "Ho Chi Minh City";
          "menus.clock.weather.key" = "ffff";
          "menus.clock.weather.unit" = "imperial";
          "menus.dashboard.stats.enable_gpu" = true;
          "menus.dashboard.shortcuts.left.shortcut1.tooltip" = "Zen";
          "menus.dashboard.shortcuts.left.shortcut1.command" = "zen";
          "menus.dashboard.shortcuts.left.shortcut3.tooltip" = "Discord";
          "menus.power.showLabel" = true;
        };
      };
      stylix.targets.hyprpanel.enable = true;
    };
}
