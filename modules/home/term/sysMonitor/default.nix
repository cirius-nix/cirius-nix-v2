{
  config,
  namespace,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption;
in {
  options.${namespace}.term.sysMonitor = {
    enable = mkEnableOption "Enable stat CLI tool";
  };
  config = let
    inherit (lib) mkIf;
    cfg = (config.${namespace}.term).sysMonitor;
  in
    mkIf cfg.enable {
      stylix.targets.btop.enable = true;
      home.packages = with pkgs; [
        coreutils
        btop
      ];
    };
}
