{
  config,
  namespace,
  lib,
  options,
  pkgs,
  ...

}:
{
  options.${namespace}.security = { };
  config = {
    environment.systemPackages = [
      pkgs.age
      pkgs.sops
      pkgs.ssh-to-age
    ];
    services.openssh = {
      enable = true;
    };
  };
}
