{
  osConfig ? {},
  namespace,
  lib,
  pkgs,
  ...
} @ inputs:
lib.${namespace}.linux.withInputModule inputs {
  config = let
    inherit (lib) mkIf;
    inherit (osConfig.${namespace}.security) enpass;
  in
    mkIf enpass.enable ({
        home.packages = with pkgs; [
          enpass-cli
        ];
      }
      // (lib.${namespace}.hyprland.applyAttrOnEnabled inputs {
        ${namespace}.hyprland.app.list = [
          {
            id = "enpass";
            command = "Enpass";
            floatedBy = "class";
            class = "Enpass";
            size = "500 600";
            pinned = true;
            move = "100%-w-20 100";
          }
          {
            id = "enpass-assistant";
            floatedBy = "title";
            titleName = "Enpass Assistant";
            class = "Enpass";
            move = "100%-w-20 100";
            forceFocus = true;
            focusedBy = "title";
          }
        ];
      }));
}
