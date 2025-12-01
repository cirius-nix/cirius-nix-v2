{
  config,
  namespace,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
in {
  options.${namespace}.term.starship = {
    enable = mkEnableOption "Enable starship";
  };
  config = let
    inherit (config.${namespace}) term;
  in
    mkIf term.starship.enable {
      stylix.targets.starship.enable = true;
      programs.starship = {
        enable = true;
        enableFishIntegration = config.programs.fish.enable;
      };
    };
}
