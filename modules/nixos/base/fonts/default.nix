{
  pkgs,
  config,
  lib,
  namespace,
  ...
}: {
  options.${namespace}.base.fonts = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable default font packages.";
    };
  };
  config = lib.mkIf config.${namespace}.base.fonts.enable {
    stylix = {
      targets.font-packages.enable = true;
      targets.fontconfig.enable = true;
    };
    fonts.packages = with pkgs; [
      nerd-fonts.caskaydia-mono
      dejavu_fonts
      noto-fonts-color-emoji
    ];
  };
}
