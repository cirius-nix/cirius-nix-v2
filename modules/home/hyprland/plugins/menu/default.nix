{
  osConfig,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (osConfig.${namespace}.de) hyprland;
in
{
  config = mkIf hyprland.enable {
    programs.walker = {
      enable = true;
      runAsService = true;
      config = {
        keybinds.quick_activate = [ ];
      };
    };
    nix.settings = {
      substituters = [ "https://walker.cachix.org" ];
      trusted-public-keys = [ "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM=" ];
    };
  };
}
