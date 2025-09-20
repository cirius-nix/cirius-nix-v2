{
  config,
  namespace,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.${namespace}.development.command-line) fish zoxide;
  inherit (lib) getExe mkIf mkEnableOption;
in
{
  options.${namespace}.development.command-line.zoxide = {
    enable = mkEnableOption "Enable zoxide, a smarter cd command";
  };
  config = mkIf zoxide.enable {
    home.packages = [ pkgs.zoxide ];
    ${namespace}.development.command-line = mkIf fish.enable {
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
