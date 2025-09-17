{
  config,
  namespace,
  lib,
  pkgs,
  host,
  ...
}:
let
  inherit (lib) mkIf getExe;
  inherit (config.snowfallorg) user;
  inherit (config.${namespace}.dev) lang;
in
{
  config = mkIf lang.nix.enable {
    programs.nixvim = {
      lsp.servers = {
        nil_ls = {
          enable = true;
          settings = { };
        };
        nixd = {
          enable = true;
          settings =
            let
              flake = ''(builtins.getFlake (builtins.toString ./.))'';
            in
            {
              nixPkgs = {
                expr = "import ${flake}.inputs.pkgs {}";
              };
              formatting = {
                command = [ "${getExe pkgs.nixfmt-rfc-style}" ];
              };
              options = {
                nixvim.expr = ''${flake}.inputs.nixvim.nixvimConfigurations.${pkgs.system}.default.options'';
                nixos.expr = ''${flake}.nixosConfigutions.${host}.options'';
                nix-darwin.expr = ''${flake}.darwinConfigurations.${host}.options'';
                home-manager.expr = ''${flake}.homeConfigurations."${user.name}@${host}".options'';
              };
            };
        };
      };
      plugins = {
        telescope = {
          extensions.manix = {
            enable = true;
          };
        };
        treesitter = {
          nixvimInjections = true;
        };
        nix-develop = {
          enable = true;
        };
        none-ls = {
          sources.code_actions = {
            statix.enable = true;
          };
        };
        conform-nvim.settings = {
          formatters = {
            nixfmt = {
              command = lib.getExe pkgs.nixfmt-rfc-style;
            };
          };
          formatters_by_ft = {
            nix = [ "nixfmt" ];
          };
        };
      };
    };
  };
}
