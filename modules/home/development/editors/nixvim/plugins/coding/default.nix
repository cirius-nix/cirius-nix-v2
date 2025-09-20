{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (config.${namespace}.development.editors) nixvim;
in
{
  config = mkIf nixvim.enable {
    home.packages = with pkgs; [
      tree-sitter
      libgcc
    ];
    programs.nixvim = {
      extraConfigLua = ''
        _M.coding = {
          ft_slow = {};
        };
      '';
      plugins = {
        none-ls = {
          enable = true;
        };
        lsp = {
          enable = true;
          keymaps = {
            diagnostic = {
              "]e" = "goto_next";
              "[e" = "goto_prev";
            };
            extra = [
              {
                action = "<cmd>lua vim.lsp.buf.format({ async = true })<cr>";
                key = "<leader>lF";
              }
              {
                action = "<cmd>Lspsaga goto_type_definition<cr>";
                key = "<leader>lD";
              }
              {
                action = "<cmd>Lspsaga code_action<cr>";
                key = "<leader>la";
              }
              {
                action = "<cmd>Lspsaga hover_doc<cr>";
                key = "K";
              }
              {
                action = "<cmd>Lspsaga goto_definition<cr>";
                key = "<leader>ld";
              }
              {
                action = "<cmd>Lspsaga finder<cr>";
                key = "<leader>lf";
              }
              {
                action = "<cmd>Lspsaga finder<cr>";
                key = "grr";
              }
              {
                action = "<cmd>Telescope lsp_document_symbols<cr>";
                key = "<leader>lo";
              }
              {
                action = "<cmd>Lspsaga rename mode=n<cr>";
                key = "<leader>lr";
              }
              {
                action = "<cmd>Lspsaga rename mode=n<cr>";
                key = "grn";
              }
              {
                action = "<cmd>Trouble diagnostics<cr>";
                key = "<leader>le";
              }
            ];
          };
          # language servers.
          servers = {
          };
        };
        lspsaga = {
          enable = true;
          settings = {
            finder = {
              keys = {
                toggle_or_open = "<CR>";
                vsplit = "<C-v>";
                split = "<C-x>";
                quit = "q";
              };
            };
          };
        };
        treesitter = {
          enable = true;
          settings = {
            highlight.enable = true;
            indent.enable = true;
          };
        };
        # formatter
        conform-nvim = {
          enable = true;
          settings = {
            format_on_save = ''
              function (bufnr)
                local filetype = vim.bo[bufnr].filetype
                if _M.coding.ft_slow[filetype] then
                  return
                end
                local function on_format(err)
                  if err and err:match("timeout$") then
                    _M.coding.ft_slow[filetype] = true
                  end
                end
                return { timeout_ms = 2000, lsp_fallback = true }, on_format
              end
            '';
            format_after_save = ''
              function (bufnr)
                local filetype = vim.bo[bufnr].filetype
                if not _M.coding.ft_slow[filetype] then
                  return
                end
                return { lsp_fallback = true }
              end
            '';
          };
        };
      };
    };
  };
}
