{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (config.${namespace}.dev.editor) nixvim;
in
{
  config = mkIf nixvim.enable {
    programs.nixvim = {
      opts = {
        sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions";
      };
      plugins = {
        auto-session = {
          enable = true;
          settings = {
            bypass_save_filetypes = [
              "neo-tree"
              "dapui_scopes"
              "dapui_breakpoints"
              "dapui_stacks"
              "dapui_watches"
              "dapui_console"
              "dapui_repl"
            ];
          };
        };
      };
    };
  };
}
