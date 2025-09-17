{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.dev.editor) nixvim;
in
{
  options.${namespace}.dev.editor.nixvim.debug = {
    enable = mkEnableOption "Enable Nixvim";
  };
  config = mkIf nixvim.debug.enable {
    programs.nixvim = {
      plugins = { };
    };
  };
}
