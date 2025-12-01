{
  config,
  namespace,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
in {
  options.${namespace}.term.alacritty = {
    enable = mkEnableOption "Enable Alacritty terminal emulator";
  };
  config = let
    cfg = (config.${namespace}.term).alacritty;
  in
    mkIf cfg.enable {
      stylix.targets.alacritty.enable = true;
      programs.alacritty = {
        enable = true;
        settings = {};
      };
    };
}
