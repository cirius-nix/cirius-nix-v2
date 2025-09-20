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
  inherit (config.${namespace}.development.editors) nixvim;
in
{
  config = mkIf nixvim.enable {
    home.packages = with pkgs; [
      ripgrep
      ast-grep
      fd
    ];
    programs.nixvim = {
      keymaps = [
        (mkKeymap "<leader>ff" "<cmd>Telescope find_files<cr>" " Find File")
        (mkKeymap "<leader>fs" "<cmd>GrugFar<cr>" "󱄽 Search")
        (mkKeymap "<leader>fs" ":GrugFar<cr>" {
          mode = [ "v" ];
          options = {
            silent = true;
            noremap = true;
            nowait = true;
            desc = "󱄽 Search String";
          };
        })
        (mkKeymap "<leader>fi" "<cmd>Telescope nerdy<cr>" "󰲍 Icon picker")
        (mkKeymap "<leader>fr" "<cmd>Telescope resume<cr>" " Resume")
      ];
      plugins = {
        # Search & replace
        grug-far = {
          enable = true;
          settings = {
            debounceMs = 1000;
            engine = "ripgrep";
            engines = {
              ripgrep = {
                path = "${pkgs.ripgrep}/bin/rg";
                showReplaceDiff = true;
              };
            };
            maxSearchMatches = 2000;
            maxWorkers = 8;
            minSearchChars = 1;
            normalModeSearch = false;
          };
        };
        # Icon picker
        nerdy = {
          enable = true;
          enableTelescope = true;
        };
        # Multi-purpose searching
        telescope = {
          enable = true;
          extensions = {
            fzf-native.enable = true;
            ui-select.enable = true;
            frecency.enable = true;
            manix.enable = true;
          };
        };
      };
    };
  };
}
