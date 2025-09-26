{
  config,
  namespace,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (osConfig.${namespace}.de) hyprland;
  inherit (config.${namespace}.hyprland.plugins) mako;
in
{
  options.${namespace}.hyprland.plugins.mako.enable =
    mkEnableOption "Enable mako notification daemon for hyprland.";
  config = mkIf (hyprland.enable && mako.enable) {
    home.packages = [ pkgs.libnotify ];
    stylix.targets.mako.enable = true;
    services.mako = {
      enable = true;
      settings = {
        anchor = "top-right";
        default-timeout = 5000;
        width = 420;
        height = 110;
        "app-name=Spotify" = {
          invisible = true;
        };
        "mode=do-not-disturb app-name=notify-send" = {
          invisible = false;
        };
        "urgency=critical" = {
          default-timeout = 0;
        };
      };
    };
  };
}
