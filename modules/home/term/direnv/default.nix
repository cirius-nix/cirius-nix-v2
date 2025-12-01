{
  config,
  namespace,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption;
in {
  options.${namespace}.term.direnv = {
    enable = mkEnableOption "Enable Direnv";
  };
  config = let
    inherit (lib) mkIf;
    cfg = config.${namespace}.term.direnv;
  in
    mkIf cfg.enable {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
}
