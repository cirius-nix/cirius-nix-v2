{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkIntOption mkStrOption;
  inherit (config.${namespace}.db) postgres;
in
{
  options.${namespace}.db.postgres = {
    enable = mkEnableOption "Enable Postgres.";
    port = mkIntOption 5432 "The port Postgres listens on.";
    sops.masterPassword = mkStrOption "db/postgres/masterPassword" "The master password key in sops.";
  };
  config = mkIf postgres.enable {
    sops = {
      templates."postgresqlInitialScript" =
        let
          inherit (postgres.sops.keys) masterPassword;
          inherit (config.sops) placeholder;
          changePostgresPasswordStmt = ''
            ALTER SYSTEM SET password_encryption = 'scram-sha-256';
            SELECT pg_reload_conf();
            ALTER USER postgres WITH PASSWORD '${placeholder.${masterPassword}}';
          '';
          content = lib.concatStringsSep "\n\n" [
            changePostgresPasswordStmt
            # INFO: add more initial SQL statements here
          ];

        in
        {
          owner = "postgres";
          group = "postgres";
          mode = "0440";
          content = builtins.trace content content;
        };
    };
    services.postgresql = {
      inherit (postgres) enable;
      package = pkgs.postgresql_17;
      # https://www.postgresql.org/docs/current/auth-pg-hba-conf.html

      authentication = lib.mkOverride 10 ''
        #TYPE DATABASE  USER    ADDRESS       METHOD
        local all       postgres              peer
        local all       all                   scram-sha-256
        host  all       all     127.0.0.1/32  scram-sha-256
        host  all       all     ::1/128       scram-sha-256
        # TODO: modify CIDR ranges as needed instead of allowing all
        # (0.0.0/0)
        # host  all       all     0.0.0.0/0     scram-sha-256
      '';
      enableTCPIP = true;
      ensureUsers = [ ];
      initialScript = config.sops.templates."postgresqlInitialScript".path;
      settings = {
        port = postgres.port;
      };
    };
  };
}
