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
    home.packages = with pkgs; [
      nodejs_22
      node2nix
    ];
    programs.fish = {
      plugins = [
        {
          name = "nvm";
          inherit (pkgs.fishPlugins.nvm) src;
        }
      ];
    };
    # TODO: Add Nixvim configuration for NodeJS development
    programs.nixvim = {};
  };
}
