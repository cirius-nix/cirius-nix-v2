{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (config.${namespace}.development.editors) nixvim;
in
{
  config = mkIf (nixvim.enable && nixvim.ai) {
    programs.nixvim.plugins.avante = {
      enable = true;
      settings = {
        provider = "copilot";
      };
    };
  };
}
