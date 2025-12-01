{
  namespace,
  lib,
  ...
} @ inputs:
lib.${namespace}.hyprland.applyAttrOnEnabled inputs {
  config = {
    wayland.windowManager.hyprland.settings = {
      plugin = {
        hyprbars = {
          enabled = true;
          bar_blur = true;
          bar_buttons_alignment = "left";
          bar_height = 20;
          hyprbars-button = [
            "rgb(ff4040), 10, 󰖭, hyprctl dispatch killactive"
            "rgb(eeee11), 10, , hyprctl dispatch fullscreen 1"
          ];
          on_double_click = "hyprctl dispatch fullscreen 1";
        };
      };
    };
  };
}
