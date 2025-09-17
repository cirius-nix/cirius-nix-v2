{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}) stylix;
in
{
  options.${namespace}.stylix = {
    enable = mkEnableOption "Enable default stylix configuration.";
    wallpaper = lib.mkOption {
      type = lib.types.path;
      default = null;
      description = "Path to wallpaper image.";
    };
  };
  config = mkIf stylix.enable {
    stylix.enable = true;
    # harmful for wsl
    stylix.autoEnable = false;
    stylix.image = stylix.wallpaper;
    stylix.polarity = "dark";
  };
}
