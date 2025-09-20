{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}) nvidia;
in
{
  options.${namespace}.nvidia = {
    enable = mkEnableOption "Enable nvidia driver";
  };
  config = mkIf nvidia.enable {
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      modesetting.enable = true;
      # caused sleep/suspend to fail.
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
    };
    boot.initrd.kernelModules = [ "nvidia" ];
  };
}
