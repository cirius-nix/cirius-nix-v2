{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.development.command-line) taskfile;
in
{
  options.${namespace}.development.command-line.taskfile = {
    enable = mkEnableOption "Enable Taskfile. (Alternative to Make)";
  };
  config = mkIf taskfile.enable {
    home.packages = with pkgs; [
      go-task
    ];
  };
}
