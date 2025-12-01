{
  pkgs,
  lib,
  osConfig ? {},
  ...
}: let
  namespace = "cirius-v2";
in {
  config.${namespace} = lib.${namespace}.hyprland.applyAttrOnEnabled {inherit namespace pkgs osConfig;} {
    hyprland = {
      keygroup = [
        {
          id = "default";
          shortcut = ["$mod" ""]; # The modifier for global bindings
          bindings =
            [
              {
                key = "Q";
                command = "killactive";
                type = "bind";
                resetAfter = false;
              }
              {
                key = "V";
                command = "togglefloating";
                type = "bind";
                resetAfter = false;
              }
              {
                key = "P";
                command = "pseudo";
                type = "bind";
                resetAfter = false;
              }
              {
                key = "J";
                command = "togglesplit";
                type = "bind";
                resetAfter = false;
              }
              {
                key = "F";
                command = "fullscreen";
                type = "bind";
                resetAfter = false;
              }
              {
                key = "XF86AudioRaiseVolume";
                command = "exec, $raiseVol";
                type = "bind";
                resetAfter = false;
              }
              {
                key = "XF86AudioLowerVolume";
                command = "exec, $lowerVol";
                type = "bind";
                resetAfter = false;
              }
              {
                key = "XF86AudioMute";
                command = "exec, $muteVol";
                type = "bind";
                resetAfter = false;
              }
            ]
            ++ (
              # Generate workspace bindings for numbers 1-9 (code:10 through code:18)
              builtins.concatMap (i: let
                keyCode = "code:${toString (i + 9)}"; # code:10 for workspace 1, etc.
                workspaceNum = toString i;
              in [
                {
                  key = keyCode;
                  command = "workspace, ${workspaceNum}";
                  type = "bind";
                  resetAfter = false;
                }
              ]) (builtins.genList (i: i + 1) 9)
            );
          children = [];
        }
        {
          id = "browser";
          "shortcut" = ["$mod" "B"];
          bindings = [];
        }
        {
          id = "windowManagement";
          shortcut = ["$mod" "W"];
          bindings =
            [
              {
                key = "f";
                command = "togglefloating";
                type = "bind";
                resetAfter = true;
              }
              {
                key = "h";
                command = "movefocus, l";
                type = "bind";
                resetAfter = true;
              }
              {
                key = "l";
                command = "movefocus, r";
                type = "bind";
                resetAfter = true;
              }
              {
                key = "k";
                command = "movefocus, u";
                type = "bind";
                resetAfter = true;
              }
              {
                key = "j";
                command = "movefocus, d";
                type = "bind";
                resetAfter = true;
              }
              {
                key = "R";
                command = "setfloating, active";
                type = "bind";
                resetAfter = false;
              }
            ]
            ++ (
              # Generate workspace bindings for numbers 1-9 (code:10 through code:18)
              builtins.concatMap (i: let
                keyCode = "code:${toString (i + 9)}"; # code:10 for workspace 1, etc.
                workspaceNum = toString i;
              in [
                {
                  key = keyCode;
                  command = "setfloating, active";
                  type = "bind";
                  resetAfter = false;
                }
                {
                  key = keyCode;
                  command = "movetoworkspacesilent, ${workspaceNum}";
                  type = "bind";
                  resetAfter = false;
                }
                {
                  key = keyCode;
                  command = "workspace, ${workspaceNum}";
                  type = "bind";
                  resetAfter = false;
                }
                {
                  key = keyCode;
                  command = "submap, reset";
                  type = "bind";
                  resetAfter = false;
                }
              ]) (builtins.genList (i: i + 1) 9)
            ); # Generate list [1, 2, 3, ..., 9]
          children = [
            {
              id = "moveWindow";
              shortcut = ["" "M"];
              bindings = [
                {
                  key = "h";
                  command = "movewindow, l";
                  type = "binde";
                  resetAfter = false;
                }
                {
                  key = "j";
                  command = "movewindow, d";
                  type = "binde";
                  resetAfter = false;
                }
                {
                  key = "k";
                  command = "movewindow, u";
                  type = "binde";
                  resetAfter = false;
                }
                {
                  key = "l";
                  command = "movewindow, r";
                  type = "binde";
                  resetAfter = false;
                }
              ];
              children = [];
            }
            {
              id = "resizeWindow";
              shortcut = ["" "R"];
              bindings = builtins.concatMap (direction: let
                directionMap = {
                  "l" = {
                    resize = "50 0";
                    key = "l";
                  };
                  "h" = {
                    resize = "-50 0";
                    key = "h";
                  };
                  "k" = {
                    resize = "0 50";
                    key = "k";
                  };
                  "j" = {
                    resize = "0 -50";
                    key = "j";
                  };
                };
                dirConfig = directionMap.${direction};
              in [
                {
                  key = dirConfig.key;
                  command = "resizeactive, ${dirConfig.resize}";
                  type = "binde";
                  resetAfter = false;
                }
                {
                  key = dirConfig.key;
                  command = "centerwindow, active";
                  type = "binde";
                  resetAfter = false;
                }
              ]) ["l" "h" "k" "j"];
              children = [];
            }
          ];
        }
        {
          id = "AI";
          shortcut = ["$mod" "A"];
          bindings = [
            # App bindings will be automatically added here
          ];
          children = [];
        }
      ];
      app = {
        system = {
          network = {
            id = "nmtui-connect";
            launchIn = "term";
            floatedBy = "class";
            forceTermClass = true;
          };
        };
        browserLauncher = {
          command = "google-chrome-stable --class=browserLauncher";
          newWindowFlag = "--new-window";
          newPrivateWindowFlag = "--incognito";
        };
        list = [
          {
            id = "zen";
            icon = "";
            wsName = "Browser";
            keygroupBinding = {
              keygroup = "browser";
              key = "Z";
              resetAfter = true;
            };
          }
          {
            id = "Podman Desktop";
            class = "Podman-desktop";
            wsName = "Containers";
            floatedBy = "class";
          }
          {
            id = "google-chrome-stable";
            icon = "";
            wsName = "Browser";
            keygroupBinding = {
              keygroup = "browser";
              key = "C";
              resetAfter = true;
            };
          }
          {
            id = "alacritty";
            shortcut = [
              "$mod"
              "Return"
            ];
            icon = "";
            wsName = "Terminal";
            keygroupBinding = {
              keygroup = "default";
              key = "Return";
              resetAfter = false;
            };
          }
          {
            id = "datagrip";
            icon = "󱙋";
            wsName = "Database Editor";
          }
          {
            id = "apidog";
            icon = "";
            wsName = "API Client";
          }
          {
            id = "spotify";
            icon = "󰎆";
            wsName = "Music";
          }
          {
            id = "gwenview";
            icon = "";
            wsName = "Image Viewer";
            floatedBy = "class";
            class = "org.kde.gwenview";
          }
          {
            id = "mpv";
            wsName = "Video Player";
            floatedBy = "class";
          }
          {
            id = "vlc";
            wsName = "Video Player";
            floatedBy = "class";
          }
          {
            id = "nautilus";
            wsName = "File Manager";
            floatedBy = "class";
            keygroupBinding = {
              keygroup = "default";
              key = "E";
              resetAfter = false;
            };
          }
          {
            id = "btop";
            floatedBy = "class";
            launchIn = "term";
            forceTermClass = true;
            keygroupBinding = {
              keygroup = "windowManagement";
              key = "T";
              resetAfter = true;
            };
          }
          {
            id = "xdg-desktop-portal-gtk";
            floatedBy = "class";
          }
          {
            id = "chatgpt";
            class = "chatgpt";
            floatedBy = "class";
            launchIn = "browser";
            browserURL = "https://chat.openai.com";
            size = "1200 800";
            pinned = true;
            persistentSize = true;
            keygroupBinding = {
              keygroup = "AI";
              key = "o";
              resetAfter = true;
            };
          }
          {
            id = "claude";
            class = "claude";
            floatedBy = "class";
            launchIn = "browser";
            browserURL = "https://claude.ai";
            size = "1200 800";
            pinned = true;
            persistentSize = true;
            keygroupBinding = {
              keygroup = "AI";
              key = "l";
              resetAfter = true;
            };
          }
          {
            id = "copilot";
            class = "copilot";
            floatedBy = "class";
            launchIn = "browser";
            browserURL = "https://copilot.microsoft.com";
            shortcut = ["$mod" "a"];
            size = "1200 800";
            pinned = true;
            persistentSize = true;
            keygroupBinding = {
              keygroup = "AI";
              key = "c";
              resetAfter = true;
            };
          }
          {
            id = "google-search-ai";
            class = "google-search-ai";
            floatedBy = "class";
            launchIn = "browser";
            browserURL = "https://www.google.com/ai";
            shortcut = ["$mod" "g"];
            size = "1200 800";
            pinned = true;
            persistentSize = true;
            keygroupBinding = {
              keygroup = "AI";
              key = "g";
              resetAfter = true;
            };
          }
        ];
      };
      monitor = {
        list = [
          {
            output = "DP-3";
            mode = "preferred";
            position = "0x0";
            scale = "1.5";
            apps = [
              "zen"
              "alacritty"
              "datagrip"
            ];
          }
          {
            output = "HDMI-A-1";
            disabled = 1;
            mode = "preferred";
            position = "2560x540";
            scale = "1.0";
            apps = [
              "apidog"
              "spotify"
            ];
          }
        ];
      };
      packages = {
        icon = pkgs.beauty-line-icon-theme;
      };
      misc = {
        hyprpanel.enable = true;
      };
      plugins = {
        walker.enable = true;
        grimshot.enable = true;
        grimshot.editor = "krita";
      };
      aliases = {
        mod = "SUPER";
      };
    };
  };
}
