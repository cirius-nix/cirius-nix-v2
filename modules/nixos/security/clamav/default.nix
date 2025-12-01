{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: {
  options.${namespace}.security.clamav = {
    enable = lib.mkEnableOption "Enable ClamAV antivirus service";
    scanDirectories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "/home"
        "/var/lib"
        "/tmp"
        "/etc"
        "/var/tmp"
      ];
      description = "Directories to be scanned by ClamAV scanner.";
    };
    updateInterval = lib.mkOption {
      type = lib.types.str;
      default = "hourly";
      description = "Interval for ClamAV virus database updates.";
    };
  };
  config = lib.mkIf config.${namespace}.security.clamav.enable {
    services.clamav = {
      scanner = {
        enable = true;
        interval = "*-*-* 04:00:00";
        scanDirectories = config.${namespace}.security.clamav.scanDirectories;
      };
      updater = {
        enable = true;
        settings = {
          # https://linux.die.net/man/5/freshclam.conf
        };
        interval = config.${namespace}.security.clamav.updateInterval;
        frequency = 6;
      };
      fangfrisch = {
        enable = true;
        settings = {};
        interval = config.${namespace}.security.clamav.updateInterval;
      };
      daemon = {
        enable = true;
        settings = {
          # https://linux.die.net/man/5/clamd.conf
        };
      };
    };
    environment.systemPackages = [pkgs.clamav];
  };
}
