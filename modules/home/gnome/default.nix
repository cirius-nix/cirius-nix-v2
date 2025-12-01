{
  pkgs,
  namespace,
  lib,
  ...
} @ params:
lib.${namespace}.gnome.applyAttrOnEnabled params
{
  options.${namespace}.gnome = {
  };
  # https://wiki.nixos.org/wiki/GNOME
  config = {
    stylix.targets.gnome = {
      enable = true;
      useWallpaper = true;
    };
    home.packages = with pkgs; [
      gnome-tweaks
    ];
    dconf = {
      # Dconf is a low-level configuration system for storing and loading
      # configurations. The dconf database is stored in a single binary file in
      # ~/.config/dconf/user and contains all known configuration values for all
      # applications and programs that use dconf (GNOME applications and shell,
      # gtk, etc).
      enable = true;
      settings = {
        "org/gnome/mutter" = {
          experimental-features = ["scale-monitor-framebuffer"];
        };
        "org/gnome/desktop/interface" = {
          scaling-factor = 1;
        };
        "org/gnome/desktop/wm/preferences" = {
          button-layout = "close,minimize,maximize:appmenu";
        };
      };
    };
  };
}
