{
  pkgs,
  lib,
  osConfig ? {},
  ...
}: let
  namespace = "cirius-v2";
in {
  config = {
    ${namespace} = lib.${namespace}.gnome.applyAttrOnEnabled {inherit namespace pkgs osConfig;} {
      gnome = {
        panel = {
          top.enable = true;
        };
      };
    };
    home.file.".config/monitors.xml".file = ../monitors.xml;
  };
}
