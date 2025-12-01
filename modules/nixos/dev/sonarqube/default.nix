{
  config,
  namespace,
  lib,
  ...
}: {
  options.${namespace}.dev.sonarqube = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable SonarQube development environment.";
    };
  };
  config = lib.mkIf config.${namespace}.dev.sonarqube.enable {
    services.postgresql = {
      ensureDatabases = ["sonarqube"];
    };
  };
}
