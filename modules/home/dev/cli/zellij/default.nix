{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.dev.cli) zellij;

  mkBindAct = shortcuts: actionName: action: {
    "bind \"${shortcuts}\"" = {
      "${actionName}" = action;
    };
  };
  mkBindsAct =
    list: actionName: action:
    lib.foldl' lib.recursiveUpdate { } (map (s: mkBindAct s actionName action) list);

  # mapActs is a attribute set of actions
  mkBindActs = shortcuts: mapActs: {
    "bind \"${shortcuts}\"" = mapActs;
  };
  mkBindSm = shortcuts: mode: mkBindAct shortcuts "SwitchToMode" mode;
  mkBindsSm = list: mode: mkBindsAct list "SwitchToMode" mode;
  mkBindMoveFocus =
    shortcuts: direction:
    mkBindActs shortcuts {
      "MoveFocus" = direction;
      "SwitchToMode" = "Locked";
    };
in
{
  options.${namespace}.dev.cli.zellij = {
    enable = mkEnableOption "Enable zellij terminal workspace";
    leader = lib.mkOption {
      type = lib.types.str;
      default = "Ctrl a";
      description = "Leader key for zellij";
    };
  };
  config = mkIf zellij.enable {
    stylix.targets.zellij.enable = true;
    xdg.configFile."zellij/layouts/dev-2.kdl".text = ''
      layout {
        pane split_direction="horizontal" {
          pane size="70%"
          pane size="30%"
        }
      }
    '';
    programs.zellij = {
      enable = true;
      enableFishIntegration = config.programs.fish.enable;
      settings = {
        simplified_ui = true;
        show_startup_tips = false;
        default_mode = "locked";
        mose_mode = true;
        scrollback_editor = lib.getExe pkgs.neovim;
        "keybinds clear-defaults=true" = {
          locked = lib.foldl' lib.recursiveUpdate { } [
            (mkBindSm zellij.leader "Normal")
          ];
          normal = lib.foldl' lib.recursiveUpdate { } [
            (mkBindsSm [ zellij.leader "ESC" "Enter" "Space" ] "Locked")
            (mkBindSm "p" "Pane")
            (mkBindSm "m" "Move")
            (mkBindSm "t" "Tab")
            (mkBindSm "r" "Resize")
            (mkBindSm "w" "Session")
            (mkBindSm "s" "Scroll")
            (mkBindMoveFocus "h" "Left")
            (mkBindMoveFocus "l" "Right")
            (mkBindMoveFocus "j" "Down")
            (mkBindMoveFocus "k" "Up")
            (mkBindActs "1" {
              "GoToTab" = 1;
              "SwitchToMode" = "Locked";
            })
            (mkBindActs "2" {
              "GoToTab" = 2;
              "SwitchToMode" = "Locked";
            })
            (mkBindActs "3" {
              "GoToTab" = 3;
              "SwitchToMode" = "Locked";
            })
            (mkBindActs "4" {
              "GoToTab" = 4;
              "SwitchToMode" = "Locked";
            })
            (mkBindActs "5" {
              "GoToTab" = 5;
              "SwitchToMode" = "Locked";
            })
            (mkBindActs "6" {
              "GoToTab" = 6;
              "SwitchToMode" = "Locked";
            })
            (mkBindActs "7" {
              "GoToTab" = 7;
              "SwitchToMode" = "Locked";
            })
            (mkBindActs "8" {
              "GoToTab" = 8;
              "SwitchToMode" = "Locked";
            })
            (mkBindActs "9" {
              "GoToTab" = 9;
              "SwitchToMode" = "Locked";
            })
          ];
          pane = lib.foldl' lib.recursiveUpdate { } [
            (mkBindSm "ESC" "Locked")
            (mkBindsSm [ zellij.leader ] "Normal")
            (mkBindMoveFocus "h" "Left")
            (mkBindMoveFocus "l" "Right")
            (mkBindMoveFocus "j" "Down")
            (mkBindMoveFocus "k" "Up")
            (mkBindActs "n" {
              "NewPane" = "Right";
              "SwitchToMode" = "Locked";
            })
            (mkBindActs "v" {
              "NewPane" = "Right";
              "SwitchToMode" = "Locked";
            })
            (mkBindActs "d" {
              "NewPane" = "Down";
              "SwitchToMode" = "Locked";
            })
            (mkBindActs "x" {
              "NewPane" = "Down";
              "SwitchToMode" = "Locked";
            })
            (mkBindActs "f" {
              "ToggleFocusFullscreen" = { };
              "SwitchToMode" = "Locked";
            })
            (mkBindActs "r" {
              "SwitchToMode" = "RenamePane";
              "PaneNameInput" = 0;
            })
            (mkBindActs "t" {
              "NewTab" = { };
              "SwitchToMode" = "Locked";
            })
            (mkBindSm "R" "Resize")
            (mkBindSm "m" "Move")
          ];
          move = lib.foldl' lib.recursiveUpdate { } [
            (mkBindsSm [ "ESC" "m" "Enter" ] "Locked")
            (mkBindsSm [ zellij.leader ] "Normal")
            (mkBindActs "Tab" {
              "MovePane" = { };
            })
            (mkBindActs "h" {
              "MovePane" = "Left";
            })
            (mkBindActs "l" {
              "MovePane" = "Right";
            })
            (mkBindActs "j" {
              "MovePane" = "Down";
            })
            (mkBindActs "k" {
              "MovePane" = "Up";
            })
          ];
          tab = lib.foldl' lib.recursiveUpdate { } [
            (mkBindsSm [ "ESC" "Enter" ] "Locked")
            (mkBindsSm [ zellij.leader ] "Normal")
            (mkBindActs "r" {
              "SwitchToMode" = "RenameTab";
              "TabNameInput" = 0;
            })
            (mkBindActs "1" {
              "GoToTab" = 1;
              "SwitchToMode" = "Locked";
            })
            (mkBindActs "2" {
              "GoToTab" = 2;
              "SwitchToMode" = "Locked";
            })
            (mkBindActs "3" {
              "GoToTab" = 3;
              "SwitchToMode" = "Locked";
            })
            (mkBindActs "4" {
              "GoToTab" = 4;
              "SwitchToMode" = "Locked";
            })
            (mkBindActs "5" {
              "GoToTab" = 5;
              "SwitchToMode" = "Locked";
            })
            (mkBindActs "6" {
              "GoToTab" = 6;
              "SwitchToMode" = "Locked";
            })
            (mkBindActs "7" {
              "GoToTab" = 7;
              "SwitchToMode" = "Locked";
            })
            (mkBindActs "8" {
              "GoToTab" = 8;
              "SwitchToMode" = "Locked";
            })
            (mkBindActs "9" {
              "GoToTab" = 9;
              "SwitchToMode" = "Locked";
            })
            (mkBindActs "Tab" {
              "ToggleTab" = { };
            })
            (mkBindActs "n" {
              "NewTab" = { };
              "SwitchToMode" = "Locked";
            })
          ];
          renametab = lib.foldl' lib.recursiveUpdate { } [
            (mkBindActs "Enter" {
              "SwitchToMode" = "Locked";
            })
            (mkBindActs "ESC" {
              "UndoRenameTab" = { };
              "SwitchToMode" = "Locked";
            })
          ];
          resize = lib.foldl' lib.recursiveUpdate { } [
            (mkBindsSm [ "ESC" "R" "Enter" ] "Locked")
            (mkBindsSm [ zellij.leader ] "Normal")
            (mkBindActs "h" {
              "Resize" = "Increase Left";
            })
            (mkBindActs "l" {
              "Resize" = "Increase Right";
            })
            (mkBindActs "j" {
              "Resize" = "Increase Down";
            })
            (mkBindActs "k" {
              "Resize" = "Increase Up";
            })
          ];
          session = lib.foldl' lib.recursiveUpdate { } [
            (mkBindSm "ESC" "Locked")
            (mkBindsSm [ zellij.leader ] "Normal")
            (mkBindActs "n" {
              "LaunchOrFocusPlugin \"session-manager\"" = {
                "floating" = true;
                "move_to_focused_tab" = true;
              };
            })
          ];
          scroll = lib.foldl' lib.recursiveUpdate { } [
            (mkBindSm "ESC" "Locked")
            (mkBindsSm [ zellij.leader ] "Normal")
            (mkBindActs "Space" {
              "PageScrollDown" = { };
            })
            (mkBindActs "b" {
              "PageScrollUp" = { };
            })
            (mkBindActs "f" {
              "PageScrollDown" = { };
            })
            (mkBindActs "d" {
              "HalfPageScrollDown" = { };
            })
            (mkBindActs "u" {
              "HalfPageScrollUp" = { };
            })
            (mkBindActs "j" {
              "ScrollDown" = { };
            })
            (mkBindActs "k" {
              "ScrollUp" = { };
            })
            (mkBindActs "s" {
              "SwitchToMode" = "EnterSearch";
              "SearchInput" = 0;
            })
            (mkBindActs "e" {
              "EditScrollback" = { };
              "SwitchToMode" = "Locked";
            })
          ];
          entersearch = lib.foldl' lib.recursiveUpdate { } [
            (mkBindSm "ESC" "Scroll")
            (mkBindsSm [ zellij.leader ] "Normal")
            (mkBindSm "Enter" "Search")
          ];
          search = lib.foldl' lib.recursiveUpdate { } [
            (mkBindSm "ESC" "Scroll")
            (mkBindSm zellij.leader "Normal")
            (mkBindActs "G" {
              "ScrollToBottom" = { };
            })
            (mkBindActs "f" {
              "PageScrollDown" = { };
            })
            (mkBindActs "b" {
              "PageScrollUp" = { };
            })
            (mkBindActs "d" {
              "HalfPageScrollDown" = { };
            })
            (mkBindActs "u" {
              "HalfPageScrollUp" = { };
            })
            (mkBindActs "j" {
              "Search" = "down";
            })
            (mkBindActs "k" {
              "Search" = "up";
            })
            (mkBindActs "c" {
              "SearchToggleOption" = "CaseSensitivity";
            })
            (mkBindActs "a" {
              "SearchToggleOption" = "Wrap";
            })
            (mkBindActs "w" {
              "SearchToggleOption" = "WholeWord";
            })
          ];
          renamepane = lib.foldl' lib.recursiveUpdate { } [
            (mkBindActs "Enter" {
              "SwitchToMode" = "Locked";
            })
            (mkBindActs "ESC" {
              "UndoRenamePane" = { };
              "SwitchToMode" = "Locked";
            })
          ];
        };
      };
    };
  };
}
