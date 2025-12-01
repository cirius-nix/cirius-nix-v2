{
  config,
  namespace,
  lib,
  pkgs,
  ...
} @ params: {
  options.${namespace}.base.hardware.nvidia = let
    inherit (lib) mkEnableOption;
  in {
    enable = mkEnableOption "Enable nvidia driver";
    enableUtilities = mkEnableOption "Enable nvidia utilities such as nvidia-smi";
  };
  config = let
    inherit (lib) mkIf;
    nvidiaCfg = (config.${namespace}.base.hardware).nvidia;
    deEnabled = lib.${namespace}.de.checkEnabled params;
  in
    mkIf nvidiaCfg.enable {
      environment.systemPackages = lib.optionals (nvidiaCfg.enableUtilities && deEnabled) (with pkgs; [zenith-nvidia lact]);
      services.lact = {
        enable = false;
        # enable = nvidiaCfg.enableUtilities && guiEnabled;
        # settings = mkIf (nvidiaCfg.gpuID != "") {
        #   version = 5;
        #   daemon = {
        #     log_level = "info";
        #     admin_group = "wheel";
        #     disable_clocks_cleanup = false;
        #   };
        #   apply_settings_timer = 5;
        #   current_profile = "Nvidia";
        #   auto_switch_profiles = false;
        #   profiles = {
        #     Nvidia = {
        #       gpus = {
        #         ${nvidiaCfg.gpuID} = {
        #           fan_control_enabled = true;
        #           fan_control_settings = {
        #             mode = "curve";
        #             static_speed = 0.5;
        #             temperature_key = "edge";
        #             interval_ms = 500;
        #             curve = {
        #               "40" = 0.3019608;
        #               "50" = 0.35;
        #               "60" = 0.5;
        #               "70" = 0.75;
        #               "80" = 1;
        #             };
        #             spindown_delay_ms = 5000;
        #             change_threshold = 2;
        #           };
        #         };
        #       };
        #     };
        #   };
        # };
      };
      hardware.graphics.enable = true;
      services.xserver.videoDrivers = ["nvidia"];
      hardware.graphics.enable32Bit = true;
      hardware.nvidia = {
        # Do NOT enable modesetting for Optimus systems
        modesetting.enable = true;
        # Open-source kernel modules are preferred over and planned to steadily
        # replace proprietary modules[1], although they only support GPUs of the
        # Turing architecture or newer (from GeForce RTX 20 series and GeForce
        # GTX 16 series onwards). Data center GPUs starting from Grace Hopper or
        # Blackwall must use open-source modules — proprietary modules are no
        # longer supported.
        open = true;
        nvidiaSettings = true;
        # Screen tearing issue.
        # Forcing a full composition pipeline has been reported to reduce the
        # performance of some OpenGL applications and may produce issues in
        # WebGL. It also drastically increases the time the driver needs to clock
        # down after load.
        forceFullCompositionPipeline = true;
      };
      # boot = {
      #   extraModulePackages = [config.boot.kernelPackages.nvidia_x11];
      # };
    };
}
