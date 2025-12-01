{
  config,
  namespace,
  lib,
  pkgs,
  ...
} @ params: let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.dev) docker;
  guiEnabled = lib.${namespace}.system.checkGuiEnabled params;
in {
  options.${namespace}.dev.docker = {
    enable = mkEnableOption "Enable Docker";
  };
  config = mkIf docker.enable {
    environment.systemPackages = with pkgs;
      [
        docker-client
        podman
        passt
        docker-compose
        podman-compose
        minikube
        # pods
      ]
      ++ (lib.optionals guiEnabled [pkgs.pods]);

    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;
        autoPrune = {
          enable = true;
          dates = "weekly";
        };
        defaultNetwork = {
          settings = {dns_enabled = true;};
        };
      };
      containers = {
        enable = true;
      };
      oci-containers.backend = "podman";
    };
  };
}
