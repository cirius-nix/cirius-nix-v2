{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: 
let 
  inherit (lib) mkIf;
  inherit (lib.${namespace}.nixvim) mkKeymap;
  inherit (config.${namespace}.dev.editor) nixvim;
in
{
  config = mkIf nixvim.enable {
    programs.nixvim = {
      keymaps = [
        (mkKeymap "<leader>e" "<cmd>lua _G.FUNCS.neotree_focus_or_close()<cr>" "󰙅 Toggle Explorer")
        (mkKeymap "<leader>fe" "<cmd>lua _G.FUNCS.neotree_focus_or_close('float')<cr>" "󰙅 Toggle Explorer")
      ];
      extraPlugins = with pkgs; [ vimPlugins.nvim-window-picker ];
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

        _G.FUNCS.neotree_focus_or_close = function(pos)
          if pos == nil then
            pos = 'left'
          end
          local win = vim.api.nvim_get_current_win()
          if vim.bo.filetype == "neo-tree" then
            vim.api.nvim_win_close(win, true)
          else
            ${if config.programs.nixvim.plugins.dap.enable then ''
              if _G.FUNCS.check_dapui_visible() then
                vim.cmd("Neotree focus position=float")
                return
              end
            '' else ''''}
            vim.cmd("Neotree focus position=" .. pos)
          end
        end
        '';
      plugins = {
        web-devicons.enable = true;
        neo-tree = {
          enable = true;
          filesystem = {
            useLibuvFileWatcher = true;
            followCurrentFile = {
              enabled = true;
            };
          };
          window.mappings = {
            "<c-v>" = "vsplit_with_window_picker";
            "<c-x>" = "split_with_window_picker";
            "x" = "cut_to_clipboard";
            "c" = "copy_to_clipboard";
            "<cr>" = "open_with_window_picker";
            "o" = "toggle_node";
            "e" = {
              command = "toggle_preview";
              config = { use_float = true; };
            };
          };
        };
      };
    };
  };
}
