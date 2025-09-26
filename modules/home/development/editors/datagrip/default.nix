{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.development.editors) datagrip;
in
{
  options.${namespace}.development.editors.datagrip = {
    enable = mkEnableOption "Enable datagrip";
  };
  config = mkIf datagrip.enable {
    home.packages = [ pkgs.jetbrains.datagrip ];
  };
}
