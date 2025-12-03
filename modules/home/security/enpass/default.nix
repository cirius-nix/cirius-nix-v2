params: let
  inherit (params) lib namespace osConfig pkgs;
in
  lib.${namespace}.settingByOS params {
    linux.config = let
      inherit (lib) mkIf;
      cfg = (osConfig.${namespace}.security).enpass;
    in
      mkIf cfg.enable {
        home.packages = with pkgs; [enpass-cli enpass];
        xdg.autostart.entries = ["${pkgs.enpass}/share/applications/enpass.desktop"];
      };
  }
