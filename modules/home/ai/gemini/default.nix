{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: {
  options.${namespace}.ai.gemini = {
    enable = lib.mkEnableOption "Enable Gemini CLI";
  };
  config = let
    inherit (config.${namespace}.ai) gemini;
    inherit (lib) mkIf;
  in
    mkIf gemini.enable {
      home.packages = with pkgs; [
        gemini-cli
      ];
    };
}
