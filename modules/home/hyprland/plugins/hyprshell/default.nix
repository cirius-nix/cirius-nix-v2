{
  namespace,
  lib,
  ...
} @ params:
lib.${namespace}.hyprland.applyAttrOnEnabled params {
  options.${namespace}.hyprland.plugins.hyprshell = {
  };
  config = {
    programs.hyprshell = {
      enable = true;
      # hyprland = inputs.hyprland.packages.${system}.hyprland;
      systemd.args = "-v";
      settings = {
        windows = {
          enable = true;
          scale = 8.5;
          items_per_row = 5;
          switch.enable = true;
          overview = {
            enable = true;
            key = "super_l";
            modifier = "alt";
            filter_by = [];
            hide_filtered = false;
            launcher = {
              default_terminal = "alacritty";
              launch_modifier = "ctrl";
              width = 650;
              max_items = 5;
              show_when_empty = true;
              plugins = {
                applications = {
                  run_cache_weeks = 8;
                  show_execs = true;
                  show_actions_submenu = true;
                };
                terminal = {
                  enable = true;
                };
                shell = {
                  enable = true;
                };
                calc = {
                  enable = true;
                };
                path = {
                  enable = true;
                };
              };
            };
          };
        };
      };
    };
  };
}
