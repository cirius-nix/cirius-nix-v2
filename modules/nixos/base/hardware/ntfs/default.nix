{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.base.hardware) ntfs;
in {
  options.${namespace}.base.hardware.ntfs = {
    enable = mkEnableOption "Enable NTFS support";
  };
  config = mkIf ntfs.enable {
    environment.systemPackages = with pkgs; [
      ntfs3g
    ];
  };
}
