{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.shell) fish;
in {
  options.${namespace}.shell.fish = {
    enable = mkEnableOption "Enable Fish Shell";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.fish;
      description = "Package to use for Fish Shell.";
    };
  };
  config = mkIf fish.enable {
    stylix.targets.fish.enable = true;
    programs.fish = {
      enable = true;
      inherit (fish) package;
    };
  };
}
