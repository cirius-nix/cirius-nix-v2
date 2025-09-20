{
  config,
  namespace,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.dev.cli) stat;
in
{
  options.${namespace}.dev.cli.stat = {
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
