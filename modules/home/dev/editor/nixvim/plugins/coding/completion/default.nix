{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    types
    mkEnableOption
    optional
    ;
  inherit (types) listOf str;
  inherit (config.${namespace}.dev.editor) nixvim;
in
{
  options.${namespace}.dev.editor.nixvim = {
    enableCopilot = mkEnableOption "Enable github copilot support";
    autocompleteSources = mkOption {
      type = listOf str;
      default = [ ];
      description = "Setting up additional completion sources";
    };
  };
  config = mkIf nixvim.enable {
    programs.nixvim = {
      extraConfigLuaPost = ''
        -- hide copilot suggestion when blink-cmp menu is open
        vim.api.nvim_create_autocmd('User', {
          pattern = "BlinkCmpMenuOpen",
          callback = function()
            require "copilot.suggestion".dismiss()
            vim.b.copilot_suggestion_hidden = true
          end
        })
        -- restore copilot suggestion when blink-cmp menu is closed
        vim.api.nvim_create_autocmd('User', {
          pattern = "BlinkCmpMenuClose",
          callback = function()
            vim.b.copilot_suggestion_hidden = false
          end
        })
      '';
      plugins = {
        mini = {
          enable = true;
          modules = {
            comment = { };
            pairs = { };
          };
        };
        copilot-lua = {
          enable = nixvim.enableCopilot;
          settings = {
            suggestion = {
              enabled = false;
            };
            panel = {
              enabled = false;
            };
          };
        };
        blink-cmp-copilot.enable = nixvim.enableCopilot;
        blink-cmp = {
          enable = true;
          settings = {
            keymap = {
              preset = "super-tab";
              "<cr>" = [
                "select_and_accept"
                "fallback"
              ];
              "<Tab>" = [
                "snippet_forward"
                "select_next"
                "fallback"
              ];
              "<S-Tab>" = [
                "snippet_backward"
                "select_prev"
                "fallback"
              ];
            };
            sources = {
              default = lib.concatLists [
                [
                  "lsp"
                  "path"
                  "buffer"
                ]
                # lib:optional :: Bool -> a -> [a]
                # lib:optionals:: Bool -> [a] -> [a]
                (optional nixvim.enableCopilot "copilot")
                nixvim.autocompleteSources
              ];
              providers = {
                copilot = {
                  async = true;
                  module = "blink-cmp-copilot";
                  name = "copilot";
                  score_offset = 100;
                };
              };
            };
            cmdline = {
              enabled = true;
              keymap = {
                preset = "cmdline";
              };
              sources = [
                "cmdline"
              ];
            };
            completion = {
              trigger = { };
              list = {
                selection = {
                  preselect = true;
                  auto_insert = true;
                };
              };
              keyword = {
                range = "full";
              };
              documentation = {
                auto_show = true;
                auto_show_delay_ms = 200;
              };
              ghost_text.enabled = true;
              menu = {
                draw = {
                  columns = [
                    [ "label" ]
                    [
                      "kind"
                      "kind_icon"
                    ]
                  ];
                  components = {
                    kind_icon = {
                      text = {
                        __raw = ''
                          function(ctx)
                            local icon = ctx.kind_icon
                            if vim.tbl_contains({"Path"}, ctx.source_name) then
                              local ok, nvim_web_devicons = pcall(require, "nvim-web-devicons")
                              if not ok then
                                return icon .. ctx.icon_gap
                              end
                              local dev_icon, _ = nvim_web_devicons.get_icon(ctx.label)
                              if dev_icon then
                                icon = dev_icon
                              end
                            end
                            return icon .. ctx.icon_gap
                          end
                        '';
                      };
                      highlight = {
                        __raw = ''
                          function(ctx)
                            local hl = ctx.kind_hl
                            if vim.tbl_contains({"Path"}, ctx.source_name) then
                              local ok, nvim_web_devicons = pcall(require, "nvim-web-devicons")
                              if not ok then
                                return hl
                              end
                              local dev_icon, dev_hl = nvim_web_devicons.get_icon(ctx.label)
                              if dev_icon then
                                hl = dev_hl
                              end
                            end
                            return hl
                          end
                        '';
                      };
                    };
                  };
                };
                # https://cmp.saghen.dev/recipes.html#hide-copilot-on-suggestion
                direction_priority = {
                  __raw = ''
                    function()
                      local ctx = require("blink.cmp").get_context()
                      local item = require("blink.cmp").get_selected_item()
                      if ctx == nil or item == nil then
                        return { 's', 'n' }
                      end
                      local item_text = item.textEdit ~= nil and item.textEdit.newText or item.insertText or item.label
                      local is_multi_line = item_text:find("\n") ~= nil
                      if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
                        vim.g.blink_cmp_upwards_ctx_id = ctx.id
                        return { 'n', 's' }
                      end
                      return { 's', 'n' }
                    end
                  '';
                };
              };
            };
            snippets = { };
            signature = {
              enabled = true;
            };
          };
        };
      };
    };
  };
}
