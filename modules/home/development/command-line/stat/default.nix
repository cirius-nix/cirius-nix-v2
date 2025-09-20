{
  config,
  namespace,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.development.command-line) stat;
in
{
  options.${namespace}.development.command-line.stat = {
    enable = mkEnableOption "Enable stat CLI tool";
  };
  config = mkIf stat.enable {
    stylix.targets.btop.enable = true;
    home.packages = with pkgs; [
      coreutils
      btop
    ];
  };
}
