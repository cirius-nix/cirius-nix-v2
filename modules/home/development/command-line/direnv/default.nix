{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.development.command-line) direnv;
in
{
  options.${namespace}.development.command-line.direnv = {
    enable = mkEnableOption "Enable Direnv";
  };
  config = mkIf direnv.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
