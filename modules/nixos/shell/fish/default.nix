{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.shell) fish;
in
{
  options.${namespace}.shell.fish = {
    enable = mkEnableOption "Enable Fish Shell";
  };
  config = mkIf fish.enable {
    stylix.targets.fish.enable = true;
    programs.fish = {
      enable = true;
    };
  };
}
