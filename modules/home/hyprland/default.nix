{
  config,
  namespace,
  lib,
  pkgs,
  inputs,
  system,
  ...
} @ params:
lib.${namespace}.hyprland.applyAttrOnEnabled params
{
  options.${namespace}.hyprland = let
    inherit (lib.${namespace}) mkStrOption mkIntOption;
  in {
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
    floatingSize = {
      width = mkIntOption 800 "Default initial width for floating window.";
      height = mkIntOption 600 "Default initial height for floating window.";
    };
    floatingSizeOnCls = lib.mkOption {
      type = with lib.types;
        listOf (submodule {
          options = {
            cls = mkStrOption "" "Window class name.";
            width = mkIntOption 800 "Initial width.";
            height = mkIntOption 600 "Initial height.";
          };
        });
      default = [];
      description = "List of window classes to set initial size.";
    };
    floatingOnCls = lib.mkOption {
      type = with lib.types; listOf str;
      default = ["^(tgpt|bluetui|wiremix|btop|calcurse)$"];
      description = "List of window classes to always float.";
    };
    aliases = {
      mod = mkStrOption "SUPER" "Main modifier";
      raiseVol = mkStrOption ''wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 10%+'' "Increase volume";
      lowerVol = mkStrOption ''wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 10%-'' "Decrease volume";
      muteVol = mkStrOption ''wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'' "Mute volume";
      lock = mkStrOption "hyprlock" "Lock screen";
      floatingFlag = mkStrOption "floatingWindow" "Floating window flag";
      launchScreenshotArea = mkStrOption "grimblast --notify copy area" "Screenshot area";
    };
  };
  config = let
    hyprlandHome = config.${namespace}.hyprland;

    # alias map attribute set from k:v to to $k:v
    aliases =
      lib.attrsets.mapAttrs' (name: value: {
        name = "$" + "${name}";
        inherit value;
      })
      hyprlandHome.aliases;

    iconPkg = hyprlandHome.packages.icon;
  in {
    stylix = {
      targets = {
        hyprland.enable = true;
        hyprpaper.enable = config.services.hyprpaper.enable;
        hyprlock.enable = config.programs.hyprlock.enable;
        qt = {
          platform = "qtct";
        };
      };
    };
    programs = {
      kitty.enable = true;
      hyprlock = {
        enable = true;
      };
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

    qt = {
      enable = true;
    };

    gtk = {
      enable = true;
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
      systemd.variables = lib.mkForce ["--all"];
      enable = lib.mkForce true;
      package = lib.mkForce inputs.hyprland.packages.${system}.hyprland;
      portalPackage = lib.mkForce null;
      # plugins = [
      #   inputs.split-monitor-workspaces.packages.${system}.split-monitor-workspaces
      # ];
      extraConfig = ''
        misc:animate_manual_resizes = true
        env=ELECTRON_OZONE_PLATFORM_HINT,wayland

        exec-once = fcitx5 -d
        exec-once = systemctl --user start hyprpolkitagent

        windowrule = opacity 0.97 0.9, class:.*
      '';

      settings = lib.foldl' lib.recursiveUpdate {} [
        aliases
        {
          # ps -eo pid,comm --sort=comm | grep -iE "firefox|kitty|code|steam|alacritty"
          bind = [
            # Apps

            # Screenshots
            "$mod SHIFT, S, exec, $launchScreenshotArea"

            # Window Management
            "$mod, Q, killactive,"
            "$mod SHIFT, Q, forcekillactive,"

            # System
            "$mod, Escape, exec, hyprctl dispatch exit"
            ", XF86AudioRaiseVolume, exec, $raiseVol"
            ", XF86AudioLowerVolume, exec, $lowerVol"
            ", XF86AudioMute, exec, $muteVol"
          ];
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
          windowrule = let
            inherit (hyprlandHome) floatingSize;
          in
            [
              "opacity 0.97 0.9, class:.*"
              "size ${builtins.toString floatingSize.width} ${builtins.toString floatingSize.height}, floating:1, class:^(?!datagrip$).*"
            ]
            ++ (lib.map (cls: "float, class:${cls}") hyprlandHome.floatingOnCls)
            ++ (lib.map (
                entry: "size ${toString entry.width} ${toString entry.height}, class:${entry.cls}"
              )
              hyprlandHome.floatingSizeOnCls)
            ++ [
              "float,class:^(xdg-desktop-portal-gtk)$"
            ];
          layerrule = [
            "blur,bar-0"
            "blurpopups"
          ];
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
          env = [
          ];
          input = {
            repeat_rate = 50;
            repeat_delay = 300;
          };
        }
      ];
    };
  };
}
