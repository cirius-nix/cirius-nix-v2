{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.dev.lang) nix;
in
{
  options.${namespace}.dev.lang.nix = {
    enable = mkEnableOption "Enable Nix Language Support";
  };
  config = mkIf nix.enable {
    # `nix-shell` replacement for project development.
    # currently, MacOS support is not good enough.
    # https://github.com/nix-community/lorri
    services.lorri = mkIf pkgs.stdenv.isLinux {
      enable = true;
    };
  };
}
