{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: {
  options.${namespace}.de.cosmic = {
    enable = lib.mkEnableOption "Enable Cosmic DE";
    autoLoginUser = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "User to auto login as.";
    };
  };
  config = lib.mkIf config.${namespace}.de.cosmic.enable {
    services.desktopManager.cosmic.enable = true;
    services.displayManager = {
      cosmic-greeter.enable = true;
      autoLogin = let
        user = config.${namespace}.de.cosmic.autoLoginUser;
      in
        lib.mkIf (user != null) {
          enable = true;
          inherit user;
        };
    };
    environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;
    environment.systemPackages = with pkgs; [
      libsForQt5.qt5ct
      kdePackages.qt6ct
      kdePackages.qtwayland
      kitty
      alacritty
    ];
  };
}
