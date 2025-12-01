{
  config,
  namespace,
  lib,
  pkgs,
  inputs,
  ...
}: {
  options.${namespace}.de.pantheon = {
    enable = lib.mkEnableOption "Enable Pantheon Desktop Environment";
  };
  config = lib.mkIf config.${namespace}.de.pantheon.enable {
    environment.systemPackages = with pkgs; [
    ];
    services = {
      desktopManager.pantheon.enable = true;
      pantheon.apps.enable = false;
      xserver = {
        # This automatically enables LightDM and Pantheon's LightDM greeter
        enable = true;
      };
    };
  };
}
