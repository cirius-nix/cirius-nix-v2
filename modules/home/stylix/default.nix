{
  config,
  namespace,
  lib,
  pkgs,
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
    stylix = {
      enable = true;
      autoEnable = false; # WSL cannot support this.
      image = stylix.wallpaper;
      polarity = "dark";
      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.fira-code;
          name = "FiraCode Nerd Font";
        };
        sizes = {
          terminal = 11;
        };
      };
      opacity.terminal = 0.95;
    };
  };
}
