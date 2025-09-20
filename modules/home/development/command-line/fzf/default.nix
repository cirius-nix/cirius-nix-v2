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
    ;
  inherit (config.${namespace}.development.command-line) fzf;
in
{
  options.${namespace}.development.command-line.fzf = {
    enable = mkEnableOption "Enable fzf (fuzzy finder)";
  };
  config = mkIf fzf.enable {
    stylix.targets.fzf.enable = true;
    home.packages = [ pkgs.fzf ];
  };
}
