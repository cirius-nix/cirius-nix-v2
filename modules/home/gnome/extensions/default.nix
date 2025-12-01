{
  pkgs,
  lib,
  namespace,
  ...
} @ params:
lib.${namespace}.gnome.onEnabled params {
  config = {
    dconf.settings = {
      "org/gnome/shell" = {
        "enabled-extensions" = [
          "blur-my-shell@aunetx"
          "just-perfection-desktop@just-perfection"
          "appindicatorsupport@rgcjonas.gmail.com"
          "user-theme@gnome-shell-extensions.gcampax.github.com"
        ];
      };
      "org/gnome/shell/extensions/just-perfection" = {
        "support-notifier-type" = 0;
      };
      "org/gnome/shell/extensions/blur-my-shell/panel" = {
        "blur" = true;
        "static-blur" = false;
        "sigma" = 30;
        "brightness" = 0.6;
        "force-light-text" = false;
        "override-background" = true;
        "style-panel" = 0; # transparent 0 light 1 dark 2 constracted 3
        "override-background-dynamically" = false;
      };
      "org/gnome/shell/extensions/blur-my-shell/overview" = {
        "blur" = true;
      };
      "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
        "blur" = true;
        "sigma" = 30;
        "brightness" = 0.6;
      };
      "org/gnome/shell/extensions/blur-my-shell/application" = {
        blur = true;
        sigma = 100;
        brightness = 1;
        opacity = 215;
        dynamic-opacity = false;
        enable-all = true;
      };
    };
    programs.gnome-shell = {
      enable = true;
      extensions = [
        {package = pkgs.gnomeExtensions.blur-my-shell;}
        {package = pkgs.gnomeExtensions.just-perfection;}
        {package = pkgs.gnomeExtensions.appindicator;}
      ];
    };
  };
}
