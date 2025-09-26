{
  pkgs,
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.picture) krita;
in
{
  options.${namespace}.picture.krita = {
    enable = mkEnableOption "Enable krita image editor.";
  };
  config = mkIf krita.enable {
    home.packages = [ pkgs.krita ];
  };
}
