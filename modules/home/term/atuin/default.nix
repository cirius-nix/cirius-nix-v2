{
  config,
  pkgs,
  namespace,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
in {
  options.${namespace}.term.atuin = {
    enable = mkEnableOption "Enable Atuin shell history manager.";
  };
  config = let
    cfg = config.${namespace}.term.atuin;
  in
    mkIf cfg.enable {
      programs.atuin = {
        enable = true;
        daemon = {
          enable = true;
        };
        enableBashIntegration = config.programs.bash.enable;
        enableFishIntegration = config.programs.fish.enable;
        enableZshIntegration = config.programs.zsh.enable;
        package = pkgs.atuin;
        settings = {};
      };
    };
}
