{
  config,
  namespace,
  lib,
  pkgs,
  system,
  inputs,
  host,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.development.lang) nix;
in {
  options.${namespace}.development.lang.nix = {
    enable = mkEnableOption "Enable Nix Language Support";
  };
  config = let
    alejandraPkg = inputs.alejandra.defaultPackage.${system};
    inherit (config.snowfallorg) user;
  in
    mkIf nix.enable {
      home.packages = [pkgs.nixfmt-rfc-style alejandraPkg];
      # `nix-shell` replacement for project development.
      # https://github.com/nix-community/lorri
      services = mkIf pkgs.stdenv.isLinux (lib.${namespace}.enableAll ["lorri"] {});
      programs.nixvim = {
        lsp.servers = lib.${namespace}.enableAll ["nil_ls" "nixd"] {
          nil_ls.config.formatting.command = [
            "${lib.getExe' pkgs.nixfmt-rfc-style "nixfmt"}"
          ];
          nixd = {
            config = let
              flake = ''(builtins.getFlake (builtins.toString ./.))'';
            in {
              nixPkgs.expr = "import ${flake}.inputs.pkgs {}";
              # command = [ "${lib.getExe' pkgs.nixfmt-rfc-style "nixfmt"}" ];
              formatting.command = [(lib.getExe alejandraPkg)];
              options = {
                nixvim.expr = ''${flake}.inputs.nixvim.nixvimConfigurations.${pkgs.system}.default.options'';
                nixos.expr = ''${flake}.nixosConfigutions.${host}.options'';
                nix-darwin.expr = ''${flake}.darwinConfigurations.${host}.options'';
                home-manager.expr = ''${flake}.homeConfigurations."${user.name}@${host}".options'';
              };
            };
          };
        };
        plugins = lib.${namespace}.enableAll ["nix-develop"] {
          telescope.extensions = lib.${namespace}.enableAll ["manix"] {};
          treesitter.nixvimInjections = true;
          none-ls.sources.code_actions = {
            statix.enable = true;
          };
          conform-nvim.settings = {
            formatters = {
              nixfmt.command = lib.getExe pkgs.nixfmt-rfc-style;
              alejandra.command = lib.getExe alejandraPkg;
            };
            formatters_by_ft = {
              nix = ["alejandra"];
            };
          };
        };
      };
    };
}
