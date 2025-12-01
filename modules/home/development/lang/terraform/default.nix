{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption;
in {
  options.${namespace}.development.lang.terraform = {
    enable = mkEnableOption "Enable Terraform Language Support";
  };
  config = let
    inherit (lib) mkIf;
    cfg = config.${namespace}.development.lang.terraform;
  in
    mkIf cfg.enable {
      home.packages = with pkgs; [
        terraform
        terraform-ls
        tflint
        tfsec
      ];
      programs.nixvim = {
        lsp.servers = lib.${namespace}.enableAll ["terraformls"] {};
        plugins = {
          conform-nvim.settings = {
            formatters = {
              terraform = {
                command = lib.getExe pkgs.terraform;
                args = [
                  "fmt"
                  "-no-color"
                  "-"
                ];
              };
            };
            formatters_by_ft = {
              terraform = ["terraform"];
            };
          };
        };
      };
    };
}
