{
  config,
  pkgs,
  lib,
  namespace,
  ...
} @ params: {
  options.${namespace}.base.audio = {
    enable = lib.mkEnableOption "Enable audio support with PipeWire";
  };
  config = let
    cfg = config.${namespace}.base.audio;
    deEnabled = lib.${namespace}.de.checkEnabled params;
  in
    lib.mkIf cfg.enable {
      environment.systemPackages = lib.optionals deEnabled (with pkgs; [
        wiremix
        pavucontrol
      ]);
      security.rtkit.enable = true;
      services.pipewire = lib.${namespace}.enableAll ["alsa" "pulse" "jack"] {
        enable = true;
        alsa.support32Bit = true;
        # eliminate audio startup delay after suspend or boot.
        wireplumber.extraConfig."99-disable-suspend"."monitor.alsa.rules" = [
          {
            matches = [{"node.name" = "alsa_output.pci_0000_01_00.1.hdmi-stereo-extra1";}];
            actions.update-props = {
              "session.suspend-timeout-secords" = 0;
              "node.always-process" = true;
              "dither.method" = "wannamaker3";
              "dither.noise" = 1;
            };
          }
        ];
        extraConfig = {
          pipewire."99-silent-bell.conf"."context.properties".module.x11.bell = false;
          # The default minimum value is 1024, so it needs to be tweaked if low-latency audio is desired.
          pipewire-pulse = {
            "92-low-latency" = {
              "context.properties" = [
                {
                  name = "libpipewire-module-protocol-pulse";
                  args = {};
                }
              ];
              "pulse.properties" = {
                "pulse.min.req" = "32/48000";
                "pulse.default.req" = "32/48000";
                "pulse.max.req" = "32/48000";
                "pulse.min.quantum" = "32/48000";
                "pulse.max.quantum" = "32/48000";
              };
              "stream.properties" = {
                "node.latency" = "32/48000";
                "resample.quality" = 1;
              };
            };
            "99-default-sink.conf"."context.properties".default.clock = {
              rate = 48000;
              allowed-rates = [
                44100
                48000
                88200
                96000
                176400
                192000
              ];
              quantum = 1024;
              min-quantum = 32;
              max-quantum = 8192;
            };
          };
        };
      };
    };
}
