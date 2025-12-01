{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}) stylix;
in {
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
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      polarity = "dark";
      fonts = {
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };
        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };
        monospace = {
          package = pkgs.nerd-fonts.caskaydia-mono;
          name = "CaskaydiaMono Nerd Font Propo";
        };
        sizes = {
          terminal = 11;
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };
      opacity = {
        terminal = 0.95;
        desktop = 0.2; # bar & widgets
        popups = 0.8;
      };
      # TODO: move this part to specific config.
      # This required gui enabled.
      targets = {
        font-packages.enable = true;
        fontconfig.enable = true;
      };
    };
  };
}
