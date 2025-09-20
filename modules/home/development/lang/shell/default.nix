{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.development.lang) shell;
in
{
  options.${namespace}.development.lang.shell = {
    enable = mkEnableOption "Enable shell Language Support";
  };
  config = mkIf shell.enable {
    home.packages = [
      pkgs.bash-language-server
      pkgs.shellcheck
      pkgs.shfmt
      pkgs.dotenv-linter
    ];
  };
}
