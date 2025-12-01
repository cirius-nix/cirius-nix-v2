{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  enpassCfg = (config.${namespace}.security).enpass;
in {
  options.${namespace}.security.enpass = {
    enable = mkEnableOption "Enable enpass password manager";
  };
  config = mkIf enpassCfg.enable ({
      environment.systemPackages = with pkgs; [enpass];
    }
    // (lib.optionalAttrs pkgs.stdenv.isLinux {
      systemd.user.services.enpass-daemon = {
        description = "Enpass Daemon Service";
        after = ["graphical-session.target"];
        wants = ["graphical-session.target"];
        serviceConfig = {
          ExecStart = lib.getExe' pkgs.enpass "Enpass";
          Restart = "on-failure";
          RestartSec = 5;
        };
        wantedBy = ["graphical-session.target"];
      };
    }));
}
