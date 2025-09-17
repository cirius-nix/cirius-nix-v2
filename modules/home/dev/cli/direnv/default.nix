{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.dev.cli) direnv;
in
{
  options.${namespace}.dev.cli.direnv = {
    enable = mkEnableOption "Enable Direnv";
  };
  config = mkIf direnv.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
