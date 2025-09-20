{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}) security;
in
{
  options.${namespace}.security = {
    enable = mkEnableOption "Enable security settings and tools";
    ssh = { };
  };
  config = mkIf security.enable {
    home.packages = [
      pkgs.age
      pkgs.sops
      pkgs.ssh-to-age
    ];
  };
}
