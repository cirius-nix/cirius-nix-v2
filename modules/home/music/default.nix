{
  osConfig,
  pkgs,
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}) music;
  inherit (osConfig.${namespace}.de) hyprland;
in
{
  options.${namespace}.music = {
  };
  config = {
    programs.waybar = mkIf hyprland.enable {
      settings = { };
    };
    home.packages = [
      pkgs.ncspot
    ];
  };
}
