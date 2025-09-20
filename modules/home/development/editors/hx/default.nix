{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  inherit (config.${namespace}.development.editors) hx;
in
{
  options.${namespace}.development.editors.hx = {
    enable = mkEnableOption "Enable Helix Editor";
    package = mkOption {
      type = types.package;
      default = pkgs.evil-helix;
      description = "Package to use for Helix Editor";
    };
  };
  config = mkIf hx.enable {
    home.packages = [ hx.package ];
  };
}
