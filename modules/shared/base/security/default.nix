{
  pkgs,
  lib,
  ...
}: {
  config =
    {
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
    }
    // (
      lib.optionalAttrs pkgs.stdenv.isLinux {
        systemd.tmpfiles.rules = [
          "d /var/lib/sops-nix 0770 root root -"
        ];
      }
    );
}
