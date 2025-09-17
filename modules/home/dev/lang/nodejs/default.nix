{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.dev.lang) nodejs;
in {
  options.${namespace}.dev.lang.nodejs = {
    enable = mkEnableOption "Enable NodeJS";
  };
  config = mkIf nodejs.enable {
    home.packages = with pkgs; [ nodejs_22 ];
  };
}