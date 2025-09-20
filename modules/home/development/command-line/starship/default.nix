{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.development.command-line) fish starship;
in
{
  options.${namespace}.development.command-line.starship = {
    enable = mkEnableOption "Enable starship";
  };
  config = mkIf starship.enable {
    stylix.targets.starship.enable = true;
    programs.starship = {
      enable = true;
      enableFishIntegration = fish.enable;
    };
  };
}
