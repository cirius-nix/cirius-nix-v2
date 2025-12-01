{
  config,
  namespace,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) getExe mkIf mkEnableOption;
in {
  options.${namespace}.term.zoxide = {
    enable = mkEnableOption "Enable zoxide, a smarter cd command";
  };
  config = let
    cfg = config.${namespace}.term.zoxide;
  in
    mkIf cfg.enable {
      ${namespace}.term.fish = {
        interactiveCMDs.zoxide = {
          command = getExe pkgs.zoxide;
          args = ["init" "fish" "|" "source"];
        };
      };
      home.packages = [pkgs.zoxide];
    };
}
