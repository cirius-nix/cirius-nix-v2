{
  config,
  namespace,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkForce;
  inherit (lib.${namespace}) mkStrOption;
  inherit (osConfig.${namespace}.de) hyprland;
  hyprlandHome = config.${namespace}.hyprland;

  # alias map attribute set from k:v to to $k:v
  aliases = lib.attrsets.mapAttrs' (name: value: {
    name = "$" + "${name}";
    inherit value;
  }) hyprlandHome.aliases;

  # from 1 to 9
  wsBindings = builtins.concatLists (
    builtins.genList (
      i:
      let
        ws = i + 1;
      in
      [
        "$mod, code:1${toString i}, workspace, ${toString ws}"
        "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
      ]
    ) 9
  );
in
{
  options.${namespace}.hyprland = {
    aliases = {
      mod = mkStrOption "SUPER" "Main modifier";
      browser = mkStrOption "MOZ_LEGACY_PROFILES=1 zen" "Browser";
      privateBrowser = mkStrOption "MOZ_LEGACY_PROFILES=1 zen --private-window" "Private browser";
      terminal = mkStrOption "alacritty" "Terminal";
      fileManager = mkStrOption "alacritty -e nnn" "File manager";
      menu = mkStrOption "walker" "Menu executor";
      ai = mkStrOption ''alacritty -e "tgpt --interactive-shell"'' "AI";
      raiseVol = mkStrOption ''wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+'' "Increase volume";
      lowerVol = mkStrOption ''wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-'' "Decrease volume";
      muteVol = mkStrOption ''wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'' "Mute volume";
    };
  };
  config = mkIf hyprland.enable {
    stylix.targets = {
      hyprland.enable = true;
      hyprpaper.enable = true;
      hyprlock.enable = true;
    };
    programs.kitty.enable = true; # required for hyprland.
    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };
    gtk = {
      enable = true;
      theme = {
        package = pkgs.flat-remix-gtk;
        name = "Flat-Remix-GTK-Grey-Darkest";
      };
      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };
      font = {
        name = "Sans";
        size = 11;
      };
    };
    services.hyprpaper.enable = true;
    # ensure these variables should not be modified by any profile.
    wayland.windowManager.hyprland = {
      systemd.variables = mkForce [ "--all" ];
      enable = mkForce true;
      package = mkForce null;
      portalPackage = mkForce null;
      extraConfig = ''
        exec-once = fcitx5 -d
        exec-once = systemctl --user start hyprpolkitagent
      '';
      settings = lib.foldl' lib.recursiveUpdate { } [
        aliases
        {
          # ps -eo pid,comm --sort=comm | grep -iE "firefox|kitty|code|steam|alacritty"
          bind = [
            "$mod, b, exec, $browser"
            "$mod SHIFT, B, exec, $privateBrowser"
            "$mod, Return, exec, $terminal"
            "$mod, Q, killactive,"
            "$mod SHIFT, Q, forcekillactive,"
            "$mod, E, exec, $fileManager"
            "$mod, Space, exec, $menu"
            "$mod, A, exec, $ai"
            "$mod, Escape, exec, hyprctl dispatch exit"
            "$mod, F, fullscreen, 1"
            ", XF86AudioRaiseVolume, exec, $raiseVol"
            ", XF86AudioLowerVolume, exec, $lowerVol"
            ", XF86AudioMute, exec, $muteVol"
          ]
          ++ wsBindings;
        }
        {
          decoration = {
            rounding = 8;
          };
        }
      ];
    };
  };
}
