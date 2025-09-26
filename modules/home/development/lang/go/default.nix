{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.development.lang) go;
  inherit (config.${namespace}.development.command-line) fish;
in
{
  options.${namespace}.development.lang.go = {
    enable = mkEnableOption "Enable Go Language Support";
  };
  config = mkIf go.enable {
    home.packages = with pkgs; [
      gopls
      gotools
      golangci-lint-langserver
      gofumpt
      gosimports
      goimports-reviser
      air
    ];
    programs.go = {
      enable = true;
    };
    ${namespace}.development.command-line.fish = mkIf fish.enable {
      interactiveEnvs = {
        GOBIN = "$HOME/go/bin";
      };
      paths = [ "$GOBIN" ];
    };
  };
}
