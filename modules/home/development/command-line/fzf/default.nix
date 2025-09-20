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
  inherit (config.${namespace}.dev.cli) fzf;
in
{
  options.${namespace}.dev.cli.fzf = {
    enable = mkEnableOption "Enable fzf (fuzzy finder)";
  };
  config = mkIf fzf.enable {
    stylix.targets.fzf.enable = true;
    home.packages = [ pkgs.fzf ];
  };
}
