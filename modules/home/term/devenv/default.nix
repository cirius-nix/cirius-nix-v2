{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption;
in {
  options.${namespace}.term.devenv = {
    enable = mkEnableOption "Enable development environment setup";
  };
  config = let
    inherit (lib) mkIf;
    cfg = config.${namespace}.term.devenv;
  in
    mkIf cfg.enable {
      home.packages = [
        pkgs.devenv
      ];
    };
}
