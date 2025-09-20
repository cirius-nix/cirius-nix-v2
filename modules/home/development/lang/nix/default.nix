{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.development.lang) nix;
in
{
  options.${namespace}.development.lang.nix = {
    enable = mkEnableOption "Enable Nix Language Support";
  };
  config = mkIf nix.enable {
    # `nix-shell` replacement for project developmentelopment.
    # currently, MacOS support is not good enough.
    # https://github.com/nix-community/lorri
    services.lorri = mkIf pkgs.stdenv.isLinux {
      enable = true;
    };
  };
}
