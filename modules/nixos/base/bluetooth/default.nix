{
  config,
  pkgs,
  namespace,
  lib,
  ...
}: {
  options.${namespace}.base.bluetooth = {
    enable = lib.mkEnableOption "Enable bluetooth support";
  };
  config = let
    cfg = config.${namespace}.base.bluetooth;
  in
    lib.mkIf cfg.enable {
      environment.systemPackages = [
        pkgs.bluetui
        pkgs.bluez
      ];
      hardware.bluetooth = {
        enable = true;
        settings.General = {
          Enable = "Source,Sink,Media,Socket"; # Modern headset try to connect using A2DP profile.
          Experimental = true;
        }; # battery level support
      };
      services.blueman.enable = true;
      # using bluetooth headsets buttons to control media playback requires mpris-proxy
      systemd.user.services.mpris-proxy = {
        description = "MPRIS Proxy for Bluetooth Audio Devices";
        after = ["network.target" "sound.target"];
        wantedBy = ["default.target"];
        serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
      };
    };
}
