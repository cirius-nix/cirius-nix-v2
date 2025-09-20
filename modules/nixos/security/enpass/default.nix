{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.security) enpass;
in
{
  options.${namespace}.security.enpass = {
    enable = mkEnableOption "Enable enpass password manager";
  };
  config = mkIf enpass.enable {
    environment.systemPackages = [ pkgs.enpass ];
  };
}
