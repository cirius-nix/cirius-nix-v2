{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    getExe
    ;
  inherit (config.${namespace}.development.command-line) fish;
in
{
  config = {
    ${namespace} = {
      development.command-line = mkIf fish.enable {
        fish = {
          interactiveCMDs = {
            fastfetch = {
              command = getExe pkgs.fastfetch;
              args = [ ];
            };
          };
        };
      };
    };
    programs.fastfetch = {
      enable = true;
      settings = { };
    };
  };
}
