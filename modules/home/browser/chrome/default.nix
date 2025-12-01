{
  namespace,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.${namespace}.browser) chrome;
in {
  options.${namespace}.browser.chrome = {
    enable = mkEnableOption "Enable chrome browser";
  };
  config = mkIf chrome.enable {
    home.packages = [pkgs.google-chrome];
  };
}
