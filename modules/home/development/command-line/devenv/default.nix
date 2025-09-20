{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.dev.cli) devenv;
in
{
  options.${namespace}.dev.cli.devenv = {
    enable = mkEnableOption "Enable development environment setup";
  };
  config = mkIf devenv.enable {
    home.packages = [
      pkgs.devenv
    ];
  };
}
