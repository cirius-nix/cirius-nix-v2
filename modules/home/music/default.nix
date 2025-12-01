{
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib.${namespace}) onLinux;
in
  onLinux {inherit pkgs;} {
    options.${namespace}.music = {};
    config = {
      home.packages = [
        pkgs.spotify
      ];
    };
  }
