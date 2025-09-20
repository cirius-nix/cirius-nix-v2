{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.term) alacritty;
in
{
  options.${namespace}.term.alacritty = {
    enable = mkEnableOption "Enable Alacritty terminal emulator";
  };
  config = mkIf alacritty.enable {
    stylix.targets.alacritty.enable = true;
    programs.alacritty = {
      enable = true;
      settings = { };
    };
  };
}
