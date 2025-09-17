{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (config.${namespace}) wsl;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.${namespace}.wsl = {
    enable = mkEnableOption "Enable WSL specific settings.";
    defaultUser = lib.mkOption {
      type = with lib.types; (nullOr str);
      description = "Default user for WSL.";
    };
    hostname = lib.mkOption {
      type = with lib.types; (nullOr str);
      default = "nixos-wsl";
      description = "Hostname for WSL.";
    };
  };
  config = mkIf wsl.enable {
    wsl = {
      enable = true;
      inherit (wsl) defaultUser;
      docker-desktop.enable = true;
      wslConf.network = {
        inherit (wsl) hostname;
        generateHosts = true;
      };
    };
  };
}
