{ pkgs, ... }:
{
  config = {
    environment.systemPackages = [
      pkgs.bluetui
    ];
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}
