{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.dev.lang) go;
  inherit (config.${namespace}.dev.cli) fish;
in
{
  options.${namespace}.dev.lang.go = {
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
    ];
    programs.go = {
      enable = true;
    };
    ${namespace}.dev.cli.fish = mkIf fish.enable {
      interactiveEnvs = {
        GOBIN = "$HOME/go/bin";
      };
      paths = [ "$GOBIN" ];
    };
  };
}
