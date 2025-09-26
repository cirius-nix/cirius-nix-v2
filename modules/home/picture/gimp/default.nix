{
  pkgs,
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.picture) gimp;
in
{
  options.${namespace}.picture.gimp = {
    enable = mkEnableOption "Enable GIMP image editor.";
  };
  config = mkIf gimp.enable {
    home.packages = [ pkgs.gimp ];
  };
}
