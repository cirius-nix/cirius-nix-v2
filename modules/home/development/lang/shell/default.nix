{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption;
in {
  options.${namespace}.development.lang.shell = {
    enable = mkEnableOption "Enable shell Language Support";
  };
  config = let
    inherit (lib) mkIf getExe;
    cfg = config.${namespace}.development.lang.shell;
  in
    mkIf cfg.enable {
      home.packages = [
        pkgs.bash-language-server
        pkgs.shellcheck
        pkgs.shfmt
        pkgs.dotenv-linter
        pkgs.fish-lsp
      ];
      programs.nixvim = {
        lsp.servers = lib.${namespace}.enableAll ["bashls" "fish_lsp"] {
          bashls.config.bashIde = {
            globPattern = "**/*@(.sh|.inc|.bash|.command)";
            filetypes = ["sh" "zsh"];
            maxNumberOfProblems = 100;
            enableSnippets = true;
            linting = lib.${namespace}.enableAll ["shellcheck"] {
              enabled = true;
              shellcheck.severity = "warning";
            };
          };
          fish_lsp.config.fish.suggest = {
            fromHistory = true;
            fromMan = true;
            fromCommands = true;
            fromFiles = true;
          };
        };
        plugins = {
          conform-nvim.settings = {
            formatters = {
              shfmt = {
                command = getExe pkgs.shfmt;
                args = ["-i" "2" "-ci"];
              };
              fish_indent = {
                command = getExe pkgs.fish;
                args = ["--no-config" "-c" "fish_indent"];
              };
            };
            formatters_by_ft = {
              sh = ["shfmt"];
              bash = ["shfmt"];
              zsh = ["shfmt"];
              fish = ["fish_indent"];
            };
          };
          none-ls = {
            sources.diagnostics = lib.${namespace}.enableAll ["zsh" "fish"] {};
          };
        };
      };
    };
}
