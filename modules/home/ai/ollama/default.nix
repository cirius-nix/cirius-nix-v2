{
  osConfig,
  config,
  lib,
  namespace,
  ...
}: {
  options.${namespace}.ai.ollama = let
    inherit (lib) mkEnableOption;
  in {
    enable = mkEnableOption "Enable Ollama AI CLI installation";
    port = lib.mkOption {
      type = lib.types.int;
      default = 11434;
      description = "Port for Ollama server.";
    };
  };
  config = let
    ollamaCfg = config.${namespace}.ai.ollama;
    nvidiaEnabled = osConfig.${namespace}.base.hardware.nvidia.enable;
  in {
    services.ollama = {
      inherit (ollamaCfg) enable port;
      host = "localhost";
      acceleration =
        if nvidiaEnabled
        then "cuda"
        else null;
    };
  };
}
