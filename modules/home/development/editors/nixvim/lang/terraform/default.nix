{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe mkIf;
  inherit (config.${namespace}.development.lang) terraform;
  inherit (config.${namespace}.development.editors) nixvim;
in
{
  config = {
    programs.nixvim = mkIf (nixvim.enable && terraform.enable) {
      lsp.servers = {
        terraformls = {
          enable = true;
        };
      };
      plugins = {
        conform-nvim.settings = {
          formatters = {
            terraform = {
              command = getExe pkgs.terraform;
              args = [
                "fmt"
                "-no-color"
                "-"
              ];
            };
          };
          formatters_by_ft = {
            terraform = [ "terraform" ];
          };
        };
      };
    };
  };
}
