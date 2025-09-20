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
  inherit (config.${namespace}.dev.cli) fish;
in
{
  config = {
    ${namespace} = {
      dev.cli = mkIf fish.enable {
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
