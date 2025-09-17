{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.${namespace}.ai) gemini;
  inherit (lib)
    mkIf
    mkEnableOption
    ;
in
{
  options.${namespace}.ai.gemini = {
    enable = mkEnableOption "Enable Gemini CLI";
  };
  config = mkIf gemini.enable {
    home.packages = with pkgs; [
      gemini-cli
    ];
  };
}
