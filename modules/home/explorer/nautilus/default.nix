{
  pkgs,
  lib,
  config,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.explorer) nautilus;
in
{
  options.${namespace}.explorer.nautilus = {
    enable = mkEnableOption "Enable Nautilus file manager.";
  };
  config = mkIf (nautilus.enable) {
    home.packages = [ pkgs.nautilus ];
  };
}
