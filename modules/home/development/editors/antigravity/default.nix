{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: {
  options.${namespace}.development.editors.antigravity.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Antigravity IDE.";
  };
  config = let
    antigravityCfg = config.${namespace}.development.editors.antigravity;
  in
    lib.mkIf antigravityCfg.enable {
      home.packages = with pkgs; [
        antigravity
      ];
    };
}
