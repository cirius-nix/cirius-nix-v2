{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: {
  options.${namespace}.base.database.neo4j = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Neo4j graph database service.";
    };
  };
  config = lib.mkIf config.${namespace}.base.database.neo4j.enable {
    services.neo4j = {
      enable = true;
      package = pkgs.neo4j;
      bolt = {
        enable = true;
        listenAddress = ":7680";
      };
      extraServerConfig = "";
      directories = {
        home = "/var/lib/neo4j";
        data = "/var/lib/neo4j/data";
      };
    };
  };
}
