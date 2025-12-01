{
  pkgs,
  lib,
  namespace,
  ...
} @ params: let
  deEnabled = lib.${namespace}.de.checkEnabled params;
in {
  environment.systemPackages = lib.optionals deEnabled (with pkgs; [
    wiremix
    pavucontrol
  ]);
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    extraConfig = {
      pipewire."99-silent-bell.conf" = {
        "context.properties" = {
          module.x11.bell = false;
        };
      };
      pipewire-pulse."99-default-sink.conf" = {
        "context.properties" = {
          default.clock.rate = 48000;
          default.clock.allowed-rates = [
            44100
            48000
            88200
            96000
            176400
            192000
          ];
          default.clock.quantum = 1024;
          default.clock.min-quantum = 32;
          default.clock.max-quantum = 8192;
        };
      };
    };
  };
}
