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
    getExe'
    ;
  inherit (config.${namespace}.dev) lang;
  inherit (config.${namespace}.dev.editor) nixvim;
in
{
  config = mkIf (lang.go.enable && nixvim.enable) {
    programs.nixvim = {
      lsp.servers = {
        gopls = {
          enable = true;
          settings = {
            gopls = {
              analyses = {
                unusedparams = true;
                shadow = true;
              };
              staticcheck = true;
            };
          };
        };
      };
      plugins = {
        conform-nvim.settings = {
          formatters = {
            gofumpt = {
              command = getExe pkgs.gofumpt;
            };
            goimports = {
              command = getExe' pkgs.gotools "goimports";
            };
          };
          formatters_by_ft = {
            go = [
              "goimports"
              "gofumpt"
            ];
          };
        };
        neotest = {
          adapters.go = {
            enable = true;
            settings = {
              args = {
                __raw = ''
                  {
                    "-v",
                    "-race",
                    "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
                  }
                '';
              };
            };
          };
        };
      };
    };
  };
}
