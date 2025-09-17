{
  namespace,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.${namespace}.browser) floorp;
in
{
  options.${namespace}.browser.floorp = {
    enable = mkEnableOption "Enable Floorp browser";
  };
  config = mkIf floorp.enable {
    programs.floorp = {
      enable = true;
    };
  };
}
