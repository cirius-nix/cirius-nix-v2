{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.dev.lang) shell;
in
{
  options.${namespace}.dev.lang.shell = {
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
