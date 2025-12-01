{
  config,
  namespace,
  lib,
  ...
} @ params:
lib.${namespace}.kde.applyAttrOnEnabled params {
  options.${namespace}.kde = {
    ciriusShortcuts = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable custom shortcuts for Cirius.";
    };
  };
  config = lib.mkIf config.${namespace}.kde.ciriusShortcuts {
    ${namespace}.kde.disableDefaultShortcuts = lib.mkForce true;
    programs.plasma = {
      shortcuts = let
        # utilities
        normalizeIndex = i:
          if i == 10
          then 0
          else i;
        normalizeIndex' = i: toString (normalizeIndex i);

        specialIndex' = i: let
          mapIndexChars = {
            "0" = ")";
            "1" = "!";
            "2" = "@";
            "3" = "#";
            "4" = "$";
            "5" = "%";
            "6" = "^";
            "7" = "&";
            "8" = "*";
            "9" = "(";
          };
        in
          mapIndexChars.${(normalizeIndex' i)};

        # Window management shortcuts
        winMgt = let
          moving =
            # Activating and moving windows to virtual desktops and screens.
            (
              builtins.listToAttrs (
                builtins.concatLists (
                  map (
                    i: [
                      {
                        name = "Switch to Desktop ${toString i}";
                        value = lib.mkForce "Meta+${normalizeIndex' i}";
                      }
                      {
                        name = "Switch to Screeen ${toString i}";
                        value = lib.mkForce "Meta+Ctrl+${normalizeIndex' i}";
                      }
                      {
                        name = "Window to Desktop ${toString i}";
                        value = lib.mkForce "Meta+${specialIndex' i}";
                      }
                      {
                        name = "Window to Screen ${toString i}";
                        value = lib.mkForce "Meta+Ctrl+${specialIndex' i}";
                      }
                    ]
                  ) (builtins.genList (i: i + 1) 10)
                )
              )
            )
            //
            # Moving windows between virtual desktops and screens.
            {
              "Window to Next Desktop" = lib.mkForce "Meta+Shift+Right";
              "Window to Next Screen" = lib.mkForce "Meta+Shift+Ctrl+Right";
              "Window to Previous Desktop" = lib.mkForce "Meta+Shift+Left";
              "Window to Previous Screen" = lib.mkForce "Meta+Shift+Ctrl+Left";
            }
            //
            # Moving windows to edge of current desktop
            {
              "Window Quick Tile Left" = lib.mkForce "Meta+Left";
              "Window Quick Tile Right" = lib.mkForce "Meta+Right";
              "Window Quick Tile Top" = lib.mkForce "Meta+Up";
              "Window Quick Tile Bottom" = lib.mkForce "Meta+Down";
              "Window Move Center" = lib.mkForce "Meta+Space";
            };
          view = {
            view_actual_size = lib.mkForce "none";
            view_zoom_in = lib.mkForce "Meta+=";
            view_zoom_out = lib.mkForce "Meta+-";
          };

          # state of windows
          state = {
            "Window Fullscreen" = lib.mkForce "Meta+F11";
            "Window Maximize" = lib.mkForce "Meta+Shift+Space";
          };
        in
          moving // view // state;
      in {
        "kwin" =
          {
            "Window Close" = lib.mkForce "Meta+Q";
            "Walk Through Windows" = lib.mkForce "Alt+Tab";
          }
          // winMgt;
      };
      hotkeys.commands."alacritty" = {
        name = "Launch Alacritty";
        key = "Ctrl+Alt+T";
        command = "alacritty";
      };

      configFile = {
        kwinrc = {
          # To make window switcher include all virtual desktops in current screen.
          "TabBox"."DesktopMode" = 0;
        };
      };
    };
  };
}
