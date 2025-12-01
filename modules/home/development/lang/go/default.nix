{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: {
  options.${namespace}.development.lang.go = {
    enable = lib.mkEnableOption "Enable Go Language Support";
  };
  config = let
    cfg = config.${namespace}.development.lang.go;
  in
    lib.mkIf cfg.enable {
      programs.go = {
        enable = true;
      };
      home.packages =
        (with pkgs; [
          gopls
          gotools
          golangci-lint-langserver
          gofumpt
          gosimports
          goimports-reviser
          air
        ])
        ++ (lib.optionals config.${namespace}.development.infra.iac.pulumi.enable (with pkgs; [
          pulumiPackages.pulumi-go
        ]));
      # terms
      ${namespace}.term.fish = {
        interactiveEnvs.GOBIN = "$HOME/go/bin";
        paths = ["$GOBIN"];
      };
      programs.nixvim = {
        # editors
        lsp.servers.gopls = {
          enable = true;
          config = {
            gopls = {
              analyses = {
                unusedparams = true;
                shadow = true;
              };
              staticcheck = true;
            };
          };
        };
        extraPlugins = [
          pkgs.vimPlugins.go-nvim
        ];
        extraConfigLuaPost = ''
          require('go').setup {}
        '';
        plugins = {
          none-ls.sources.code_actions = {
            gomodifytags.enable = true;
          };
          conform-nvim.settings = {
            formatters = {
              gofumpt.command = lib.getExe pkgs.gofumpt;
              goimports.command = lib.getExe' pkgs.gotools "goimports";
            };
            formatters_by_ft.go = [
              "goimports"
              "gofumpt"
            ];
          };
          neotest = {
            adapters.go = {
              enable = true;
              settings = {
                args = {
                  __raw = ''
                    {
                      "-v",
                      "-race",
                      "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
                    }
                  '';
                };
              };
            };
          };
        };
      };
    };
}
