{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf getExe;
  inherit (config.${namespace}.development) lang;
  inherit (config.${namespace}.development.editors) nixvim;
in
{
  options.${namespace}.development.editors.nixvim.lang.shell = {
  };
  config = mkIf (nixvim.enable && lang.shell.enable) {
    home.packages = [
      pkgs.fish-lsp
    ];
    programs.nixvim = {
      lsp.servers = {
        bashls = {
          enable = true;
          settings = {
            bashIde = {
              globPattern = "**/*@(.sh|.inc|.bash|.command)";
              filetypes = [
                "sh"
                "zsh"
              ];
              maxNumberOfProblems = 100;
              enableSnippets = true;
              linting = {
                enabled = true;
                shellcheck = {
                  enable = true;
                  severity = "warning";
                };
              };
            };
          };
        };
        fish_lsp = {
          enable = true;
          settings = {
            fish = {
              suggest = {
                fromHistory = true;
                fromMan = true;
                fromCommands = true;
                fromFiles = true;
              };
            };
          };
        };
      };
      plugins = {
        conform-nvim.settings = {
          formatters = {
            shfmt = {
              command = getExe pkgs.shfmt;
              args = [
                "-i"
                "2"
                "-ci"
              ];
            };
            fish_indent = {
              command = getExe pkgs.fish;
              args = [
                "--no-config"
                "-c"
                "fish_indent"
              ];
            };
          };
          formatters_by_ft = {
            sh = [
              "shfmt"
            ];
            bash = [
              "shfmt"
            ];
            zsh = [
              "shfmt"
            ];
            fish = [
              "fish_indent"
            ];
          };
        };
        none-ls = {
          sources.diagnostics = {
            zsh = {
              enable = true;
            };
            fish = {
              enable = true;
            };
          };
        };
      };
    };
  };
}
