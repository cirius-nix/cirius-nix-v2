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
  inherit (config.${namespace}.dev.editor) hx;
in
{
  options.${namespace}.dev.editor.hx = {
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
