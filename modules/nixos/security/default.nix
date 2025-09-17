{
  config,
  namespace,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (config.${namespace}) security;
in
{
  options.${namespace}.security = {
    hostname = mkOption {
      type = types.str;
      default = "nixos";
      description = "The hostname of the machine.";
    };
  };
  config = {
    environment.systemPackages = [
      pkgs.age
      pkgs.sops
      pkgs.ssh-to-age
    ];
    services.openssh = {
      enable = true;
      hostKeys = [
        {
          bits = 4096;
          openSSHFormat = true;
          path = "/etc/ssh/ssh_host_rsa_key";
          type = "rsa";
        }
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
      settings = {
      };
    };
    systemd.tmpfiles.rules = [
      "d /var/lib/sops-nix 0770 root root -"
    ];
    # sops =
    #   let
    #     keyFile = "/var/lib/sops-nix/key.txt";
    #   in
    #   {
    #     defaultSopsFile =
    #       if (security.hostname != null || security.hostname != "") then
    #         ../../../secrets/${security.hostname}/default.yaml
    #       else
    #         "";
    #     defaultSopsFormat = "yaml";
    #     defaultSopsKey = keyFile;
    #     gnupg = {
    #       sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    #     };
    #     age = {
    #       sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    #       keyFile = keyFile;
    #       generateKey = true;
    #     };
    #   };
  };
}
