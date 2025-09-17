# SonarQube Community Build should not be run as root on Unix-based systems. It
# is recommended to create a dedicated user account for SonarQube Community Build
# Create a dedicated user account for SonarQube Community Build. Note that:
# This user does not need to have a login shell.
# This user does not need to have a password.
# We recommend that the user's home directory be the same as the installation
# directory (recommended: /opt/sonarqube).
# Grant to this user account the read/write/execute (or owner) privileges on
# the installation directory.
{
  config,
  namespace,
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ;
  inherit (lib.${namespace}) mkStrOption;

  inherit (config.${namespace}.dev) sonarqube;
  pgPort = ((osConfig.${namespace}.db).postgres).port;

  user = config.snowfallorg.user;
  # package info
  pname = "sonarqube";
  version = "25.9.0.112764";

  # make package
  pkg =
    if sonarqube.package == null then
      (pkgs.stdenv.mkDerivation {
        name = "${pname}-${version}";
        src = pkgs.fetchzip {
          url = "https://binaries.sonarsource.com/Distribution/sonarqube/${pname}-${version}.zip";
          hash = "sha256-5Gtw/65zOlA7vdeHyvQZRj70pksqAePDnFkJ2N7n6IE=";
        };
        nativeBuildInputs = [ pkgs.unzip ];
        installPhase = ''
          set -eux
          # make output dir
          mkdir -p $out
          cp -r . $out
          # make extensions download dir
          mkdir -p $out/extensions/downloads
        '';
      })
    else
      sonarqube.package;
in
{
  options.${namespace}.dev.sonarqube = {
    enable = mkEnableOption "Enable Sonarqube.";
    package = mkOption {
      type = types.nullOr types.package;
      default = null;
      description = "The Sonarqube package to use.";
    };
    postgresDB = {
      enable = mkEnableOption "Enable Postgres database support.";
      db = {
        name = mkStrOption "db/postgres/databases/sonarqube/db/name" "Sonarqube database name.";
        schema = mkStrOption "db/postgres/databases/sonarqube/db/schema" "Sonarqube database schema.";
      };
      user = {
        username = mkStrOption "db/postgres/databases/sonarqube/users/writer/username" "Sonarqube database username.";
        password = mkStrOption "db/postgres/users/sonarqube/users/writer/password" "Sonarqube database user password.";
      };
    };
    settings = mkOption {
      type = with types; attrsOf str;
      default = { };
      example = {
        "sonar.jdbc.username" = "sonar";
        "sonar.jdbc.password" = "sonar";
      };
      description = "Additional Sonarqube settings to add to sonar.properties.";
    };
  };

  config = mkIf sonarqube.enable {
    xdg = {
      dataFile."sonarqube/.keep".text = "";
      stateFile."sonarqube/.keep".text = "";
      cacheFile."sonarqube/.keep".text = "";
      configFile."sonarqube/config.env".text =
        let
          inherit (sonarqube) postgresDB;
          settings =
            lib.foldl' lib.recursiveUpdate
              {
                "SONAR_JAVA_PATH" = lib.getExe' pkgs.jdk21_headless "java";
                "SONAR_TELEMETRY_ENABLE" = "false";
                "SONAR_PATH_DATA" = "${user.home.directory}/.local/share/sonarqube/data";
                "SONAR_PATH_TEMP" = "${user.home.directory}/.cache/sonarqube/temp";
                "SONAR_LOG_LEVEL" = "INFO";
                "SONAR_PATH_LOGS" = "${user.home.directory}/.local/state/sonarqube/logs";
                "SONAR_LOG_JSONOUTPUT" = "false";
              }
              [
                sonarqube.settings
                (lib.optionalAttrs postgresDB.enable (
                  let
                    inherit (config.sops) placeholder;
                    dbName = placeholder."${postgresDB.db.name}";
                    schema = placeholder."${postgresDB.db.schema}";
                    username = placeholder."${postgresDB.writer.username}";
                    password = placeholder."${postgresDB.writer.password}";
                    dbURL = "jdbc:postgresql://localhost:${builtins.toString pgPort}/${dbName}?currentSchema=${schema}";
                  in
                  {
                    SONAR_JDBC_URL = "${dbURL}";
                    SONAR_JDBC_USERNAME = "${username}";
                    SONAR_JDBC_PASSWORD = "${password}";
                  }
                ))
              ];
          mkKeyValue = k: v: "${k}=\"${v}\"\n";
        in
        lib.concatStringsSep "" (lib.mapAttrsToList mkKeyValue settings);
    };
    systemd.user.services.sonarqube =
      let
        workDir = "${pkg}";
        execStart = ''
          ${pkgs.jdk21_headless}/bin/java \
            -Xmx2G -Xms512M \
            -jar ${workDir}/lib/sonar-application-${version}.jar
        '';
      in
      {
        Unit = {
          Description = "SonarQube Service";
          Wants = [ "network.target" ];
          After = [
            "syslog.target"
            "network.target"
          ];
        };
        Service = {
          ExecStart = execStart;
          Restart = "on-failure";
          RestartSec = "10s";
          WorkingDirectory = workDir;
          EnvironmentFile = "%h/.config/sonarqube/config.env";
          LimitNOFILE = 65536;
          LimitNPROC = 8192;
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
  };
}
