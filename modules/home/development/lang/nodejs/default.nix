{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.development.lang) nodejs;
in {
  options.${namespace}.development.lang.nodejs = {
    enable = mkEnableOption "Enable NodeJS";
  };
  config = mkIf nodejs.enable {
    home.packages = with pkgs; [ nodejs_22 ];
  };
}