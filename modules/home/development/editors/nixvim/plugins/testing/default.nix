{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}.nixvim) mkKeymap;
  inherit (config.${namespace}.development.editors) nixvim;
in
{
  config = {
    programs.nixvim = mkIf nixvim.enable {
      keymaps = [
        # RunFile tr
        (mkKeymap "<leader>tr" "<cmd>Neotest run file<cr>" "RunFile")
        # Runlast tl
        (mkKeymap "<leader>tl" "<cmd>Neotest run last<cr>" "Runlast")
        # Coverage tc
        (mkKeymap "<leader>tc" "<cmd>Coverage<cr>" "Coverage")
        # CoverageSummary tC
        (mkKeymap "<leader>tC" "<cmd>CoverageSummary<cr>" "CoverageSummary")
        # TestSummary tt
        (mkKeymap "<leader>tt" "<cmd>Neotest summary toggle<cr>" "TestSummary")
        # TestOutput to
        (mkKeymap "<leader>to" "<cmd>Neotest output-panel toggle<cr>" "TestOutput")
      ];
      plugins = {
        coverage.enable = true;
        neotest = {
          enable = true;
          adapters = { };
        };
      };
    };
  };
}
