{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (config.${namespace}.dev.editor) nixvim;
  inherit (lib)
    mkIf
    mkEnableOption
    ;
  inherit (lib.${namespace}.nixvim) mkKeymap;
in
{
  options.${namespace}.dev.editor.nixvim = {
    enableStylixIntegration = mkEnableOption "Enable stylix integration for nixvim";
  };
  config = mkIf nixvim.enable {
    stylix.targets.nixvim.enable = nixvim.enableStylixIntegration;
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
