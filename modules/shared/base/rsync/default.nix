{
  namespace,
  config,
  lib,
  ...
}: {
  options.${namespace}.base.rsync = {
    enable = lib.mkEnableOption "Enable rsync integration";
    port = lib.mkOption {
      type = lib.types.int;
      default = 3873;
      description = "Port for rsync daemon.";
    };
  };

  config = let
    rsyncCfg = config.${namespace}.base.rsync;
  in {
    services = {
      rsync = lib.mkIf rsyncCfg.enable {
        enable = true;
        jobs = {};
      };
      rsyncd = lib.mkIf rsyncCfg.enable {
        enable = true;
        port = rsyncCfg.port;
      };
    };
  };
}
