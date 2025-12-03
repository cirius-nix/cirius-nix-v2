{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: let
  inherit (config.snowfallorg) user;
in {
  options.${namespace}.nix = let
    inherit (lib) mkEnableOption;
    inherit (lib.${namespace}) strlib;
  in {
    cachix = {
      enable = mkEnableOption "Enable Cachix binary cache";
      configFile = strlib.mkOption (user.home.directory + "/.config/cachix/cachix.conf") "Path to a custom cachix.conf file to use (string of absolute path)";
      secretKeys = {
        authToken = strlib.mkOption "cachix/auth_token" "SOPS key for Cachix auth token.";
      };
    };
    configFile = strlib.mkOption (user.home.directory + "/.config/nix/nix.conf") "Path to a custom nix.conf file to use (string of absolute path)";
  };
  config = let
    nixCfg = config.${namespace}.nix;
  in {
    home.packages = [pkgs.nix-prefetch-github];
    sops = {
      templates."${namespace}/${user.name}:${nixCfg.cachix.configFile}" = lib.mkIf nixCfg.cachix.enable {
        path = nixCfg.cachix.configFile;
        mode = "0400";
        content = ''
          {
            authToken = "${config.sops.placeholder."${nixCfg.cachix.secretKeys.authToken}"}"
          , hostname = "https://cachix.org"
          , binaryCaches = [] : List { name : Text, secretKey : Text }
          }
        '';
      };
    };
  };
}
