{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.${namespace}) nix;
  inherit (lib) mkIf mkEnableOption;
  inherit (config.snowfallorg) user;
in
{
  options.${namespace}.nix = {
    enable = mkEnableOption "Enable Nix package manager and related tools";
    cachix = {
      enable = mkEnableOption "Enable Cachix binary cache";
      configFile = lib.mkOption {
        type = lib.types.str;
        default = user.home.directory + "/.config/cachix/cachix.dhall";
        description = "Path to a custom cachix.dhall file to use (string of absolute path)";
      };
    };

    configFile = lib.mkOption {
      type = lib.types.str;
      default = user.home.directory + "/.config/nix/nix.conf";
      description = "Path to a custom nix.conf file to use (string of absolute path)";
    };
    sops = {
      cachixAuthToken = lib.mkOption {
        type = lib.types.str;
        default = "cachix_auth_token";
        description = "Auth token for Cachix to use with Nix";
      };
      ghAccessToken = lib.mkOption {
        type = lib.types.str;
        default = "gh/personal/access_token";
        description = "Access token for GitHub to use with Nix flakes";
      };
    };

  };
  config = mkIf nix.enable {
    home.packages = [ pkgs.nix-prefetch-github ];
    sops = {
      templates."nix.conf" = {
        path = nix.configFile;
        mode = "0400";
        content = ''
          access-tokens = github.com=${config.sops.placeholder."${nix.sops.ghAccessToken}"}
        '';
      };
      templates."cachixConfigFile" = mkIf nix.cachix.enable {
        path = nix.cachix.configFile;
        mode = "0400";
        content = ''
          { authToken =
              "${config.sops.placeholder."${nix.sops.cachixAuthToken}"}"
          , hostname = "https://cachix.org"
          , binaryCaches = [] : List { name : Text, secretKey : Text }
          }
        '';
      };
    };
  };
}
