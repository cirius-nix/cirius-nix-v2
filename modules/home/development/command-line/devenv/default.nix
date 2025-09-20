{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.development.command-line) devenv;
in
{
  options.${namespace}.development.command-line.devenv = {
    enable = mkEnableOption "Enable development environment setup";
  };
  config = mkIf devenv.enable {
    home.packages = [
      pkgs.devenv
    ];
  };
}
