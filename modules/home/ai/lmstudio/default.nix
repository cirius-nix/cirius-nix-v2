{
  pkgs,
  lib,
  namespace,
  config,
  ...
}: {
  options.${namespace}.ai.lmstudio = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable LM Studio AI IDE.";
    };
  };
  config = let
    lmstudioCfg = config.${namespace}.ai.lmstudio;
  in
    lib.mkIf lmstudioCfg.enable {
      home.packages = with pkgs; [lmstudio];
    };
}
