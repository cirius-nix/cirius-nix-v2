{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: {
  options.${namespace}.development.editors.nixvim.plugins.explorer = let
    inherit (lib) types;
    inherit (lib.${namespace}) listlib;
  in {
    alwaysShow = listlib.mkOption types.str [] "List of filenames to always show in the explorer";
    alwaysShowByPattern = listlib.mkOption types.str [] "List of filename patterns to always show in the explorer";
  };
  config = let
    inherit (lib.${namespace}.nixvim) mkKeymap;
    inherit (config.${namespace}.development.editors) nixvim;
  in
    lib.mkIf nixvim.enable {
      programs.nixvim = {
        extraPlugins = with pkgs; [vimPlugins.nvim-window-picker];
        extraConfigLuaPost = ''
          require 'window-picker'.setup {
            filter_rules = {
              bo = {
                filetype = {
                  'NvimTree',
                  'neo-tree',
                  'notify',
                  'snacks_notif',
                  'dapui_scopes',
                  'dapui_breakpoints',
                  'dapui_stacks',
                  'dapui_watches',
                  'dap-repl',
                  'dapui_console',
                },
              },
            },
          }
          _G.FUNCS.nvimtree_focus_or_close = function()
            local win = vim.api.nvim_get_current_win()
            if vim.bo.filetype == "NvimTree" then
              vim.cmd("NvimTreeClose")
            else
              vim.cmd("NvimTreeFindFile")
            end
          end
        '';
        keymaps = [
          (mkKeymap "<leader>e" "<cmd>lua _G.FUNCS.nvimtree_focus_or_close()<cr>" "󰙅 Toggle Explorer")
        ];
        # disable netrw is strongly advised.
        globals = {
          loaded_netrw = 1;
          loaded_netrwPlugin = 1;
        };
        opts = {
          termguicolors = lib.mkForce true; # optional by nvim-tree
        };
        plugins = {
          web-devicons.enable = true;
          nvim-tree = {
            enable = true;
            settings = {
              renderer.indent_markers.enable = true;
              renderer.icons = {
                git_placement = "after";
                modified_placement = "before";
                hidden_placement = "signcolumn";
                diagnostics_placement = "signcolumn";
              };
              sort = {
                sorter = "case_sensitive";
              };
              view = {
                width = 40;
              };
              filters = {
                dotfiles = true;
              };
            };
          };
        };
      };
    };
}
