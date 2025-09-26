{
  config,
  osConfig,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (osConfig.${namespace}.de) hyprland;
  inherit (config.${namespace}.hyprland.plugins) walker;
in
{
  options.${namespace}.hyprland.plugins.walker = {
    enable = mkEnableOption "Enable walker";
  };
  config = mkIf (hyprland.enable && walker.enable) {
    home.packages = [ pkgs.fd ];
    services.walker = {
      enable = true;
      systemd.enable = true;
      settings = {
        close_when_open = true;
        disable_click_to_close = false;
        ignore_mouse = false;
        force_keyboard_focus = true;
        hotreload_theme = true;
        search = {
          placeholder = "Search...";
          resume_last_query = true;
        };
        buitins = {
          clipboard = {
            enabled = true;
            prefix = ":";
            max_entries = 50;
            avoid_line_breaks = true;
            image_height = 200;
            always_put_new_on_top = false;
          };
          finder = {
            enabled = true;
            prefix = "/";
            use_fd = true;
            ignore_gitignore = false;
            concurrency = 4;
            preview_images = true;
          };
          websearch = {
            enabled = true;
            entries = [
              {
                name = "Google";
                url = "https://google.com/search?q={}";
                prefix = "g";
                switcher_only = false;
              }
              {
                name = "GitHub";
                url = "https://github.com/search?q={}";
                prefix = "gh";
                switcher_only = false;
              }
            ];
          };
          emojis = {
            enabled = true;
            prefix = "emoji";
            show_unqualified = false;
          };
        };
      };
    };
    nix.settings = {
      substituters = [ "https://walker.cachix.org" ];
      trusted-public-keys = [ "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM=" ];
    };
  };
}
