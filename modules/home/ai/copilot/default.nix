{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: let
  inherit (config.${namespace}.ai) copilot;
  inherit
    (lib)
    mkIf
    mkEnableOption
    ;
in {
  options.${namespace}.ai.copilot = {
    enable = mkEnableOption "Enable GitHub Copilot CLI";
  };
  config = mkIf copilot.enable {
    home.packages = [
      pkgs.github-copilot-cli
    ];
  };
}
