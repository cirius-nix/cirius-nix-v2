{
  config,
  namespace,
  lib,
  pkgs,
  ...
} @ params: let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.dev) docker;
  deEnabled = lib.${namespace}.de.checkEnabled params;
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
      ++ (lib.optionals deEnabled [pkgs.pods]);

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
