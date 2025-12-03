{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
in {
  options.${namespace}.security.enpass = {
    enable = mkEnableOption "Enable enpass password manager";
    autoStart = mkEnableOption "Enable enpass daemon autostart";
  };
  config = let
    cfg = (config.${namespace}.security).enpass;
  in
    mkIf cfg.enable {
      environment.systemPackages = with pkgs; [enpass];
    };
}
