{
  pkgs,
  config,
  namespace,
  lib,
  options,
  ...
}: let
  defaultPackage = pkgs.postgresql_17;
in {
  options.${namespace}.base.database.postgres = {
    enable = lib.mkEnableOption "Enable and configure PostgreSQL database server.";
    package = lib.mkOption {
      type = lib.types.package;
      default = defaultPackage;
      description = "PostgreSQL package to use.";
    };
    settings = options.services.postgresql.settings;
    adminPasswordPath = lib.mkOption {
      type = lib.types.str;
      default = "postgres/admin_password";
      description = "Path to admin password in SOPS.";
    };
    extensions = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "List of PostgreSQL extensions to install.";
    };
  };
  config = let
    postgresCfg = config.${namespace}.base.database.postgres;
  in
    lib.mkIf postgresCfg.enable {
      environment.systemPackages = with pkgs; [
        pgcli
      ];
      sops = {
        templates = {
          "postgresqlInitialScript" = {
            # owner = "postgres";
            # group = "postgres";
            mode = "0440";
            content = let
              password = config.sops.placeholder.${postgresCfg.adminPasswordPath};
            in ''
              ALTER SYSTEM SET password_encryption = 'scram-sha-256';
              SELECT pg_reload_conf();
              CREATE ROLE dbadmin WITH LOGIN PASSWORD '${password}' SUPERUSER CREATEDB CREATEROLE;
            '';
          };
        };
      };
      networking.firewall.allowedTCPPorts = [postgresCfg.settings.port];
      services.postgresql =
        {
          enable = true;
          inherit (postgresCfg) settings;
          package = postgresCfg.package;
          dataDir = "/var/lib/postgresql/${postgresCfg.package.psqlSchema}";
          # https://www.postgresql.org/docs/current/auth-pg-hba-conf.html

          authentication = lib.mkOverride 10 ''
            #TYPE DATABASE  USER    ADDRESS/CIDR  METHOD
            local all       postgres              peer
            local all       all                   scram-sha-256
            host  all       all     127.0.0.1/32  scram-sha-256
            host  all       all     ::1/128       scram-sha-256
            host  all       all     0.0.0.0/0     scram-sha-256
          '';
          enableTCPIP = true;
          initialScript = config.sops.templates."postgresqlInitialScript".path;
        }
        // (lib.optionalAttrs pkgs.stdenv.isLinux {
          enableJIT = true;
          inherit (postgresCfg) extensions;
        })
        // (lib.optionalAttrs pkgs.stdenv.isDarwin {
          extraPlugins = postgresCfg.extensions;
        });
    };
}
