params: let
  inherit (params) lib namespace;
in
  lib.${namespace}.settingByOS params {
    linux.config = {
      home.sessionVariables = {
        BROWSER = "zen";
      };
      xdg = {
        mimeApps = {
          enable = true;
          defaultApplications = {
            "image/png" = "org.kde.gwenview.desktop";
            "image/jpeg" = "org.kde.gwenview.desktop";
            "video/mp4" = "mpv.desktop";
            "video/avi" = "mpv.desktop";
            "text/html" = ["zen.desktop"];
            "sql" = ["gedit" "org.kde.kate.desktop"];
          };
        };
      };
    };
  }
