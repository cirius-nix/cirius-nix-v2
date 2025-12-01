{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: {
  options.${namespace}.development.docker = {
    enable = lib.mkEnableOption "Enable Docker";
  };
  config = let
    inherit (lib) mkIf;
    inherit (config.${namespace}.development) docker;
  in
    mkIf docker.enable {
      home.packages = [
        pkgs.docker-init
      ];
      programs.lazydocker = {
        enable = true;
        settings = {
          dockerCompose = "docker compose";
        };
      };
    };
}
