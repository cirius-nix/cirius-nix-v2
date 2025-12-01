{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.development.editors) gedit;
in {
  options.${namespace}.development.editors.gedit = {
    enable = mkEnableOption "Enable Gedit Editor";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.gedit;
      description = "Package to use for Gedit Editor";
    };
  };
  config = mkIf gedit.enable {
    home.packages = [gedit.package];
  };
}
