{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: {
  options.${namespace}.de.gnome = {
    enable = lib.mkEnableOption "Enable gnome Desktop Environment";
  };
  config = lib.mkIf config.${namespace}.de.gnome.enable {
    environment.systemPackages = with pkgs; [
      kitty
      alacritty
    ];
    services = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      gnome.core-apps.enable = true;
      gnome.core-developer-tools.enable = true;
      gnome.games.enable = false;
    };
    environment.gnome.excludePackages = with pkgs; [gnome-tour gnome-user-docs];
  };
}
