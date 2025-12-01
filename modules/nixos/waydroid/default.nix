{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: {
  options.${namespace}.waydroid = {
    enable = lib.mkEnableOption "Enable Waydroid integration";
  };
  config = let
    waydroidCfg = config.${namespace}.waydroid;
    nividiaCfg = config.${namespace}.base.hardware.nvidia;
  in
    lib.mkIf waydroidCfg.enable {
      environment.systemPackages = with pkgs; [
        waydroid-helper
        wl-clipboard
      ];
      programs.adb.enable = true;
      # forward notifications
      # programs.kdeconnect = {
      #   enable = true;
      #   package = lib.force pkgs.gnomeExtensions.gsconnect;
      # };
      virtualisation.waydroid.enable = true;
      systemd = {
        packages = [pkgs.waydroid-helper];
        # use this command after reboot:
        # systemctl --user start waydroid-monitor
        services.waydroid-mount.wantedBy = ["multi-user.target"];
      };
      # modify /var/lib/waydroid/waydroid_base.prop if nvidia is enabled
      environment.etc."waydroid/waydroid_base.prop".text = lib.mkIf nividiaCfg.enable (''
          ro.hardware.gralloc=default
          ro.hardware.egl=swiftshader
        ''
        # Linux 5.18+ use memfd for better performance
        + ''
          sys.use_memfd=true
        '');
    };
}
