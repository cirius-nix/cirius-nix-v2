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
    brightness = lib.mkOption {
      type = lib.types.int;
      default = -30;
      description = "Brightness adjustment for dimmed background.";
    };
    contrast = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = "Contrast adjustment for dimmed background.";
    };
    fillColor = lib.mkOption {
      type = lib.types.str;
      default = "black";
      description = "Fill color for dimmed background.";
    };
  };
  config = mkIf stylix.enable {
    stylix = {
      enable = true;
      autoEnable = false; # WSL cannot support this.
      image = stylix.wallpaper;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      polarity = "dark";
      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.caskaydia-mono;
          name = "CaskaydiaMono Nerd Font Propo";
        };
        sizes = {
          terminal = 11;
        };
      };
      opacity = {
        terminal = 0.95;
        desktop = 0.2; # bar & widgets
        popups = 0.8;
      };
    };
  };
}
