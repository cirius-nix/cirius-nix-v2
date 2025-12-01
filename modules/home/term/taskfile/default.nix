{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption;
in {
  options.${namespace}.term.taskfile = {
    enable = mkEnableOption "Enable Taskfile. (Alternative to Make)";
  };
  config = let
    inherit (lib) mkIf;
    cfg = config.${namespace}.term.taskfile;
  in
    mkIf cfg.enable {
      home.packages = with pkgs; [
        go-task
      ];
    };
}
