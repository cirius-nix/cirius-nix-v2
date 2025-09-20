{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (config.${namespace}.development.editors) nixvim;
  inherit (lib) mkIf;
  inherit (lib.${namespace}.nixvim) mkKeymap;
in
{
  config = mkIf nixvim.enable {
    programs.nixvim = {
      keymaps = [
        (mkKeymap "<leader>ut" "<cmd>TransparentToggle<cr>" " Themes")
      ];
      plugins = {
        transparent = {
          enable = true;
          settings = {
            background = "transparent";
            border = "none";
          };
        };
        lualine = {
          enable = true;
          settings = { };
        };
      };
    };
  };
}
