{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.dev.cli) taskfile;
in
{
  options.${namespace}.dev.cli.taskfile = {
    enable = mkEnableOption "Enable Taskfile. (Alternative to Make)";
  };
  config = mkIf taskfile.enable {
    home.packages = with pkgs; [
      go-task
    ];
  };
}
