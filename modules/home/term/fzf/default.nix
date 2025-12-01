{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption;
in {
  options.${namespace}.term.fzf = {
    enable = mkEnableOption "Enable fzf (fuzzy finder)";
  };
  config = let
    inherit (lib) mkIf;
    cfg = config.${namespace}.term.fzf;
  in
    mkIf cfg.enable {
      stylix.targets.fzf.enable = true;
      home.packages = [pkgs.fzf];
    };
}
