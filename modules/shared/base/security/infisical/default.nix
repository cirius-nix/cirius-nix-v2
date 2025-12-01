{
  config,
  pkgs,
  namespace,
  lib,
  ...
}: {
  options.${namespace}.base.security.infisical = {
    enable = lib.mkEnableOption "Enable Infisical CLI installation";
    envFile = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Environment file for Infisical CLI.";
    };
    port = lib.mkOption {
      type = lib.types.int;
      default = 8034;
      description = "Port for Infisical server.";
    };
    redis = {
      port = lib.mkOption {
        type = lib.types.int;
        default = 6380;
        description = "Port for Infisical Redis server.";
      };
      passFile = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Password file for Infisical Redis server.";
      };
    };
  };
  config = let
    infisicalCfg = config.${namespace}.base.security.infisical;
  in (lib.mkIf infisicalCfg.enable {
    environment.systemPackages = with pkgs; [
      infisical
    ];
    services.redis.servers.infisical = {
      enable = true;
      bind = "0.0.0.0";
      port = infisicalCfg.redis.port;
      requirePassFile = infisicalCfg.redis.passFile;
      databases = 16;
      openFirewall = true;
    };
    networking.firewall.allowedTCPPorts = [
      infisicalCfg.port
    ];
    virtualisation.oci-containers.containers = {
      infisical = {
        image = "infisical/infisical:v0.154.1";
        autoStart = true;
        ports = [
          "${toString infisicalCfg.port}:8080"
        ];
        networks = [];
        environmentFiles = [
          infisicalCfg.envFile
        ];
      };
    };
  });
}
