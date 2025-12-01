{
  config,
  namespace,
  lib,
  osConfig ? {},
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkStrOption;
  inherit (osConfig.${namespace}.de) hyprland;
  inherit (config.${namespace}.hyprland.plugins) grimshot;
in
{
  options.${namespace}.hyprland.plugins.grimshot = {
    enable = mkEnableOption "Enable grimshot for hyprland";
    editor = mkStrOption "gimp" "Image editor to use after taking a screenshot.";
  };
  config = mkIf (hyprland.enable && grimshot.enable) {
    home.file."Pictures/Screenshots/.keep" = {
      target = "${config.snowfallorg.user.home.directory}/Pictures/Screenshots/.keep";
      text = "";
    };
    home.sessionVariables = {
      GRIMSHOT_EDITOR = grimshot.editor;
    };
    home.packages = [ pkgs.grimblast ];
  };
}
