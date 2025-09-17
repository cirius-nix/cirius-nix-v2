{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.dev.cli) fish starship;
in
{
  options.${namespace}.dev.cli.starship = {
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
