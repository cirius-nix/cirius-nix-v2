{
  config,
  namespace,
  lib,
  pkgs,
  ...
} @ params:
lib.${namespace}.hyprland.applyAttrOnEnabled params {
  options.${namespace}.hyprland.misc.mako.enable = let
    inherit (lib) mkEnableOption;
  in
    mkEnableOption "Enable mako notification daemon for hyprland.";
  config = let
    inherit (lib) mkIf;
    inherit (config.${namespace}.hyprland.misc) mako;
  in
    mkIf mako.enable {
      home.packages = [pkgs.libnotify];
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
