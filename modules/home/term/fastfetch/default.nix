{
  namespace,
  lib,
  pkgs,
  ...
}: {
  config = {
    ${namespace}.term.fish = {
      interactiveCMDs.fastfetch = {
        command = lib.getExe pkgs.fastfetch;
        args = [];
      };
    };
    programs.fastfetch = {
      enable = true;
      settings = {};
    };
  };
}
