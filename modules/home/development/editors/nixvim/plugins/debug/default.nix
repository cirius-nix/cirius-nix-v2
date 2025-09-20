{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.development.editors) nixvim;
in
{
  options.${namespace}.development.editors.nixvim.debug = {
    enable = mkEnableOption "Enable Nixvim";
  };
  config = mkIf nixvim.debug.enable {
    programs.nixvim = {
      plugins = { };
    };
  };
}
