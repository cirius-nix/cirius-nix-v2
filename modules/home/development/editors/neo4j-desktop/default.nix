{
  config,
  osConfig ? {},
  lib,
  namespace,
  pkgs,
  ...
}: {
  options.${namespace}.development.editors.neo4j-desktop = {
    enable = lib.mkEnableOption "Enable Neo4j Desktop application.";
  };
  config = let
    osEnabledNeo4j = lib.attrByPath [namespace "base" "database" "neo4j" "enable"] false osConfig;
  in
    lib.mkIf (config.${namespace}.development.editors.neo4j-desktop.enable || osEnabledNeo4j) {
      home.packages = with pkgs; [
        neo4j-desktop
      ];
    };
}
