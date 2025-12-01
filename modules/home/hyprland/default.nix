{
  config,
  namespace,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkForce;
  inherit (lib.${namespace}) strlib intlib;
  inherit (osConfig.${namespace}.de) hyprland;
  hyprlandHome = config.${namespace}.hyprland;

  # alias map attribute set from k:v to to $k:v
  aliases =
    lib.attrsets.mapAttrs' (name: value: {
      name = "$" + "${name}";
      inherit value;
    })
    hyprlandHome.aliases;

  # from 1 to 9
  wsBindings = builtins.concatLists (
    builtins.genList (
      i: let
        ws = i + 1;
      in [
        "$mod, code:1${toString i}, workspace, ${toString ws}"
        "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
      ]
    )
    9
  );

  themePkg = hyprlandHome.packages.theme;
  iconPkg = hyprlandHome.packages.icon;

  onEmptyWorkspaceOption = lib.mkOption {
    type = with lib.types;
      listOf (submodule {
        options = {
          idx = intlib.mkOption 1 "Workspace index, from 1 to 9.";
          app = strlib.mkOption "" "Application to launch.";
          icon = strlib.mkOption' null "Icon for the workspace.";
        };
      });
    default = [
      {
        idx = 1;
        app = "$launchBrowser";
        icon = "";
      }
      {
        idx = 2;
        app = "$launchAPIClient";
        icon = "󰊳";
      }
      {
        idx = 3;
        app = "$launchTerminal";
        icon = "";
      }
      {
        idx = 4;
        app = "$launchDatabaseEditor";
        icon = "";
      }
      {
        idx = 5;
        app = "$launchMusicPlayer";
        icon = "";
      }
    ];
    description = "List of application to create on empty.";
  };
in {
  options.${namespace}.hyprland = {
    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      XDG_SESSION_TYPE = "wayland";
    };
    packages = {
      theme = lib.mkOption {
        type = with lib.types; nullOr package;
        default = pkgs.flat-remix-gtk;
        description = "Additional packages to install for hyprland themes.";
      };
      icon = lib.mkOption {
        type = with lib.types; nullOr package;
        default = pkgs.adwaita-icon-theme;
        description = "Additional packages to install for hyprland.";
      };
    };
    aliases = {
      mod = strlib.mkOption "SUPER" "Main modifier";
      raiseVol = strlib.mkOption ''wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 10%+'' "Increase volume";
      lowerVol = strlib.mkOption ''wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 10%-'' "Decrease volume";
      muteVol = strlib.mkOption ''wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'' "Mute volume";
      lock = strlib.mkOption "hyprlock" "Lock screen";
      launchBrowser = strlib.mkOption "zen" "Browser";
      launchPrivateBrowser = strlib.mkOption "zen --private-window" "Private browser";
      launchTerminal = strlib.mkOption "alacritty" "Terminal";
      launchFileManager = strlib.mkOption "alacritty -e nnn" "File manager";
      launchMenu = strlib.mkOption "walker" "Menu executor";
      launchAI = strlib.mkOption ''alacritty -e "tgpt --interactive-shell"'' "AI";
      launchBtop = strlib.mkOption "alacritty --class btop -e btop" "System monitor";
      launchWifiSelector = strlib.mkOption "alacritty --class nmtui -e nmtui-connect" "WiFi selector";
      launchBluetoothManager = strlib.mkOption "alacritty --class bluetui -e bluetui" "Bluetooth manager";
      launchAudioManager = strlib.mkOption "alacritty --class wiremix -e wiremix" "Audio manager";
      launchAudioVisualizer = strlib.mkOption "NickvisionCavalier.GNOME" "Audio visualizer";
      launchCalendar = strlib.mkOption "alacritty --class calcurse -e calcurse" "Calendar application";
      launchScreenshotArea = strlib.mkOption "grimblast --notify copy area" "Screenshot area";
      launchDatabaseEditor = strlib.mkOption "datagrip" "Database editor";
      launchAPIClient = strlib.mkOption "apidog" "API client";
    };
    workspace = {
      onEmpty = onEmptyWorkspaceOption;
    };
  };
  config = mkIf hyprland.enable {
    stylix = {
      targets = {
        hyprland.enable = true;
        hyprpaper.enable = config.services.hyprpaper.enable;
        hyprlock.enable = config.programs.hyprlock.enable;
      };
    };
    programs.kitty.enable = true;
    programs.hyprlock = {
      enable = true;
    };
    home = {
      packages = [
        iconPkg
        pkgs.calcurse
      ]; # required for hyprland.
      pointerCursor = {
        gtk.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 16;
      };
    };

    gtk = {
      enable = true;
      theme = {
        package = themePkg;
        name = themePkg.pname;
      };
      iconTheme = {
        package = iconPkg;
        name = iconPkg.pname;
      };
    };
    services = {
      hyprpolkitagent.enable = true;
      hyprpaper.enable = true;
      hypridle.enable = true;
      hypridle.settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
        };

        listener = [
          {
            timeout = 900;
            on-timeout = "hyprlock";
          }
          {
            timeout = 1200;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
    # ensure these variables should not be modified by any profile.
    wayland.windowManager.hyprland = {
      systemd.variables = mkForce ["--all"];
      enable = mkForce true;
      package = mkForce null;
      portalPackage = mkForce null;
      extraConfig = ''
        env=ELECTRON_OZONE_PLATFORM_HINT,wayland

        exec-once = fcitx5 -d
        exec-once = systemctl --user start hyprpolkitagent

        windowrule = opacity 0.97 0.9, class:.*
      '';
      settings = lib.foldl' lib.recursiveUpdate {} [
        aliases
        {
          # ps -eo pid,comm --sort=comm | grep -iE "firefox|kitty|code|steam|alacritty"
          bind =
            [
              # Apps
              "$mod, b, exec, $launchBrowser"
              "$mod SHIFT, B, exec, $launchPrivateBrowser"
              "$mod, Return, exec, $launchTerminal"
              "$mod, E, exec, $launchFileManager"
              "$mod, Space, exec, $launchMenu"
              "$mod, A, exec, $launchAI"

              # Screenshots
              "$mod SHIFT, S, exec, $launchScreenshotArea"

              # Window Management
              "$mod, Q, killactive,"
              "$mod SHIFT, Q, forcekillactive,"
              "$mod, F, fullscreen, 1"
              "$mod, V, togglefloating,"
              "$mod, P, pseudo," # pseudo-tiling
              "$mod, J, togglesplit," # dwindle

              # Focus
              "$mod, left, movefocus, l"
              "$mod, right, movefocus, r"
              "$mod, up, movefocus, u"
              "$mod, down, movefocus, d"

              # Move windows
              "$mod SHIFT, left, movewindow, l"
              "$mod SHIFT, right, movewindow, r"
              "$mod SHIFT, up, movewindow, u"
              "$mod SHIFT, down, movewindow, d"

              # System
              "$mod, L, exec, $lock"
              "$mod, Escape, exec, hyprctl dispatch exit"
              # ", Print, exec, grimshot --notify save area"
              ", XF86AudioRaiseVolume, exec, $raiseVol"
              ", XF86AudioLowerVolume, exec, $lowerVol"
              ", XF86AudioMute, exec, $muteVol"
            ]
            ++ wsBindings;
          bindm = [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
          ];
          # workspace scroll
          binde = [
            "$mod, mouse_down, workspace, e+1"
            "$mod, mouse_up, workspace, e-1"
          ];
        }
        {
          xwayland = {
            force_zero_scaling = true;
          };
          decoration = {
            rounding = 8;
            blur = {
              enabled = true;
              ignore_opacity = true;
            };
          };
          env = [];
          workspace = let
            toWorkspaceLine = entry: "${toString entry.idx}, on-created-empty:${entry.app}";
          in
            (map toWorkspaceLine hyprlandHome.workspace.onEmpty) ++ [];
        }
      ];
    };
  };
}
