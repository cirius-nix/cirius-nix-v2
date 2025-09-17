{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.dev) sonarqube;
in
{
  options.${namespace}.dev.sonarqube = {
    enable = mkEnableOption "Enable SonarQube development environment.";
    postgres = {
      enable = mkEnableOption "Enable Postgres for SonarQube.";
    };
  };
  config = mkIf sonarqube.enable {
  };
}
