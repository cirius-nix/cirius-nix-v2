{
  config,
  namespace,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.${namespace}.dev.cli) fish zoxide;
  inherit (lib) getExe mkIf mkEnableOption;
in
{
  options.${namespace}.dev.cli.zoxide = {
    enable = mkEnableOption "Enable zoxide, a smarter cd command";
  };
  config = mkIf zoxide.enable {
    home.packages = [ pkgs.zoxide ];
    ${namespace}.dev.cli = mkIf fish.enable {
      fish = {
        interactiveCMDs = {
          zoxide = {
            command = getExe pkgs.zoxide;
            args = [
              "init"
              "fish"
              "|"
              "source"
            ];
          };
        };
      };
    };
    # programs.fish.shellInit = mkIf fish.enable ''
    #   # zoxide
    #   if type -q zoxide
    #     ${pkgs.zoxide}/bin/zoxide init fish | source
    #   end
    # '';
  };
}
